from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.resume import AnalysisResult
from app.services.resume_parser import parse_resume_text
from app.services.analysis_service import analyze_resume

def process_resume_background(
    db_analysis_id: int, 
    raw_text: str, 
    target_role: str,
    jd_text: str
):
    db: Session = SessionLocal()
    try:
        # Load from DB
        db_analysis = db.query(AnalysisResult).filter(AnalysisResult.id == db_analysis_id).first()
        if not db_analysis:
            return

        # Heavy processing
        parsed_data = parse_resume_text(raw_text)
        analysis_dict = analyze_resume(parsed_data, raw_text, target_role, jd_text)
        
        # Update db_analysis with the heavy data
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
        
        # We also need to update the resume's parsed json
        if db_analysis.resume:
            db_analysis.resume.parsed_json = parsed_data

        db.commit()
    except Exception as e:
        db.rollback()
        # Mark as failed
        db_analysis = db.query(AnalysisResult).filter(AnalysisResult.id == db_analysis_id).first()
        if db_analysis:
            db_analysis.status = "failed"
            db.commit()
    finally:
        db.close()
