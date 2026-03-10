from datetime import datetime
from pydantic import BaseModel, ConfigDict



class SettingsBase(BaseModel):
    theme_preference: str = "system"
    email_notifications_enabled: bool = True
    interview_reminders_enabled: bool = True
    marketing_emails_enabled: bool = False

class SettingsUpdate(BaseModel):
    theme_preference: str | None = None
    email_notifications_enabled: bool | None = None
    interview_reminders_enabled: bool | None = None
    marketing_emails_enabled: bool | None = None

class SettingsResponse(SettingsBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
