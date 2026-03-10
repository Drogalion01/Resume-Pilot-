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

# SettingsResponse / SettingsUpdate moved to schemas/settings.py — do not redeclare here.
