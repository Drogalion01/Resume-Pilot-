import re

path = "app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Make sure our new background task is in the file or imported.
# Let's just inject the function into the file if not there.
if "def process_resume_background" not in content:
    with open("test_app.py", "r") as ta:
        func = ta.read()
    content = content.replace("router = APIRouter()", func + "\n\nrouter = APIRouter()")

# Replace the inner logic. 
old_logic = """    # 2. Structural Parse
    parsed_data = parse_resume_text(raw_text)

    # 3. Logic Scoring
    analysis_dict = analyze_resume(parsed_data, raw_text, target_role, jd_text)

    # 4. Store the artifacts to the tracking database natively
    new_resume = Resume(
        user_id=current_user.id,
        title=title,
        file_type=file_type,
        raw_text=raw_text,
        parsed_json=parsed_data,
        original_file_path=original_file_url,  # Cloudinary HTTPS URL, or None if pasted text
    )
    db.add(new_resume)
    db.flush() # Yields the new_resume.id inline

    # Create root original version mapping
    new_version = ResumeVersion(
        resume_id=new_resume.id,
        user_id=current_user.id,
        version_name="Original Upload",
        target_role=target_role,
        company_name=company_name,
        tag="general",
        edited_text=raw_text
    )
    db.add(new_version)
    db.flush()

    # Save logic mappings matching our database aliases -> Analysis Service Returns
    db_analysis = AnalysisResult(
        resume_id=new_resume.id,
        resume_version_id=new_version.id,
        overall_score=analysis_dict.get("overall_score"),
        ats_score=analysis_dict.get("ats_score"),
        recruiter_score=analysis_dict.get("recruiter_score"),
        overall_label=analysis_dict.get("overall_label"),
        breakdown_json=analysis_dict.get("breakdown"),
        issues_json=analysis_dict.get("issues"),
        missing_keywords_json=analysis_dict.get("missing_keywords"),
        rewrites_json=analysis_dict.get("rewrites"),
        action_plan_json=analysis_dict.get("action_plan")
    )
    db.add(db_analysis)
    db.commit()
    db.refresh(db_analysis)

    # Return perfectly parsed Pydantic schema using the helper mapper
    return to_analysis_response_dict(db_analysis)"""

new_logic = """    # 2. Store the placeholder artifacts to the DB immediately
    new_resume = Resume(
        user_id=current_user.id,
        title=title,
        file_type=file_type,
        raw_text=raw_text,
        parsed_json={}, # will be filled later
        original_file_path=original_file_url,  # Cloudinary HTTPS URL, or None if pasted text
    )
    db.add(new_resume)
    db.flush() 

    # Create root original version mapping
    new_version = ResumeVersion(
        resume_id=new_resume.id,
        user_id=current_user.id,
        version_name="Original Upload",
        target_role=target_role,
        company_name=company_name,
        tag="general",
        edited_text=raw_text
    )
    db.add(new_version)
    db.flush()

    # Save placeholder logic mapping
    db_analysis = AnalysisResult(
        resume_id=new_resume.id,
        resume_version_id=new_version.id,
        status="processing"
    )
    db.add(db_analysis)
    db.commit()
    db.refresh(db_analysis)

    # 3. KICK OFF BACKGROUND TASK
    background_tasks.add_task(
        process_resume_background,
        db_analysis_id=db_analysis.id,
        raw_text=raw_text,
        target_role=target_role or "",
        jd_text=jd_text or ""
    )

    # Return immediate placeholder Pydantic schema (FastAPI handles it natively)
    return to_analysis_response_dict(db_analysis)"""

content = content.replace(old_logic, new_logic)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
print("Updated route logic")
