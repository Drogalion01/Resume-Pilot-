import re
from typing import Dict, Any, Tuple, List
from app.utils.scoring import clamp_score, calculate_weighted_score

def check_contact_completeness(contact_text: str) -> Tuple[int, List[Dict]]:
    """Scores contact section (Out of 100)."""
    score = 0
    issues = []
    
    has_email = bool(re.search(r'[\w\.-]+@[\w\.-]+', contact_text))
    has_phone = bool(re.search(r'\+?\d[\d -]{8,12}\d', contact_text))
    has_link = bool(re.search(r'(linkedin\.com|github\.com|http)', contact_text.lower()))
    
    if has_email: score += 40
    else: issues.append({"severity": "high", "description": "Missing email address in contact section."})
        
    if has_phone: score += 40
    else: issues.append({"severity": "high", "description": "Missing phone number in contact section."})
        
    if has_link: score += 20
    else: issues.append({"severity": "medium", "description": "No LinkedIn or portfolio link found."})
        
    return score, issues

def check_section_completeness(parsed_text: Dict[str, str]) -> Tuple[int, List[Dict]]:
    """Scores if all standard sections exist (Out of 100)."""
    score = 100
    issues = []
    
    required = ["experience", "education", "skills"]
    for req in required:
        if len(parsed_text.get(req, "").strip()) < 20: 
            score -= 30
            issues.append({"severity": "high", "description": f"Missing or dangerously short '{req.title()}' section."})
            
    return clamp_score(score), issues

def check_formatting_safety(raw_text: str) -> Tuple[int, List[Dict]]:
    """Scores formatting safety for ATS parsing (Out of 100)."""
    score = 100
    issues = []
    
    # Check for weird non-ascii bullets which often break ATS parsers
    bad_chars_count = len(re.findall(r'[^\x00-\x7F\•\–\-]', raw_text))
    if bad_chars_count > 5:
        score -= min(40, bad_chars_count * 2)
        issues.append({"severity": "medium", "description": "Unusual characters detected. Certain symbols/graphics may break ATS parsing."})
        
    # Check for excessive structural whitespace (indicates tables/columns)
    if raw_text.count('        ') > 5:
        score -= 20
        issues.append({"severity": "low", "description": "Heavy use of spacing detected. Avoid complex table structures."})

    return clamp_score(score), issues

def check_measurable_achievements(experience_text: str) -> Tuple[int, List[Dict]]:
    """Scores experience for metrics/numbers (Out of 100)."""
    score = 40 # Base score for having the section
    issues = []
    
    if not experience_text.strip(): return 0, issues
        
    # Look for numbers, percentages, dollars, etc.
    metrics = re.findall(r'\b\d+\b|\d+%|\$\d+', experience_text)
    
    if len(metrics) >= 5: score = 100
    elif len(metrics) >= 3: score = 80
    elif len(metrics) >= 1: 
        score = 60
        issues.append({"severity": "medium", "description": "Experience lacks quantified metrics. Add more numbers/data."})
    else:
        issues.append({"severity": "high", "description": "No measurable achievements found. Recruiters look for data-backed impact."})
        
    return score, issues

def check_action_verbs(experience_text: str) -> Tuple[int, List[Dict]]:
    """Scores experience for strong action verbs (Out of 100)."""
    strong_verbs = [
        "managed", "led", "developed", "created", "improved", "increased", 
        "implemented", "designed", "achieved", "orchestrated", "spearheaded", "reduced"
    ]
    
    score = 50
    issues = []
    found = 0
    words = experience_text.lower().split()
    
    for verb in strong_verbs:
        if verb in words:
            found += 1
            
    if found >= 4: score = 100
    elif found >= 2: score = 80
    else:
        issues.append({"severity": "medium", "description": "Weak action verbs. Start bullets with strong verbs like 'Spearheaded' or 'Optimized'."})
        
    return score, issues

def score_resume(parsed_data: Dict[str, str], raw_text: str) -> Dict[str, Any]:
    """Orchestrates deterministic scoring for ATS and Recruiter tracking."""
    
    contact_score, contact_issues = check_contact_completeness(parsed_data.get("contact", ""))
    section_score, section_issues = check_section_completeness(parsed_data)
    formatting_score, formatting_issues = check_formatting_safety(raw_text)
    
    exp_text = parsed_data.get("experience", "")
    metrics_score, metrics_issues = check_measurable_achievements(exp_text)
    verbs_score, verbs_issues = check_action_verbs(exp_text)
    
    # --- CALCULATE ATS SCORE ---
    ats_weights = {"contact": 20, "sections": 40, "formatting": 20, "metrics": 20}
    ats_scores = {
        "contact": contact_score, 
        "sections": section_score, 
        "formatting": formatting_score, 
        "metrics": metrics_score
    }
    ats_final = calculate_weighted_score(ats_scores, ats_weights)
    
    # --- CALCULATE RECRUITER SCORE ---
    recruiter_weights = {"metrics": 50, "verbs": 30, "sections": 20}
    recruiter_scores = {
        "metrics": metrics_score, 
        "verbs": verbs_score, 
        "sections": section_score
    }
    recruiter_final = calculate_weighted_score(recruiter_scores, recruiter_weights)
    
    all_issues = contact_issues + section_issues + formatting_issues + metrics_issues + verbs_issues
    
    breakdown = [
        {"category": "Completeness", "score": section_score, "max_score": 100},
        {"category": "Formatting", "score": formatting_score, "max_score": 100},
        {"category": "Quantifiable Impact", "score": metrics_score, "max_score": 100},
        {"category": "Action Verbs", "score": verbs_score, "max_score": 100},
    ]
    
    return {
        "ats_score": ats_final,
        "recruiter_score": recruiter_final,
        "overall_score": int((ats_final + recruiter_final) / 2),
        "issues": all_issues,
        "breakdown": breakdown
    }
