import sys
import os
sys.path.append(os.getcwd())
from app.database import SessionLocal
from sqlalchemy import text

db = SessionLocal()
res = db.execute(text("SELECT id FROM users LIMIT 1")).fetchone()
if res:
    print(f"USER_ID={res[0]}")
    from app.services.auth_service import create_access_token
    from datetime import timedelta
    token = create_access_token(data={"sub": str(res[0])}, expires_delta=timedelta(days=1))
    print(f"TOKEN={token}")
else:
    print("No user found")
