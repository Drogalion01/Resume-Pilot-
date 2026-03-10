from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from jose import jwt, JWTError

from app.database import get_db
from app.config import settings
from app.models.user import User
from app.schemas.auth import TokenPayload

reusable_oauth2 = OAuth2PasswordBearer(
    tokenUrl=f"{settings.API_V1_STR}/auth/login"
)

def get_current_user(
    db: Session = Depends(get_db), token: str = Depends(reusable_oauth2)
) -> User:
    """
    Dependency to get the current authenticated user via JWT token.
    Throws 401 if token is invalid or user doesn't exist.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        user_id_str: str = payload.get("sub")
        if user_id_str is None:
            raise credentials_exception
        token_data = TokenPayload(sub=user_id_str)
    except JWTError:
        raise credentials_exception

    user = db.query(User).filter(User.id == int(token_data.sub)).first()
    if not user:
        raise credentials_exception
        
    return user

def get_current_active_user(
    current_user: User = Depends(get_current_user),
) -> User:
    """
    Dependency returning the currently authenticated user.
    Can be expanded later to check if user is 'active', 'suspended', etc.
    """
    # For MVP, all decoded valid users are 'active'
    return current_user

# Exposing dependencies for easy importing in routes
__all__ = ["get_db", "get_current_user", "get_current_active_user"]
