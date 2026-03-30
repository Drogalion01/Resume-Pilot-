from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
import requests
from app.schemas.auth import PhoneCheckRequest, PhoneVerifyRequest, PhoneSessionRequest, UnsubscribeRequest, UnsubscribeResponse

from app.database import get_db
from app.dependencies import get_current_active_user, get_current_user_allow_unsubscribed
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


BDAPPS_PROXY_BASE_URL = "https://www.flicksize.com/resumepilot/"


def _normalize_phone(phone: str) -> str:
    normalized = phone.strip()
    if normalized.startswith("tel:"):
        normalized = normalized[4:]
    if normalized.startswith("880"):
        normalized = "0" + normalized[3:]
    return normalized


def _post_php_endpoint(endpoint: str, form_data: dict) -> dict:
    url = f"{BDAPPS_PROXY_BASE_URL}{endpoint}"
    res_otp = requests.post(url, data=form_data, timeout=15)
    try:
        otp_data = res_otp.json()
    except Exception:
        raise HTTPException(
            status_code=502,
            detail=f"BDApps PHP proxy returned non-JSON (HTTP {res_otp.status_code})"
        )
    if not isinstance(otp_data, dict):
        raise HTTPException(status_code=502, detail="BDApps PHP proxy returned invalid JSON shape")
    return otp_data


def _send_bdapps_otp(phone: str) -> str:
    otp_data = _post_php_endpoint("send_otp.php", {"user_mobile": phone})

    success = otp_data.get("success") is True
    status_code = (otp_data.get("statusCode") or "").strip().upper()
    if not success and status_code != "S1000":
        detail = otp_data.get("message") or otp_data.get("statusDetail") or "Failed to send OTP"
        raise HTTPException(status_code=400, detail=str(detail))

    reference_no = (otp_data.get("referenceNo") or "").strip()
    if not reference_no:
        raise HTTPException(status_code=502, detail="BDApps OTP send succeeded but referenceNo was empty")

    return reference_no

@router.post("/phone/check")
@limiter.limit("5/minute")
def phone_check(request: Request, body: PhoneCheckRequest, db: Session = Depends(get_db)):
    """
    Check subscription status or send OTP.
    """
    phone = _normalize_phone(body.phone)

    try:
        data = _post_php_endpoint("check_subscription.php", {"user_mobile": phone})
        subscription_status = (data.get("subscriptionStatus") or "").strip().upper()
        if subscription_status == "REGISTERED":
            return {"status": "subscribed"}
        return {"status": "not_subscribed"}
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
        data = _post_php_endpoint(
            "verify_otp.php",
            {
                "Otp": body.otp,
                "referenceNo": body.referenceNo,
                "user_mobile": phone,
            },
        )
        status_code = (data.get("statusCode") or "").strip().upper()
        if status_code != "S1000":
            detail = data.get("message") or data.get("statusDetail") or "Invalid OTP"
            raise HTTPException(status_code=400, detail=str(detail))
            
        # OTP verified — login or register user
        user = db.query(User).filter(User.phone == phone).first()
        if not user:
            # New subscriber — create a minimal account using phone as identity.
            # full_name and email remain null until the user fills in their profile.
            new_user = User(
                phone=phone,
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


@router.post("/phone/session")
@limiter.limit("10/minute")
def phone_session(request: Request, body: PhoneSessionRequest, db: Session = Depends(get_db)):
    """
    Create app session token for a phone already verified on client side via BDApps PHP APIs.
    This endpoint intentionally performs no OTP call to external providers.
    """
    phone = _normalize_phone(body.phone)

    try:
        user = db.query(User).filter(User.phone == phone).first()
        if not user:
            new_user = User(
                phone=phone,
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
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/phone/unsubscribe", response_model=UnsubscribeResponse)
@limiter.limit("5/minute")
def phone_unsubscribe(
    request: Request,
    body: UnsubscribeRequest,
    current_user: User = Depends(get_current_user_allow_unsubscribed),
    db: Session = Depends(get_db)
):
    """
    Unsubscribe a user from the service via BDApps.
    - Calls BDApps unsubscription.php
    - Marks user as inactive in database (preserves data for potential re-subscription)
    - User data is NOT deleted (they can resubscribe later)
    """
    phone = _normalize_phone(body.phone)
    
    # Verify the phone matches the authenticated user
    if current_user.phone != phone:
        raise HTTPException(
            status_code=403,
            detail="Cannot unsubscribe a different user's phone number"
        )
    
    try:
        # Call BDApps unsubscription endpoint
        unsub_data = _post_php_endpoint(
            "unsubscription.php",
            {"user_mobile": phone}
        )
        
        status_code = (unsub_data.get("statusCode") or "").strip().upper()
        subscription_status = (unsub_data.get("subscriptionStatus") or "").strip().upper()
        
        # Consider it successful if status code is S1000 or subscription is already UNREGISTERED
        success = status_code == "S1000" or subscription_status == "UNREGISTERED"
        
        if success:
            # Mark user as unsubscribed in the database
            current_user.is_subscribed = False
            db.commit()
            
            return UnsubscribeResponse(
                success=True,
                message="Successfully unsubscribed. Your account data is preserved.",
                phone=phone
            )
        else:
            detail = unsub_data.get("statusDetail") or "Failed to unsubscribe with BDApps"
            raise HTTPException(status_code=400, detail=str(detail))
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unsubscription error: {str(e)}")

