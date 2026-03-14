import requests
import time
import sys

BASE_URL = "http://localhost:8000/api/v1/resumes"
TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIiwiZXhwIjoxNzczNTMyOTEyfQ.bSHFms7Phe6NG9Xb-OrSCJ2y9a842PMG5Dv8EunZlh0"
HEADERS = {"Authorization": f"Bearer {TOKEN}"}

def test():
    print("Testing Analyze Endpoint...")
    try:
        # 1. Start Analysis
        resp = requests.post(
            f"{BASE_URL}/analyze", 
            data={"pasted_text": "Experienced Python developer with a strong background in FastAPI and background tasks.", "target_role": "Backend Engineer"},
            headers=HEADERS
        )
        if resp.status_code != 200:
            print(f"Failed to start analysis: {resp.status_code} - {resp.text}")
            sys.exit(1)
        
        data = resp.json()
        analysis_id = data.get("id")
        status = data.get("status")
        print(f"Analysis started. ID: {analysis_id}, Status: {status}")
        
        if status != "processing" and status != "completed":
            print(f"Unexpected status: {status}")
        
        # 2. Poll Status
        for i in range(15):
            print(f"Polling status... ({i+1}/15)")
            time.sleep(2)
            poll_resp = requests.get(f"{BASE_URL}/analyze/{analysis_id}/status", headers=HEADERS)
            if poll_resp.status_code != 200:
                print(f"Failed to poll: {poll_resp.status_code} - {poll_resp.text}")
                continue
            
            poll_data = poll_resp.json()
            new_status = poll_data.get("status")
            print(f"Current Status: {new_status}")
            
            if new_status in ["completed", "failed"]:
                print("Processing finished!")
                print(poll_data)
                sys.exit(0)
                
        print("Timeout waiting for processing to complete.")
        sys.exit(1)
    except Exception as e:
        print(f"Exception: {e}")

if __name__ == "__main__":
    test()
