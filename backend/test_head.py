from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)
response = client.head("/api/v1/health")
print("Status:", response.status_code)
