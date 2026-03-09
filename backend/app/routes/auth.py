from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User, UserSettings
from app.schemas.auth import LoginRequest, RegisterRequest, ForgotPasswordRequest
from app.schemas.user import UserResponse
from app.services.auth_service import verify_password, get_password_hash, create_access_token

router = APIRouter()

@router.post("/register")
def register(request: RegisterRequest, db: Session = Depends(get_db)):
    """
    Register a new user.
    """
    # Check if user already exists
    existing_user = db.query(User).filter(User.email == request.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Calculate initials
    name_parts = request.full_name.strip().split()
    initials = "".join([p[0].upper() for p in name_parts[:2]]) if name_parts else "U"

    # Create user
    new_user = User(
        email=request.email,
        password_hash=get_password_hash(request.password),
        full_name=request.full_name,
        initials=initials
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # Create default user settings strictly tied to this user
    default_settings = UserSettings(user_id=new_user.id)
    db.add(default_settings)
    db.commit()

    # Generate token
    access_token = create_access_token(data={"sub": str(new_user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": new_user.id,
            "full_name": new_user.full_name,
            "email": new_user.email,
            "initials": new_user.initials
        }
    }

@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    """
    Login user and return JWT token.
    """
    user = db.query(User).filter(User.email == request.email).first()
    if not user or not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(data={"sub": str(user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "full_name": user.full_name,
            "email": user.email,
            "initials": user.initials
        }
    }

@router.post("/forgot-password")
def forgot_password(request: ForgotPasswordRequest, db: Session = Depends(get_db)):
    """
    MVP forgot password endpoint.
    In a real system, this would trigger an email via the email service.
    For security, we always return a generic success message to prevent email enumeration.
    """
    # user = db.query(User).filter(User.email == request.email).first()
    # if user:
    #     # TODO: Generate password reset token, save to db, send via email
    #     pass

    return {
        "message": "If an account with that email exists, a password reset link has been sent."
    }

@router.get("/me", response_model=UserResponse)
def read_current_user(current_user: User = Depends(get_current_active_user)):
    """
    Get current logged in user details.
    """
    return current_user
