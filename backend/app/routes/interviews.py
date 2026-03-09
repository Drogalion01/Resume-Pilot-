from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User
from app.models.tracker import Application, Interview
from app.schemas.interview import InterviewBase, InterviewUpdate, InterviewResponse
from app.services.application_service import log_timeline_event

router = APIRouter()

def _get_user_interview(db: Session, interview_id: int, user_id: int) -> Interview:
    """Helper to fetch an interview and ensure its parent application belongs to the current user."""
    interview = (
        db.query(Interview)
        .join(Application, Interview.application_id == Application.id)
        .filter(Interview.id == interview_id, Application.user_id == user_id)
        .first()
    )
    if not interview:
        raise HTTPException(status_code=404, detail="Interview not found")
    return interview

# ---------------------------------------------------------
# INTERVIEWS DIRECT ROUTER (/api/v1/interviews)
# ---------------------------------------------------------

@router.get("/{id}", response_model=InterviewResponse)
def get_interview(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Retrieve details for a specific interview."""
    return _get_user_interview(db, id, current_user.id)

@router.patch("/{id}", response_model=InterviewResponse)
def update_interview(
    id: int,
    interview_update: InterviewUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Updates a specific interview and logs changes to the timeline if logic dictates."""
    interview = _get_user_interview(db, id, current_user.id)

    update_data = interview_update.model_dump(exclude_unset=True)
    
    old_status = interview.status
    new_status = update_data.get("status")
    
    for key, value in update_data.items():
        setattr(interview, key, value)

    # If the status is changing to something like "completed", log it automatically!
    if new_status and new_status != old_status:
        log_timeline_event(
            db=db,
            application_id=interview.application_id,
            event_type="interview_update",
            title=f"Interview {new_status.value.title()}",
            detail=f"{interview.round_name} interview marked as {new_status.value}."
        )

    db.commit()
    db.refresh(interview)
    return interview

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_interview(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Delete an interview instance gracefully."""
    interview = _get_user_interview(db, id, current_user.id)
    
    # We optionally log the removal so the timeline isn't fully ghosted
    log_timeline_event(
        db=db,
        application_id=interview.application_id,
        event_type="interview_cancelled",
        title="Interview Deleted",
        detail=f"{interview.round_name} interview was removed."
    )
    
    db.delete(interview)
    db.commit()
    return None

# ---------------------------------------------------------
# APPLICATION SUB-ROUTER MAP (/api/v1/applications)
# This mapping handles `POST /api/applications/{id}/interviews`
# but functionally exists inside this interviews.py file for cleanness.
# ---------------------------------------------------------

app_sub_router = APIRouter()

@app_sub_router.post("/{id}/interviews", response_model=InterviewResponse)
def create_interview_for_application(
    id: int,
    interview_in: InterviewBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Adds a newly scheduled interview directly chained to an Application ID."""
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")

    new_interview = Interview(
        application_id=application.id,
        round_name=interview_in.round_name,
        interview_type=interview_in.interview_type,
        date=interview_in.date,
        time=interview_in.time,
        timezone=interview_in.timezone,
        interviewer_name=interview_in.interviewer_name,
        meeting_link=interview_in.meeting_link,
        status=interview_in.status,
        notes=interview_in.notes,
        reminder_enabled=interview_in.reminder_enabled
    )
    
    db.add(new_interview)
    
    # Automatically drop a timeline event 
    log_timeline_event(
        db=db,
        application_id=application.id,
        event_type="interview_scheduled",
        title="Interview Scheduled",
        detail=f"Scheduled {new_interview.round_name} interview on {new_interview.date}."
    )

    db.commit()
    db.refresh(new_interview)
    
    return new_interview
