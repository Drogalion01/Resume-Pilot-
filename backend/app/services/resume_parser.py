import re
from typing import Dict, Any

# Common headers indicating standard resume sections
SECTION_HEADERS_MAP = {
    "summary": ["summary", "professional summary", "about me", "profile", "career objective"],
    "experience": ["experience", "work experience", "employment history", "professional experience", "work history", "employment"],
    "education": ["education", "academic background", "academic history", "educational background"],
    "skills": ["skills", "core competencies", "technical skills", "expertise", "technologies"],
    "projects": ["projects", "personal projects", "academic projects", "open source"],
    "certifications": ["certifications", "licenses", "courses", "training"]
}

def clean_text(text: str) -> str:
    """Removes excessive whitespace."""
    # Collapse multiple newlines into max 2
    text = re.sub(r'\n{3,}', '\n\n', text)
    # Strip leading/trailing spaces on each line
    lines = [line.strip() for line in text.split('\n')]
    return '\n'.join(lines)

def detect_section_header(line: str) -> str | None:
    """
    Checks if a given line is likely a section header.
    Looks for short, standalone lines matching our known keywords.
    """
    clean_line = re.sub(r'[^A-Za-z ]', '', line).strip().lower()
    
    # Headers are usually short, let's limit to < 6 words and < 50 chars
    if len(clean_line.split()) > 6 or len(clean_line) > 50:
        return None

    for section_key, keywords in SECTION_HEADERS_MAP.items():
        if clean_line in keywords:
            return section_key
            
    return None

def parse_resume_text(raw_text: str) -> Dict[str, str]:
    """
    Takes raw resume text and parses it into structured dictionary keys:
    contact, summary, skills, experience, projects, education, certifications.
    Assumes everything before the first recognized header is "contact/header" info.
    """
    parsed_data = {
        "contact": [],
        "summary": [],
        "experience": [],
        "education": [],
        "skills": [],
        "projects": [],
        "certifications": [],
        "other": []
    }

    current_section = "contact"
    lines = raw_text.split('\n')
    
    for line in lines:
        stripped_line = line.strip()
        if not stripped_line:
            continue
            
        detected_header = detect_section_header(stripped_line)
        
        if detected_header:
            current_section = detected_header
        else:
            if current_section in parsed_data:
                parsed_data[current_section].append(stripped_line)
            else:
                parsed_data["other"].append(stripped_line)

    # Join the collected arrays back into string blocks
    final_json_structure = {
        k: '\n'.join(v) for k, v in parsed_data.items() if v
    }
    
    # Guarantee standard keys exist even if empty
    for key in parsed_data.keys():
        if key not in final_json_structure:
            final_json_structure[key] = ""
            
    return final_json_structure
