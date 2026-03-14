import re
path = "app/schemas/analysis.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("overall_label: str | None = None", "overall_label: str | None = None\n    status: str = \"completed\"")
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
print("Schema updated")
