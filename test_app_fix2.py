import re
path = "backend/app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("versions_from app.database import SessionLocal\n", "")
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
