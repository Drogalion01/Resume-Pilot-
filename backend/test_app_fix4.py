import re
path = "app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("router = APIRouter()\n\ndef to_analysis_response_dict", "router = APIRouter()\nversions_router = APIRouter()\n\ndef to_analysis_response_dict")

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
