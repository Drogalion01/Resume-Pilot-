path = "app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

import re
content = re.sub(r'async def analyze_and_store_resume\(.*?\):', 
    r'''async def analyze_and_store_resume(
    background_tasks: BackgroundTasks,
    file: Optional[UploadFile] = File(None),
    pasted_text: Optional[str] = Form(None),
    target_role: Optional[str] = Form(None),
    company_name: Optional[str] = Form(None),
    jd_text: Optional[str] = Form(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):''', content, flags=re.DOTALL)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
print("Updated route signature")
