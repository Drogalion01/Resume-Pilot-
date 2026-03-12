from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.orm import Session
import requests
from app.schemas.auth import PhoneCheckRequest, PhoneVerifyRequest

from app.database import get_db
from app.dependencies import get_current_active_user
from app.limiter import limiter
from app.models.user import User, UserSettings
from app.schemas.user import UserResponse
from app.services.auth_service import create_access_token

router = APIRouter()

@router.get("/me", response_model=UserResponse)
def read_current_user(current_user: User = Depends(get_current_active_user)):
    """
    Get current logged in user details.
    """
    return current_user


BDAPPS_PHP_BASE_URL = "https://www.flicksize.com/resumepilot/"


def _normalize_phone(phone: str) -> str:
    value = phone.strip()
    if value.startswith("tel:880") and len(value) >= 14:
        return f"0{value[7:]}"
    if value.startswith("+880") and len(value) >= 13:
        return f"0{value[4:]}"
    if value.startswith("880") and len(value) >= 12:
        return f"0{value[3:]}"
    return value


def _post_php(endpoint: str, data: dict) -> dict:
    url = f"{BDAPPS_PHP_BASE_URL}{endpoint}"
    response = requests.post(url, data=data, timeout=15)
    try:
        payload = response.json()
    except Exception:
        raise HTTPException(
            status_code=502,
            detail=f"PHP BDApps API returned non-JSON from {endpoint} (HTTP {response.status_code})"
        )

    if not isinstance(payload, dict):
        raise HTTPException(status_code=502, detail=f"Unexpected payload from {endpoint}")

    return payload


def _send_bdapps_otp(phone: str) -> str:
    otp_data = _post_php("send_otp.php", {"user_mobile": phone})

    if otp_data.get("success") is not True:
        detail = otp_data.get("message") or otp_data.get("statusDetail") or "Failed to send OTP"
        raise HTTPException(status_code=400, detail=detail)

    reference_no = (otp_data.get("referenceNo") or "").strip()
    if not reference_no:
        raise HTTPException(status_code=502, detail="OTP send succeeded but referenceNo was empty")

    return reference_no

@router.post("/phone/check")
@limiter.limit("5/minute")
def phone_check(request: Request, body: PhoneCheckRequest, db: Session = Depends(get_db)):
    """
    Check subscription status using PHP BDApps API.
    """
    phone = _normalize_phone(body.phone)

    try:
        data = _post_php("check_subscription.php", {"user_mobile": phone})

        subscription_status = (data.get("subscriptionStatus") or "").strip().upper()
        is_subscribed = data.get("isSubscribed") is True or subscription_status == "REGISTERED"

        if is_subscribed:
            return {"status": "subscribed"}

        return {
            "status": "requires_subscription",
            "loginUrl": "",
            "statusCode": data.get("statusCode", ""),
            "statusDetail": data.get("statusDetail", "")
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/phone/send-otp")
@limiter.limit("5/minute")
def phone_send_otp(request: Request, body: PhoneCheckRequest):
    """
    Explicit OTP send endpoint to support check -> send OTP -> verify OTP flow.
    """
    phone = _normalize_phone(body.phone)
    reference_no = _send_bdapps_otp(phone)
    return {"status": "otp_sent", "referenceNo": reference_no}

@router.post("/phone/verify-otp")
@limiter.limit("10/minute")
def phone_verify_otp(request: Request, body: PhoneVerifyRequest, db: Session = Depends(get_db)):
    """
    Verify OTP and return JWT token.
    """
    phone = _normalize_phone(body.phone)

    try:
        data = _post_php("verify_otp.php", {
            "Otp": body.otp,
            "referenceNo": body.referenceNo,
            "user_mobile": phone,
        })

        if data.get("statusCode") != "S1000":
            raise HTTPException(
                status_code=400,
                detail=data.get("message") or data.get("statusDetail", "Invalid OTP")
            )
            
        # OTP verified — login or register user
        user = db.query(User).filter(User.phone == body.phone).first()
        if not user:
            # New subscriber — create a minimal account using phone as identity.
            # full_name and email remain null until the user fills in their profile.
            new_user = User(
                phone=body.phone,
                initials='U',
            )
            db.add(new_user)
            db.commit()
            db.refresh(new_user)
            
            default_settings = UserSettings(user_id=new_user.id)
            db.add(default_settings)
            db.commit()
            user = new_user
            
        access_token = create_access_token(data={"sub": str(user.id)})
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": {
                "id": user.id,
                "full_name": user.full_name,
                "email": user.email,
                "initials": user.initials,
                "phone": user.phone
            }
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

