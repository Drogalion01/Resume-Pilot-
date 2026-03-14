import re

path = "backend/app/routes/resumes.py"
with open(path, "r", encoding="utf-8") as f:
    text = f.read()

new_logic = """      # 2. Store minimal artifacts directly (so client has resume record immediately)
      new_resume = Resume(
          user_id=current_user.id,
          title=title,
          file_type=file_type,
          raw_text=raw_text,
          parsed_json={},
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

      return to_analysis_response_dict(analysis)"""

replaced = re.sub(r"      # 2\. Structural Parse\s+parsed_data = parse_resume_text\(raw_text\).*?return to_analysis_response_dict\(analysis\)", new_logic, text, flags=re.MULTILINE|re.DOTALL)

with open(path, "w", encoding="utf-8") as f:
    f.write(replaced)

print("Regex applied.")
