import re
path = "backend/app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("router = APIRouter()\nfrom app.models.resume import AnalysisResult", "router = APIRouter()\nversions_router = APIRouter()\n\nfrom app.models.resume import AnalysisResult")
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
