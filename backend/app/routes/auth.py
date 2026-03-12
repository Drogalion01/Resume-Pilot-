from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.orm import Session
import requests
import uuid
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


BDAPPS_APP_ID = "APP_135994"
BDAPPS_PASSWORD = "f3aa7cfcf99bfe00c0174e9bd5517fbf"

@router.post("/phone/check")
@limiter.limit("5/minute")
def phone_check(request: Request, body: PhoneCheckRequest, db: Session = Depends(get_db)):
    """
    Check subscription status or send OTP.
    """
    phone = body.phone
    if not phone.startswith("tel:"):
        phone = f"tel:{phone}"
        
    url = "https://developer.bdapps.com/caas/direct/debit"
    payload = {
        "applicationId": BDAPPS_APP_ID,
        "password": BDAPPS_PASSWORD,
        "externalTrxId": str(uuid.uuid4()),
        "subscriberId": phone,
        "paymentInstrumentName": "MobileAccount"
    }
    
    headers = {"Content-Type": "application/json"}
    try:
        r = requests.post(url, json=payload, headers=headers, timeout=10)
        try:
            data = r.json()
        except Exception:
            raise HTTPException(status_code=502, detail=f"BDApps returned non-JSON response (HTTP {r.status_code})")
        
        status_code = data.get("statusCode")
        
        if status_code == "S1000":
            # Direct debit successful
            return {"status": "subscribed", "referenceNo": data.get("referenceNo", "")}
        elif status_code == "E1351":
            # Need OTP
            otp_url = "https://developer.bdapps.com/sms/otp/send"
            otp_payload = {
                "applicationId": BDAPPS_APP_ID,
                "password": BDAPPS_PASSWORD,
                "subscriberId": phone,
                "applicationHash": "YOUR_HASH" # can be empty
            }
            res_otp = requests.post(otp_url, json=otp_payload, headers=headers, timeout=10)
            try:
                otp_data = res_otp.json()
            except Exception:
                raise HTTPException(status_code=502, detail=f"BDApps OTP send returned non-JSON (HTTP {res_otp.status_code})")
            if otp_data.get("statusCode") == "S1000":
                return {"status": "subscribed", "referenceNo": otp_data.get("referenceNo", "")}
            else:
                raise HTTPException(status_code=400, detail=f"Failed to send OTP: {otp_data.get('statusDetail')}")
        else:
            return {"status": "requires_subscription", "loginUrl": data.get("loginUrl", "")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/phone/verify-otp")
@limiter.limit("10/minute")
def phone_verify_otp(request: Request, body: PhoneVerifyRequest, db: Session = Depends(get_db)):
    """
    Verify OTP and return JWT token.
    """
    phone = body.phone
    if not phone.startswith("tel:"):
        phone = f"tel:{phone}"
        
    url = "https://developer.bdapps.com/sms/otp/verify"
    payload = {
        "applicationId": BDAPPS_APP_ID,
        "password": BDAPPS_PASSWORD,
        "referenceNo": body.referenceNo,
        "otp": body.otp
    }
    
    headers = {"Content-Type": "application/json"}
    try:
        r = requests.post(url, json=payload, headers=headers, timeout=10)
        try:
            data = r.json()
        except Exception:
            raise HTTPException(status_code=502, detail=f"BDApps returned non-JSON response (HTTP {r.status_code})")
        if data.get("statusCode") != "S1000":
            raise HTTPException(status_code=400, detail=data.get("statusDetail", "Invalid OTP"))
            
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

