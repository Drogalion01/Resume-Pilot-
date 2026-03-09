from typing import Dict, Any
from app.utils.scoring import get_overall_label
from app.utils.keyword_matcher import find_missing_keywords
from app.services.resume_scorer import score_resume

def analyze_resume(parsed_data: Dict[str, str], raw_text: str, target_role: str = None, jd_text: str = None) -> Dict[str, Any]:
    """
    Main entry point for generating the full AnalysisResult payload 
    required by the Resume Analysis UI screen.
    """
    
    # 1. Run deterministic scoring
    scoring_result = score_resume(parsed_data, raw_text)
    
    # 2. Extract missing keywords
    missing_keywords = find_missing_keywords(raw_text, target_role, jd_text)
    
    # 3. Generate MVP UI placeholders for "Rewrites"
    # In a full production app, this would route to an OpenAI/FastAPI LLM call. 
    # For MVP, we provide deterministic examples to map to the RewriteItem schema.
    rewrites = [
        {
            "original": "Worked on improving the database queries for faster loading.",
            "improved": "Optimized database SQL queries, reducing page load times by 40%."
        },
        {
            "original": "Managed a team of developers.",
            "improved": "Spearheaded a cross-functional team of 6 engineers to deliver 3 major product releases."
        }
    ]
    
    # 4. Generate 'Action Plan' based on identified issues
    action_plan = []
    step_counter = 1
    
    # Map high severity issues to immediate action steps
    high_issues = [issue for issue in scoring_result["issues"] if issue["severity"] == "high"]
    for issue in high_issues[:2]:
        action_plan.append({
            "step": step_counter,
            "description": issue["description"],
            "potential_gain": "+15 pts"
        })
        step_counter += 1
        
    if missing_keywords and step_counter <= 3:
        keywords_str = ", ".join([mk["word"] for pos, mk in enumerate(missing_keywords) if pos < 3])
        action_plan.append({
            "step": step_counter,
            "description": f"Add missing critical keywords like: {keywords_str}.",
            "potential_gain": "+10 pts"
        })
        step_counter += 1
        
    # Default fallback plan if resume is somehow perfect
    if not action_plan:
        action_plan.append({
            "step": 1,
            "description": "Tailor your top experience bullet strictly to the job description.",
            "potential_gain": "Better Recruiter Match"
        })
    
    # Assemble the final dictionary mimicking schemas/analysis.py AnalysisResultResponse
    response_data = {
        "overall_score": scoring_result["overall_score"],
        "ats_score": scoring_result["ats_score"],
        "recruiter_score": scoring_result["recruiter_score"],
        "overall_label": get_overall_label(scoring_result["overall_score"]),
        "breakdown": scoring_result["breakdown"],
        "issues": scoring_result["issues"],
        "missing_keywords": missing_keywords,
        "rewrites": rewrites,
        "action_plan": action_plan
    }
    
    return response_data