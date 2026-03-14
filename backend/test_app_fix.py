import re

path = "app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace the old process func with the new one
old_process = """def process_resume_background(
    db_analysis_id: int, 
    raw_text: str, 
    target_role: str,
    jd_text: str
):
    db: SessionLocal = SessionLocal()"""

new_process = """from app.database import SessionLocal

def process_resume_background(
    db_analysis_id: int, 
    raw_text: str, 
    target_role: str,
    jd_text: str
):
    db: Session = SessionLocal()"""

content = content.replace(old_process, new_process)
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
