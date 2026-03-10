from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.models.tracker import Application, TimelineEvent, Interview, Reminder, Note
from app.models.resume import ResumeVersion
from app.schemas.application import ApplicationDetailResponse
from datetime import datetime, timezone

def compose_application_detail(db: Session, application: Application) -> ApplicationDetailResponse:
    """
    Builds the rich composite 'Command Center' payload required by the 
    frontend's `ApplicationDetail` screen. Matches the `ApplicationDetailResponse` schema.
    """
    timeline_events = (
        db.query(TimelineEvent)
        .filter(TimelineEvent.application_id == application.id)
        .order_by(desc(TimelineEvent.timestamp))
        .all()
    )

    interviews = (
        db.query(Interview)
        .filter(Interview.application_id == application.id)
        .order_by(Interview.date, Interview.time)
        .all()
    )

    reminders = (
        db.query(Reminder)
        .filter(Reminder.application_id == application.id)
        .all()
    )

    notes = (
        db.query(Note)
        .filter(Note.application_id == application.id)
        .order_by(desc(Note.created_at))
        .all()
    )

    # Fetch associated resume version (if linked)
    resume_version = None
    if application.resume_version_id:
        resume_version = (
            db.query(ResumeVersion)
            .filter(ResumeVersion.id == application.resume_version_id)
            .first()
        )

    # Note: Because we use from_attributes=True in Pydantic, we can pass SQLA objects as kwargs
    return ApplicationDetailResponse(
        application=application,
        timeline_events=timeline_events,
        interviews=interviews,
        reminders=reminders,
        notes=notes,
        resume_version=resume_version
    )

def log_timeline_event(db: Session, application_id: int, event_type: str, title: str, detail: str = None):
    """Utility to auto-generate a timeline log entry whenever major actions happen."""
    event = TimelineEvent(
        application_id=application_id,
        event_type=event_type,
        title=title,
        detail=detail,
        timestamp=datetime.now(timezone.utc)
    )
    db.add(event)
    # Don't natively commit here, allow calling function to commit DB transactions 
