import re

path = "app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Add get_status route
new_route = """@router.get("/analyze/{analysis_id}/status", response_model=AnalysisResultResponse)
def get_analysis_status(
    analysis_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    # Verify the user actually owns the resume attached to this analysis
    db_analysis = db.query(AnalysisResult).join(Resume).filter(
        AnalysisResult.id == analysis_id,
        Resume.user_id == current_user.id
    ).first()
    
    if not db_analysis:
        raise HTTPException(status_code=404, detail="Analysis result not found")
        
    return to_analysis_response_dict(db_analysis)
"""

if "get_analysis_status" not in content:
    content = content + "\n" + new_route
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
print("Updated route with status polling")
