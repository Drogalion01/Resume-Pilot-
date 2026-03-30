from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict

class UserBase(BaseModel):
    email: EmailStr | None = None
    full_name: str | None = None
    phone: str | None = None
    initials: str | None = None
    is_subscribed: bool = True

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
