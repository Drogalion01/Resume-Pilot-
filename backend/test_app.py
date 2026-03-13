from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)
response = client.get("/api/v1/health")
print("Status:", response.status_code)
print("Response:", response.json())
