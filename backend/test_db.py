import sys
import os
sys.path.append(os.path.join(os.getcwd(), "backend"))

from app.database import SessionLocal
from sqlalchemy import text

db = SessionLocal()
try:
    res = db.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'users'")).fetchall()
    print("Columns in users table:", [r[0] for r in res])
except Exception as e:
    print(f"Error: {e}")
