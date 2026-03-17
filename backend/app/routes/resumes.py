from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form, BackgroundTasks
from sqlalchemy.orm import Session

from app.database import get_db, SessionLocal
from app.dependencies import get_current_active_user
from app.models.user import User
from app.models.resume import Resume, ResumeVersion, AnalysisResult
from app.schemas.resume import ResumeResponse, ResumeVersionResponse, ResumeVersionBase
from app.schemas.analysis import AnalysisResultResponse

from app.utils.file_extractors import extract_text_from_file, FileExtractionError
from app.services.resume_parser import parse_resume_text
from app.services.analysis_service import analyze_resume
from app.services.storage_service import cloudinary_storage

# Two routers mapped to separate prefixes in main.py
router = APIRouter()
versions_router = APIRouter()

def to_analysis_response_dict(db_analysis: AnalysisResult) -> dict:
    """Helper to cleanly bypass SQLAlchemy JSON column variable names into Pydantic."""
    return {
        "id": db_analysis.id,
        "resume_id": db_analysis.resume_id,
        "resume_version_id": db_analysis.resume_version_id,
        "status": db_analysis.status,
        "overall_score": db_analysis.overall_score,
        "ats_score": db_analysis.ats_score,
        "recruiter_score": db_analysis.recruiter_score,
        "overall_label": db_analysis.overall_label,
        "breakdown": db_analysis.breakdown_json or [],
        "issues": db_analysis.issues_json or [],
        "missing_keywords": db_analysis.missing_keywords_json or [],
        "rewrites": db_analysis.rewrites_json or [],
        "action_plan": db_analysis.action_plan_json or [],
        "created_at": db_analysis.created_at,
        "updated_at": db_analysis.updated_at
    }

# --------------------------
# RESUMES ROUTER (/api/v1/resumes)
# --------------------------

@router.get("", response_model=List[ResumeResponse])
def get_resumes(
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_active_user)
):
    """Get all uploaded base resumes for the user."""
    return db.query(Resume).filter(Resume.user_id == current_user.id).order_by(Resume.created_at.desc()).all()

@router.get("/{id}", response_model=ResumeResponse)
def get_resume(
    id: int,
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_active_user)
):
    """Get precise base resume details."""
    resume = db.query(Resume).filter(Resume.id == id, Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resume not found")
    return resume

@router.get("/{id}/versions", response_model=List[ResumeVersionResponse])
def get_resume_versions(
    id: int,
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_active_user)
):
    """Get all tracked versions attached to a base resume."""
    versions = db.query(ResumeVersion).filter(ResumeVersion.resume_id == id, ResumeVersion.user_id == current_user.id).all()
    return versions

@router.post("/{id}/versions", response_model=ResumeVersionResponse)
def create_resume_version(
    id: int,
    version_data: ResumeVersionBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Add a new version iteration to an existing resume."""
    resume = db.query(Resume).filter(Resume.id == id, Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Original Resume not found")
        
    version = ResumeVersion(
        resume_id=resume.id,
        user_id=current_user.id,
        version_name=version_data.version_name,
        target_role=version_data.target_role,
        company_name=version_data.company_name,
        tag=version_data.tag,
        edited_text=version_data.edited_text or resume.raw_text
    )
    db.add(version)
    db.commit()
    db.refresh(version)
    return version

@router.get("/{id}/analysis", response_model=AnalysisResultResponse)
def get_resume_analysis(
    id: int,
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_active_user)
):
    """Retrieve saved deterministic analysis for a given resume."""
    resume = db.query(Resume).filter(Resume.id == id, Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="Resume not found")
        
    analysis = db.query(AnalysisResult).filter(AnalysisResult.resume_id == id).order_by(AnalysisResult.created_at.desc()).first()
    if not analysis:
        raise HTTPException(status_code=404, detail="No analysis found for this resume")
        
    return to_analysis_response_dict(analysis)



async def process_resume_background(
    analysis_id: int,
    resume_id: int,
    raw_text: str,
    target_role: Optional[str],
    jd_text: Optional[str],
    file_bytes: Optional[bytes],
    filename: Optional[str],
    user_id: int
):
    from app.database import SessionLocal
    db = SessionLocal()
    try:
        # 1. Cloudinary upload if needed
        original_file_url = None
        if file_bytes and filename:
            original_file_url = await cloudinary_storage.upload(
                file_bytes=file_bytes,
                filename=filename,
                user_id=user_id,
            )
            # Update resume with original file path
            db_resume = db.query(Resume).filter(Resume.id == resume_id).first()
            if db_resume:
                db_resume.original_file_path = original_file_url
                db.commit()

        # 2. Structural Parse
        parsed_data = parse_resume_text(raw_text)

        # 3. Logic Scoring
        analysis_dict = analyze_resume(parsed_data, raw_text, target_role, jd_text)
        
        # 4. Save results
        db_analysis = db.query(AnalysisResult).filter(AnalysisResult.id == analysis_id).first()
        if db_analysis:
            db_analysis.overall_score = analysis_dict.get("overall_score")
            db_analysis.ats_score = analysis_dict.get("ats_score")
            db_analysis.recruiter_score = analysis_dict.get("recruiter_score")
            db_analysis.overall_label = analysis_dict.get("overall_label")
            db_analysis.breakdown_json = analysis_dict.get("breakdown")
            db_analysis.issues_json = analysis_dict.get("issues")
            db_analysis.missing_keywords_json = analysis_dict.get("missing_keywords")
            db_analysis.rewrites_json = analysis_dict.get("rewrites")
            db_analysis.action_plan_json = analysis_dict.get("action_plan")
            db_analysis.status = "completed"
            
            db.commit()

        # 5. Update Resume parsed data
        db_resume = db.query(Resume).filter(Resume.id == resume_id).first()
        if db_resume:
            parsed_payload = parsed_data if isinstance(parsed_data, dict) else {}
            parsed_payload = dict(parsed_payload)
            parsed_payload["ats_score"] = analysis_dict.get("ats_score")
            parsed_payload["recruiter_score"] = analysis_dict.get("recruiter_score")
            parsed_payload["overall_score"] = analysis_dict.get("overall_score")
            parsed_payload["overall_label"] = analysis_dict.get("overall_label")
            db_resume.parsed_json = parsed_payload
            db.commit()

    except Exception as e:
        import traceback
        traceback.print_exc()
        db.rollback()
        db_analysis = db.query(AnalysisResult).filter(AnalysisResult.id == analysis_id).first()
        if db_analysis:
            db_analysis.status = "failed"
            db.commit()
    finally:
        db.close()


@router.get("/analyze/{analysis_id}/status", response_model=AnalysisResultResponse)
def check_analysis_status(
    analysis_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Poll for background analysis task status."""
    analysis = db.query(AnalysisResult).filter(AnalysisResult.id == analysis_id).first()
    if not analysis:
        raise HTTPException(status_code=404, detail="Analysis not found")
        
    # Security check to ensure the underlying resume belongs to the user
    resume = db.query(Resume).filter(Resume.id == analysis.resume_id, Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="Resume not found")
        
    return to_analysis_response_dict(analysis)


@router.post("/analyze", response_model=AnalysisResultResponse, status_code=status.HTTP_202_ACCEPTED)
async def analyze_and_store_resume(
    background_tasks: BackgroundTasks,
    file: Optional[UploadFile] = File(None),
    pasted_text: Optional[str] = Form(None),
    target_role: Optional[str] = Form(None),
    company_name: Optional[str] = Form(None),
    jd_text: Optional[str] = Form(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Core engine point: Accepts either a file upload or pure text.
    Extracts text synchronously, creates a processing placeholder, and delegates
    the LLM/Scoring logic to a Background Task. Returns HTTP 202 immediately.
    """
    if not file and not pasted_text:
        raise HTTPException(status_code=400, detail="Must provide either 'file' or 'pasted_text'")

    raw_text = ""
    file_type = "txt"
    title = f"{target_role or 'New'} Resume"

    file_bytes: Optional[bytes] = None
    filename: Optional[str] = None

    if file:
        file_type = file.filename.split('.')[-1].lower() if '.' in file.filename else 'txt'
        title = file.filename
        filename = file.filename
        try:
            file_bytes = await file.read()
            raw_text = extract_text_from_file(file_bytes, file.filename)
        except FileExtractionError as e:
            raise HTTPException(status_code=400, detail=str(e))
    else:
        raw_text = pasted_text.strip()

    if not raw_text:
        raise HTTPException(status_code=400, detail="Could not extract any understandable text from the input provided.")

    # 1. Store the initial artifacts to the tracking database natively
    new_resume = Resume(
        user_id=current_user.id,
        title=title,
        file_type=file_type,
        raw_text=raw_text,
        parsed_json={},
        original_file_path=None, # Will update in background
    )
    db.add(new_resume)
    db.flush() # Yields the new_resume.id inline

    # Create root original version mapping
    new_version = ResumeVersion(
        resume_id=new_resume.id,
        user_id=current_user.id,
        version_name="Original Upload",
        target_role=target_role,
        company_name=company_name,
        tag="general",
        edited_text=raw_text
    )
    db.add(new_version)
    db.flush()

    # Save logic mappings matching our database aliases -> Analysis Service Returns
    db_analysis = AnalysisResult(
        resume_id=new_resume.id,
        resume_version_id=new_version.id,
        status="processing",
        overall_score=None,
        ats_score=None,
        recruiter_score=None,
        overall_label="Processing",
        breakdown_json=[],
        issues_json=[],
        missing_keywords_json=[],
        rewrites_json=[],
        action_plan_json=[]
    )
    db.add(db_analysis)
    db.commit()
    db.refresh(db_analysis)

    # 2. Add Background Task
    background_tasks.add_task(
        process_resume_background,
        analysis_id=db_analysis.id,
        resume_id=new_resume.id,
        raw_text=raw_text,
        target_role=target_role,
        jd_text=jd_text,
        file_bytes=file_bytes,
        filename=filename,
        user_id=current_user.id
    )

    # Return perfectly parsed Pydantic schema using the helper mapper
    return to_analysis_response_dict(db_analysis)

# --------------------------
# RESUME VERSIONS ROUTER (/api/v1/resume-versions)
# --------------------------

@versions_router.patch("/{id}", response_model=ResumeVersionResponse)
def update_resume_version(
    id: int,
    version_update: ResumeVersionBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Applies discrete partial updates to an active tracked Resume iteration."""
    version = db.query(ResumeVersion).filter(ResumeVersion.id == id, ResumeVersion.user_id == current_user.id).first()
    if not version:
        raise HTTPException(status_code=404, detail="Resume version not found")

    update_data = version_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(version, key, value)
        
    db.commit()
    db.refresh(version)
    return version

@versions_router.post("/{id}/duplicate", response_model=ResumeVersionResponse)
def duplicate_resume_version(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Instantly spins off an exact replica of an existing iteration."""
    original = db.query(ResumeVersion).filter(ResumeVersion.id == id, ResumeVersion.user_id == current_user.id).first()
    if not original:
        raise HTTPException(status_code=404, detail="Resume version not found")
        
    duplicate = ResumeVersion(
        resume_id=original.resume_id,
        user_id=current_user.id,
        version_name=f"{original.version_name} (Copy)",
        target_role=original.target_role,
        company_name=original.company_name,
        tag=original.tag,
        edited_text=original.edited_text
    )
    db.add(duplicate)
    db.commit()
    db.refresh(duplicate)
    return duplicate
