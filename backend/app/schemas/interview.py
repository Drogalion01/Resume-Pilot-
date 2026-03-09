from datetime import date, time, datetime
from pydantic import BaseModel, ConfigDict
from app.models.tracker import InterviewStatus, InterviewType

class InterviewBase(BaseModel):
    round_name: str
    interview_type: InterviewType
    date: date
    time: time | None = None
    timezone: str | None = None
    interviewer_name: str | None = None
    meeting_link: str | None = None
    status: InterviewStatus = InterviewStatus.scheduled
    notes: str | None = None
    reminder_enabled: bool = False

class InterviewCreate(InterviewBase):
    application_id: int

class InterviewUpdate(BaseModel):
    round_name: str | None = None
    interview_type: InterviewType | None = None
    date: date | None = None
    time: time | None = None
    timezone: str | None = None
    interviewer_name: str | None = None
    meeting_link: str | None = None
    status: InterviewStatus | None = None
    notes: str | None = None
    reminder_enabled: bool | None = None

class InterviewResponse(InterviewBase):
    id: int
    application_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
