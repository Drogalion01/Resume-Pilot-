from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User, UserSettings
from app.schemas.user import UserResponse, UserUpdate
from app.schemas.settings import SettingsResponse, SettingsUpdate

router = APIRouter()

@router.get('/me', response_model=UserResponse)
def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user

@router.put('/me', response_model=UserResponse)
def update_user_me(update_data: UserUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    update_dict = update_data.model_dump(exclude_unset=True)
    for key, value in update_dict.items():
        setattr(current_user, key, value)
    db.commit()
    db.refresh(current_user)
    return current_user

@router.get('/settings', response_model=SettingsResponse)
def read_user_settings(db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    settings = db.query(UserSettings).filter(UserSettings.user_id == current_user.id).first()
    if not settings:
        settings = UserSettings(user_id=current_user.id)
        db.add(settings)
        db.commit()
        db.refresh(settings)
    return settings

@router.patch('/settings', response_model=SettingsResponse)
def update_user_settings(update_data: SettingsUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    settings = db.query(UserSettings).filter(UserSettings.user_id == current_user.id).first()
    if not settings:
        settings = UserSettings(user_id=current_user.id)
        db.add(settings)
    update_dict = update_data.model_dump(exclude_unset=True)
    for key, value in update_dict.items():
        setattr(settings, key, value)
    db.commit()
    db.refresh(settings)
    return settings
