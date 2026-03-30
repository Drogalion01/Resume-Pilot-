from pydantic import BaseModel

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenPayload(BaseModel):
    sub: str | None = None

class PhoneCheckRequest(BaseModel):
    phone: str

class PhoneVerifyRequest(BaseModel):
    phone: str
    otp: str
    referenceNo: str

class PhoneSessionRequest(BaseModel):
    phone: str

class UnsubscribeRequest(BaseModel):
    phone: str

class UnsubscribeResponse(BaseModel):
    success: bool
    message: str
    phone: str | None = None

