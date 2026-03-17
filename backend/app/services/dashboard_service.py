from sqlalchemy.orm import Session
from datetime import date

from app.models.user import User
from app.models.resume import Resume, AnalysisResult
from app.models.tracker import Application, Interview, InterviewStatus
from app.schemas.dashboard import DashboardResponse, DashboardSummary, DashboardInsight


def _enrich_resume_scores(db: Session, resumes: list[Resume]) -> None:
    """Attach latest analysis scores into resume.parsed_json for dashboard rendering."""
    for resume in resumes:
        latest = (
            db.query(AnalysisResult)
            .filter(
                AnalysisResult.resume_id == resume.id,
                AnalysisResult.status == "completed",
            )
            .order_by(AnalysisResult.created_at.desc())
            .first()
        )
        if not latest:
            continue

        parsed = resume.parsed_json if isinstance(resume.parsed_json, dict) else {}
        parsed = dict(parsed)
        parsed["ats_score"] = latest.ats_score
        parsed["recruiter_score"] = latest.recruiter_score
        parsed["overall_score"] = latest.overall_score
        parsed["overall_label"] = latest.overall_label
        resume.parsed_json = parsed

def get_dashboard_data(db: Session, user: User) -> DashboardResponse:
    """
    Computes all standard fields required for the MVP frontend dashboard.
    """
    # 1. Compute summary stats
    total_resumes = db.query(Resume).filter(Resume.user_id == user.id).count()
    total_applications = db.query(Application).filter(Application.user_id == user.id).count()
    
    # We join Application to get the user context for the interview count
    total_interviews = (
        db.query(Interview)
        .join(Application)
        .filter(Application.user_id == user.id)
        .count()
    )

    # 2. Fetch recent resumes (limit 3)
    recent_resumes = (
        db.query(Resume)
        .filter(Resume.user_id == user.id)
        .order_by(Resume.created_at.desc())
        .limit(3)
        .all()
    )
    _enrich_resume_scores(db, recent_resumes)

    # 3. Fetch recent applications (limit 3)
    recent_applications = (
        db.query(Application)
        .filter(Application.user_id == user.id)
        .order_by(Application.created_at.desc())
        .limit(3)
        .all()
    )

    # 4. Fetch upcoming scheduled interviews (limit 3)
    today = date.today()
    upcoming_interviews = (
        db.query(Interview)
        .join(Application)
        .filter(
            Application.user_id == user.id,
            Interview.status == InterviewStatus.scheduled,
            Interview.date >= today
        )
        .order_by(Interview.date.asc(), Interview.time.asc())
        .limit(3)
        .all()
    )

    # 5. Generate a simple insight card (MVP logic)
    insight = DashboardInsight(
        trending_stat=f"{total_applications} Active Applications",
        description="Keep up the momentum! You're on track to land an interview soon."
    )

    summary = DashboardSummary(
        total_resumes=total_resumes,
        total_applications=total_applications,
        total_interviews=total_interviews
    )

    return DashboardResponse(
        user=user,
        summary=summary,
        insight=insight,
        recent_resumes=recent_resumes,
        upcoming_interviews=upcoming_interviews,
        recent_applications=recent_applications
    )
