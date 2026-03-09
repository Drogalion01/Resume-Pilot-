from datetime import datetime
from pydantic import BaseModel, ConfigDict

class TimelineEventBase(BaseModel):
    event_type: str
    title: str
    detail: str | None = None
    timestamp: datetime | None = None

class TimelineEventCreate(TimelineEventBase):
    application_id: int

class TimelineEventResponse(TimelineEventBase):
    id: int
    application_id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
