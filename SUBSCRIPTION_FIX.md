# Subscription Re-activation Fix

## Problem
When a user unsubscribed and then re-subscribed with the same phone number using OTP, they were unable to access their account even after successful subscription payment. The error message was:
> "Your subscription has been cancelled. Please re-subscribe to continue."

## Root Cause
The `is_subscribed` flag in the database was not being updated when an unsubscribed user logged in again after re-subscribing. 

**Workflow that was broken:**
1. User subscribes → `is_subscribed = true` ✓
2. User unsubscribes → `is_subscribed = false` ✓
3. User re-subscribes with OTP → Backend verifies OTP ✓
   - BUT: `is_subscribed` remains `false` ❌
   - Any API request checks `is_subscribed` and returns 403 error ❌

## Solution
Fixed two authentication endpoints in `backend/app/routes/auth.py`:

### 1. **`POST /auth/phone/verify-otp`** (OTP verification after payment)
When an existing unsubscribed user successfully verifies OTP:
- Check if user exists and was previously unsubscribed
- Set `is_subscribed = True` in the database
- Return access token + user data

### 2. **`POST /auth/phone/session`** (Session-based login)
When an existing unsubscribed user starts a new session:
- Check if user exists and was previously unsubscribed  
- Set `is_subscribed = True` in the database
- Return access token + user data

## Code Changes

### File: `backend/app/routes/auth.py`

**Change 1: phone_verify_otp endpoint (line ~130)**
```python
# Before:
if not user:
    new_user = User(phone=phone, initials='U')
    # ... create user
else:
    # Just returned token, did nothing

# After:
if not user:
    new_user = User(phone=phone, initials='U', is_subscribed=True)
    # ... create user
else:
    # Existing user - if unsubscribed, re-enable subscription
    if not user.is_subscribed:
        user.is_subscribed = True
        db.commit()
```

**Change 2: phone_session endpoint (line ~165)**
```python
# Before:
if not user:
    new_user = User(phone=phone, initials='U')
    # ... create user
else:
    # Just returned token, did nothing

# After:
if not user:
    new_user = User(phone=phone, initials='U', is_subscribed=True)
    # ... create user
else:
    # Existing user - if unsubscribed, re-enable subscription
    if not user.is_subscribed:
        user.is_subscribed = True
        db.commit()
```

## New Workflow (Fixed)
1. User subscribes with phone → `is_subscribed = true` ✓
2. User unsubscribes → `is_subscribed = false` ✓
3. User sends OTP and pays subscription fee
4. User submits OTP → Backend verifies and now:
   - ✓ OTP verification succeeds
   - ✓ `is_subscribed` flag is updated to `true`
   - ✓ Access token returned
   - ✓ User can access ALL previous data immediately

## What Happens to Previous Data?
All user data (resumes, applications, interviews, notes) is preserved in the database:
- **Resumes table**: Linked by `user_id` - remains unchanged
- **Applications table**: Linked by `user_id` - remains unchanged  
- **Interview records**: Linked by `user_id` - remains unchanged
- **User settings**: Linked by `user_id` via `user_settings.user_id` - remains unchanged

When `is_subscribed` is set back to `true`, the `get_current_active_user` dependency allows access to all endpoints, and all data is immediately available.

## Testing Instructions

1. **Test Case 1: New Subscription**
   - Phone without subscription → Send OTP → Verify OTP
   - ✓ User created with `is_subscribed = true`
   - ✓ Can access app

2. **Test Case 2: Unsubscribe and Re-subscribe**
   - Subscribe a user → Verify OTP ✓
   - Unsubscribe → `is_subscribed = false` ✓
   - Send OTP again → Verify OTP
   - ✓ `is_subscribed` updated to `true`
   - ✓ Can access previous data (resumes, applications, etc.)

3. **Test Case 3: Session-based Login After Re-subscription**
   - Subscribe → Create user data ✓
   - Unsubscribe → `is_subscribed = false` ✓
   - Use `/auth/phone/session` after re-subscribing via BDApps
   - ✓ `is_subscribed` updated to `true`
   - ✓ Can access app

## Deployment

1. Deploy the updated `backend/app/routes/auth.py` file
2. No database migration needed (the `is_subscribed` column already exists)
3. No Flutter app changes needed (it was already calling the correct endpoint)
4. Existing unsubscribed users can immediately re-subscribe and access their data

## Note
The `get_current_user_allow_unsubscribed` dependency is still used for:
- Unsubscribe endpoint (`/auth/phone/unsubscribe`)
- Logout endpoint
- Any endpoints that need to work for both subscribed and unsubscribed users

The fix ensures that once OTP is verified or session is established after re-subscription, the user's `is_subscribed` status is synchronized with their BDApps subscription status.
