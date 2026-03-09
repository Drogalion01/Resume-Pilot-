import re
from typing import List, Dict

# Hardcoded MVP keyword banks based on standard roles
ROLE_KEYWORDS = {
    "software engineer": ["python", "java", "javascript", "react", "node", "sql", "aws", "docker", "agile", "api", "git", "ci/cd", "testing"],
    "data scientist": ["python", "r", "sql", "machine learning", "pandas", "numpy", "statistics", "visualization", "tensorflow", "etl"],
    "product manager": ["agile", "roadmap", "strategy", "user research", "jira", "kpis", "go-to-market", "wireframes", "scrum", "a/b testing"],
    "marketing": ["seo", "content", "b2b", "b2c", "analytics", "campaigns", "social media", "crm", "hubspot", "copywriting"]
}

def extract_keywords_from_jd(jd_text: str) -> List[str]:
    """
    MVP: Extracts potential keywords from a Job Description. 
    In the future, replace this with NLP/Spacy or an LLM call.
    """
    if not jd_text:
        return []
    # Very crude baseline: words with > 4 letters might be keywords, strip common stop words naturally
    words = re.findall(r'\b[A-Za-z-]{5,}\b', jd_text.lower())
    # Keep top frequent potentially
    return list(set(words[:30]))

def find_missing_keywords(resume_text: str, target_role: str = None, jd_text: str = None) -> List[Dict[str, str]]:
    """
    Identifies keywords that are missing from the resume based on the target role or JD.
    Returns format matches standard Pydantic missing keywords schema.
    """
    resume_lower = resume_text.lower()
    target_bank = []
    
    if target_role and target_role.lower() in ROLE_KEYWORDS:
        target_bank.extend(ROLE_KEYWORDS[target_role.lower()])
        
    if jd_text:
        target_bank.extend(extract_keywords_from_jd(jd_text))
        
    # Default fallback if nothing provided
    if not target_bank:
        target_bank = ROLE_KEYWORDS["software engineer"] # Base generic fallback

    target_bank = list(set(target_bank)) # Remove duplicates
    
    missing = []
    for word in target_bank:
        # Simple word boundary match
        if not re.search(r'\b' + re.escape(word) + r'\b', resume_lower):
            # Assign priority heuristically
            priority = "high" if len(word) > 5 else "medium" 
            missing.append({"word": word.title(), "priority": priority})
            
    # Limit returned missing keywords so the UI isn't overwhelmed
    return missing[:8]
