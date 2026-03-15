import sys
import re

with open('backend/app/routes/resumes.py', 'r') as f:
    text = f.read()

# Add SessionLocal
if 'from app.database import SessionLocal, get_db' not in text:
    text = text.replace('from app.database import get_db', 'from app.database import get_db, SessionLocal')

BACKGROUND_TASK_CODE = '''

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
            db_resume.parsed_json = parsed_data
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

    # Create placeholder AnalysisResult
    db_analysis = AnalysisResult(
        resume_id=new_resume.id,
        resume_version_id=new_version.id,
        status="processing"
    )
    db.add(db_analysis)
    db.commit()
    db.refresh(db_analysis)
    
    # 2. Add background task 
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

    # Return placeholder
    return to_analysis_response_dict(db_analysis)

'''

# We need to replace the old analyze_and_store_resume
parts = re.split(r'@router\.post\(\"/analyze\"', text)

assert len(parts) == 2

new_text = parts[0] + BACKGROUND_TASK_CODE + "\n# --------------------------\n"

# Remove everything from parts[1] up to "# --------------------------" or end
remaining = parts[1]
if "# --------------------------" in remaining:
    remaining = remaining.split("# --------------------------", 1)[1]
else:
    # Just grab anything after GET /resumes or something
    remaining = ""
    
new_text = new_text + remaining
with open('backend/app/routes/resumes.py', 'w') as f:
    f.write(new_text)

print("Backend Async Background Task injected successfully!")
