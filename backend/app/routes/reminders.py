from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User
from app.models.tracker import Application, Reminder, Note
from app.schemas.reminder import ReminderBase, ReminderUpdate, ReminderResponse
from app.schemas.note import NoteBase, NoteUpdate, NoteResponse
from app.services.application_service import log_timeline_event

router = APIRouter()
app_sub_router = APIRouter()
notes_router = APIRouter()


# ---------------------------------------------------------
# REMINDERS LIST (/api/v1/reminders)
# ---------------------------------------------------------

@router.get("", response_model=List[ReminderResponse])
def get_reminders(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all reminders for the current user across all applications."""
    return (
        db.query(Reminder)
        .join(Application, Reminder.application_id == Application.id)
        .filter(Application.user_id == current_user.id)
        .order_by(Reminder.scheduled_for.asc())
        .all()
    )

def _get_user_reminder(db: Session, reminder_id: int, user_id: int) -> Reminder:
    """Helper to fetch a reminder mapped to a verified user application."""
    reminder = (
        db.query(Reminder)
        .join(Application, Reminder.application_id == Application.id)
        .filter(Reminder.id == reminder_id, Application.user_id == user_id)
        .first()
    )
    if not reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")
    return reminder


# ---------------------------------------------------------
# REMINDERS SUB-ROUTER MAP (/api/v1/applications/{id}/reminders & notes)
# ---------------------------------------------------------

@app_sub_router.post("/{id}/reminders", response_model=ReminderResponse)
def create_reminder_for_application(
    id: int,
    reminder_in: ReminderBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Adds a new reminder to an application tracker."""
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")

    new_reminder = Reminder(
        application_id=application.id,
        title=reminder_in.title,
        scheduled_for=reminder_in.scheduled_for,
        completed=reminder_in.completed,
        is_enabled=reminder_in.is_enabled
    )
    db.add(new_reminder)
    
    log_timeline_event(
        db=db,
        application_id=application.id,
        event_type="reminder_added",
        title="Reminder Set",
        detail=f"Set reminder: {reminder_in.title}."
    )
    
    db.commit()
    db.refresh(new_reminder)
    return new_reminder

@app_sub_router.patch("/{id}/notes", response_model=NoteResponse)
def upsert_application_note(
    id: int,
    note_update: NoteUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Upserts notes for an application. 
    The frontend generally passes a single large text block per application.
    """
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")

    # See if a note already exists
    note = db.query(Note).filter(Note.application_id == application.id).first()
    
    if note:
        note.content = note_update.content or ""
    else:
        note = Note(
            application_id=application.id,
            content=note_update.content or ""
        )
        db.add(note)

    db.commit()
    db.refresh(note)
    return note


@app_sub_router.post("/{id}/notes", response_model=NoteResponse, status_code=status.HTTP_201_CREATED)
def create_application_note(
    id: int,
    note_in: NoteBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Create a new note for an application.
    Multiple notes per application are supported.
    """
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")

    note = Note(application_id=application.id, content=note_in.content)
    db.add(note)
    db.commit()
    db.refresh(note)
    return note


# ---------------------------------------------------------
# DIRECT NOTES ROUTER (/api/v1/notes)
# ---------------------------------------------------------

def _get_user_note(db: Session, note_id: int, user_id: int) -> Note:
    """Helper to fetch a note and verify it belongs to the current user via its parent application."""
    note = (
        db.query(Note)
        .join(Application, Note.application_id == Application.id)
        .filter(Note.id == note_id, Application.user_id == user_id)
        .first()
    )
    if not note:
        raise HTTPException(status_code=404, detail="Note not found")
    return note


@notes_router.patch("/{id}", response_model=NoteResponse)
def update_note(
    id: int,
    note_update: NoteUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Update a specific note by ID."""
    note = _get_user_note(db, id, current_user.id)
    if note_update.content is not None:
        note.content = note_update.content
    db.commit()
    db.refresh(note)
    return note


@notes_router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_note(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Delete a note by ID."""
    note = _get_user_note(db, id, current_user.id)
    db.delete(note)
    db.commit()
    return None


# ---------------------------------------------------------
# DIRECT REMINDERS ROUTER (/api/v1/reminders)
# ---------------------------------------------------------

@router.patch("/{id}", response_model=ReminderResponse)
def update_reminder(
    id: int,
    reminder_update: ReminderUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Handles updating a reminder (usually marking as completed/disabled)."""
    reminder = _get_user_reminder(db, id, current_user.id)
    
    update_data = reminder_update.model_dump(exclude_unset=True)
    
    # Track completion flip for timeline context
    was_completed = reminder.completed
    is_completed_now = update_data.get("completed")

    for key, value in update_data.items():
        setattr(reminder, key, value)
        
    if is_completed_now is True and not was_completed:
        log_timeline_event(
            db=db,
            application_id=reminder.application_id,
            event_type="reminder_completed",
            title="Task Completed",
            detail=f"Completed task: {reminder.title}."
        )

    db.commit()
    db.refresh(reminder)
    return reminder

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_reminder(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Deletes a reminder cleanly."""
    reminder = _get_user_reminder(db, id, current_user.id)
    db.delete(reminder)
    db.commit()
    return None
