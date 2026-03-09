from datetime import datetime
from pydantic import BaseModel, ConfigDict

class ReminderBase(BaseModel):
    title: str
    scheduled_for: datetime | None = None
    completed: bool = False
    is_enabled: bool = True

class ReminderCreate(ReminderBase):
    application_id: int

class ReminderUpdate(BaseModel):
    title: str | None = None
    scheduled_for: datetime | None = None
    completed: bool | None = None
    is_enabled: bool | None = None

class ReminderResponse(ReminderBase):
    id: int
    application_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
