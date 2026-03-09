from datetime import date as dt_date, time as dt_time, datetime as dt_datetime
from pydantic import BaseModel, ConfigDict
from app.models.tracker import InterviewStatus, InterviewType

class InterviewBase(BaseModel):
    round_name: str
    interview_type: InterviewType
    date: dt_date
    time: dt_time | None = None
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
    date: dt_date | None = None
    time: dt_time | None = None
    timezone: str | None = None
    interviewer_name: str | None = None
    meeting_link: str | None = None
    status: InterviewStatus | None = None
    notes: str | None = None
    reminder_enabled: bool | None = None

class InterviewResponse(InterviewBase):
    id: int
    application_id: int
    created_at: dt_datetime
    updated_at: dt_datetime

    model_config = ConfigDict(from_attributes=True)
