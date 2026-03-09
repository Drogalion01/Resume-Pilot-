from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User
from app.models.tracker import Application
from app.schemas.application import ApplicationCreate, ApplicationUpdate, ApplicationResponse, ApplicationDetailResponse

from app.services.application_service import compose_application_detail, log_timeline_event

router = APIRouter()

@router.get("", response_model=List[ApplicationResponse])
def get_applications(
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_active_user)
):
    """Get all standard tracker applications for the logged-in user."""
    return db.query(Application).filter(Application.user_id == current_user.id).order_by(Application.created_at.desc()).all()

@router.post("", response_model=ApplicationResponse)
def create_application(
    app_in: ApplicationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Creates a new application block, auto-generating an Initial timeline event."""
    new_app = Application(
        user_id=current_user.id,
        **app_in.model_dump()
    )
    db.add(new_app)
    db.commit()
    db.refresh(new_app)
    
    # Auto-log Creation
    log_timeline_event(
        db=db, 
        application_id=new_app.id, 
        event_type="created", 
        title="Application Added", 
        detail=f"Created application for {new_app.role} at {new_app.company_name}."
    )
    db.commit()
    
    return new_app

@router.get("/{id}", response_model=ApplicationDetailResponse)
def get_application_detailed(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Returns the perfectly composed mega-payload matching the `ApplicationDetail` screen."""
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")
        
    return compose_application_detail(db, application)

@router.patch("/{id}", response_model=ApplicationResponse)
def update_application(
    id: int,
    app_update: ApplicationUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Handles partial status, note, or linked resume updates on the application object."""
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")

    update_data = app_update.model_dump(exclude_unset=True)
    
    # Check if status changed for Timeline logging
    old_status = application.status
    new_status = update_data.get("status")

    for key, value in update_data.items():
        setattr(application, key, value)
        
    db.add(application)
        
    if new_status and new_status != old_status:
        log_timeline_event(
            db=db,
            application_id=application.id,
            event_type="status_change",
            title=f"Status Updated",
            detail=f"Status moved from {old_status.value} to {new_status.value}."
        )
        
    db.commit()
    db.refresh(application)
    return application

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_application(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Deletes application completely (Cascading automatically handles linked interviews/notes)."""
    application = db.query(Application).filter(Application.id == id, Application.user_id == current_user.id).first()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")
        
    db.delete(application)
    db.commit()
    return None
