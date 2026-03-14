import sys
import os
sys.path.append(os.path.join(os.getcwd(), "backend"))
from app.database import SessionLocal
from sqlalchemy import text

db = SessionLocal()
db.execute(text("INSERT INTO users (full_name, phone) VALUES ('Test User', '0123456789') ON CONFLICT (phone) DO NOTHING;"))
db.commit()
res = db.execute(text("SELECT id FROM users LIMIT 1")).fetchone()
print(f"USER_ID={res[0] if res else 'None'}")
