from datetime import datetime
from pydantic import BaseModel, ConfigDict

class NoteBase(BaseModel):
    content: str

class NoteCreate(NoteBase):
    application_id: int

class NoteUpdate(BaseModel):
    content: str | None = None

class NoteResponse(NoteBase):
    id: int
    application_id: int
    updated_at: datetime
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
