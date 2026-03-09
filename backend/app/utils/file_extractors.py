import io
import re

try:
    import pdfplumber
except ImportError:
    pdfplumber = None

try:
    import docx
except ImportError:
    docx = None

ALLOWED_EXTENSIONS = {".pdf", ".docx", ".txt"}

class FileExtractionError(Exception):
    pass

def is_allowed_file(filename: str) -> bool:
    return any(filename.lower().endswith(ext) for ext in ALLOWED_EXTENSIONS)

def extract_text_from_pdf(file_bytes: bytes) -> str:
    if not pdfplumber:
        raise FileExtractionError("pdfplumber is not installed.")
    
    text = ""
    try:
        with pdfplumber.open(io.BytesIO(file_bytes)) as pdf:
            for page in pdf.pages:
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"
        return text.strip()
    except Exception as e:
        raise FileExtractionError(f"Error reading PDF: {str(e)}")

def extract_text_from_docx(file_bytes: bytes) -> str:
    if not docx:
        raise FileExtractionError("python-docx is not installed.")
        
    try:
        doc = docx.Document(io.BytesIO(file_bytes))
        return "\n".join([para.text for para in doc.paragraphs]).strip()
    except Exception as e:
        raise FileExtractionError(f"Error reading DOCX: {str(e)}")

def extract_text_from_txt(file_bytes: bytes) -> str:
    try:
        return file_bytes.decode('utf-8').strip()
    except UnicodeDecodeError:
        # Fallback to a broader encoding if utf-8 fails
        return file_bytes.decode('latin-1').strip()
    except Exception as e:
        raise FileExtractionError(f"Error reading TXT: {str(e)}")

def extract_text_from_file(file_bytes: bytes, filename: str) -> str:
    """
    Routes the file bytes to the correct extraction function based on file extension.
    """
    if not is_allowed_file(filename):
        raise FileExtractionError(f"Unsupported file type. Allowed: {', '.join(ALLOWED_EXTENSIONS)}")
        
    filename_lower = filename.lower()
    
    if filename_lower.endswith(".pdf"):
        return extract_text_from_pdf(file_bytes)
    elif filename_lower.endswith(".docx"):
        return extract_text_from_docx(file_bytes)
    elif filename_lower.endswith(".txt"):
        return extract_text_from_txt(file_bytes)
    
    raise FileExtractionError("Unknown error processing file.")
