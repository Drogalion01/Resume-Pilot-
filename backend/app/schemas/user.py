from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict

class UserBase(BaseModel):
    email: EmailStr
    full_name: str
    initials: str | None = None

class UserUpdate(BaseModel):
    full_name: str | None = None
    email: EmailStr | None = None
    initials: str | None = None

class UserResponse(UserBase):
    id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

class SettingsUpdate(BaseModel):
    dark_mode: bool | None = None
    email_notifications: bool | None = None
    resume_privacy: bool | None = None

class SettingsResponse(BaseModel):
    id: int
    user_id: int
    dark_mode: bool
    email_notifications: bool
    resume_privacy: bool

    model_config = ConfigDict(from_attributes=True)
