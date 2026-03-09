from datetime import datetime
from pydantic import BaseModel, ConfigDict
from typing import Any

class ResumeBase(BaseModel):
    title: str
    original_file_path: str | None = None
    file_type: str | None = None
    raw_text: str | None = None

class ResumeCreate(ResumeBase):
    pass

class ResumeResponse(ResumeBase):
    id: int
    user_id: int
    parsed_json: Any | None = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

class ResumeVersionBase(BaseModel):
    version_name: str | None = None
    target_role: str | None = None
    company_name: str | None = None
    tag: str | None = None
    edited_text: str | None = None

class ResumeVersionCreate(ResumeVersionBase):
    resume_id: int

class ResumeVersionResponse(ResumeVersionBase):
    id: int
    resume_id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
