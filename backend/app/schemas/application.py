from datetime import date, datetime
from pydantic import BaseModel, ConfigDict
from app.models.tracker import ApplicationStatus
from app.schemas.timeline import TimelineEventResponse
from app.schemas.interview import InterviewResponse
from app.schemas.reminder import ReminderResponse
from app.schemas.note import NoteResponse
from app.schemas.resume import ResumeVersionResponse
from typing import List

class ApplicationBase(BaseModel):
    company_name: str
    role: str
    status: ApplicationStatus = ApplicationStatus.saved
    application_date: date | None = None
    source: str | None = None
    location: str | None = None
    recruiter_name: str | None = None
    notes_summary: str | None = None
    resume_version_id: int | None = None

class ApplicationCreate(ApplicationBase):
    pass

class ApplicationUpdate(BaseModel):
    company_name: str | None = None
    role: str | None = None
    status: ApplicationStatus | None = None
    application_date: date | None = None
    source: str | None = None
    location: str | None = None
    recruiter_name: str | None = None
    notes_summary: str | None = None
    resume_version_id: int | None = None

class ApplicationResponse(ApplicationBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

class ApplicationDetailResponse(BaseModel):
    application: ApplicationResponse
    timeline_events: List[TimelineEventResponse] = []
    interviews: List[InterviewResponse] = []
    reminders: List[ReminderResponse] = []
    notes: List[NoteResponse] = []
    resume_version: ResumeVersionResponse | None = None

    model_config = ConfigDict(from_attributes=True)
