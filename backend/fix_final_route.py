import re

path = "backend/app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    text = f.read()

# First, let's remove duplicate process_resume_background
splits = text.split("def process_resume_background(")
if len(splits) > 2:
    # We have duplicates!
    text = splits[0] + "def process_resume_background(" + splits[-1]

# Now, let's rewrite the core of analyze_and_store_resume
# It starts at:
#       # 2. Structural Parse
#       parsed_data = parse_resume_text(raw_text)

old_logic = """      # 2. Structural Parse
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
          tag="Original",
          edited_text=raw_text
      )
      db.add(new_version)
      db.flush()

      # Map deterministic results 
      analysis = AnalysisResult(
          resume_id=new_resume.id,
          resume_version_id=new_version.id,
          overall_score=analysis_dict.get("overall_score", 0),
          ats_score=analysis_dict.get("ats_score", 0),
          recruiter_score=analysis_dict.get("recruiter_score", 0),
          overall_label=analysis_dict.get("overall_label", "Unknown"),
          breakdown_json=analysis_dict.get("breakdown", []),
          issues_json=analysis_dict.get("issues", []),
          missing_keywords_json=analysis_dict.get("missing_keywords", []),
          rewrites_json=analysis_dict.get("rewrites", []),
          action_plan_json=analysis_dict.get("action_plan", [])
      )
      db.add(analysis)
      db.commit()
      db.refresh(analysis)

      return to_analysis_response_dict(analysis)"""

new_logic = """      # 2. Store minimal artifacts directly (so client has resume record immediately)
      new_resume = Resume(
          user_id=current_user.id,
          title=title,
          file_type=file_type,
          raw_text=raw_text,
          parsed_json={}, # will be filled later in background task
          original_file_path=original_file_url,
      )
      db.add(new_resume)
      db.flush()

      new_version = ResumeVersion(
          resume_id=new_resume.id,
          user_id=current_user.id,
          version_name="Original Upload",
          target_role=target_role,
          company_name=company_name,
          tag="Original",
          edited_text=raw_text
      )
      db.add(new_version)
      db.flush()

      analysis = AnalysisResult(
          resume_id=new_resume.id,
          resume_version_id=new_version.id,
          status="processing",
          overall_score=0,
          ats_score=0,
          recruiter_score=0,
          overall_label="Processing",
          breakdown_json=[],
          issues_json=[],
          missing_keywords_json=[],
          rewrites_json=[],
          action_plan_json=[]
      )
      db.add(analysis)
      db.commit()
      db.refresh(analysis)

      # 3. Offload Heavy AI execution
      background_tasks.add_task(
          process_resume_background,
          db_analysis_id=analysis.id,
          raw_text=raw_text,
          target_role=target_role or "",
          jd_text=jd_text or ""
      )

      # 4. Immediately return the pending schema
      return to_analysis_response_dict(analysis)"""

if old_logic in text:
    text = text.replace(old_logic, new_logic)
    print("Successfully replaced logic!")
else:
    print("Could not find old logic block. Check exact string match.")

with open(path, "w", encoding="utf-8") as f:
    f.write(text)
