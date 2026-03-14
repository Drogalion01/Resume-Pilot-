import sys
import os
sys.path.append(os.path.join(os.getcwd(), "backend"))

from app.services.auth_service import create_access_token
from datetime import timedelta

token = create_access_token(data={"sub": "1"}, expires_delta=timedelta(days=1))
print(f"TEST_TOKEN={token}")
