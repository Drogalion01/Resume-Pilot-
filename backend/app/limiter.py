"""
Shared slowapi rate-limiter instance.

Import `limiter` here in any route file that needs rate limiting,
and wire it into the FastAPI app in main.py via app.state.limiter.
"""
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)
