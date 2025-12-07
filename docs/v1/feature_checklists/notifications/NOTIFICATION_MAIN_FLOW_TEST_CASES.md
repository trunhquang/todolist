# Notification Main Flow (Token/DeviceId Save, Push Triggers, Retry/Fallback, Token Revocation) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Notification Main Flow** feature (save token/deviceId on login/refresh; push when task/project/workspace membership changes; retry/fallback; revoke token on logout). Currently, this feature is **MISSING** - `AuthController` saves ID token to StorageService (not FCM), no deviceId, no refresh/retry/revoke flows.

## Prerequisites
- User must be logged in
- Device should have internet connection (for Firebase sync)
- Device should have notification permissions enabled
- FCM should be configured in Firebase project
- Multiple users may be needed for testing

---

## Test Case 1: Save FCM Token and DeviceId on Login - Missing Feature

**Objective**: Verify FCM token and deviceId are saved when user logs in (currently missing - only ID token is saved).

**Preconditions**:
- User is not logged in
- Token/deviceId save on login is implemented
- Device has notification permissions

**Steps**:
1. Launch the app
2. Log in with valid credentials
3. Verify one of the following:
   - **If NOT implemented**: Only ID token is saved (this is expected - feature missing)
   - **If implemented**: FCM token and deviceId are saved
4. If implemented:
   - Verify FCM token is saved:
     - FCM token is retrieved from Firebase Messaging
     - FCM token is saved to Firebase database
     - FCM token is saved to local storage
     - Check Firebase database:
       - Navigate to `users/{userId}/devices/{deviceId}`
       - Verify `fcmToken` field exists and contains token
   - Verify deviceId is saved:
     - DeviceId is captured from device
     - DeviceId is saved to Firebase database
     - DeviceId is saved to local storage
     - Check Firebase database:
       - Navigate to `users/{userId}/devices/{deviceId}`
       - Verify `deviceId` field exists and contains unique identifier
   - Verify both are saved together:
     - FCM token and deviceId are linked in database
     - Device record contains both values
   - Verify login flow is not blocked:
     - Login completes successfully
     - No errors are shown to user
     - App functions normally after login

**Expected Results**:
- ⚠️ **CURRENT STATUS**: FCM token and deviceId save on login is NOT implemented (missing - only ID token is saved)
- ✅ **When implemented**: FCM token and deviceId are saved on login
- ✅ Both are saved to Firebase and local storage
- ✅ Login flow is not blocked

---

## Test Case 2: Save FCM Token and DeviceId on Token Refresh - Missing Feature

**Objective**: Verify FCM token and deviceId are saved when token is refreshed (currently missing).

**Preconditions**:
- User is logged in
- Device is registered
- Token refresh handling is implemented

**Steps**:
1. Log in to the app
2. Note current FCM token
3. Trigger token refresh (if possible) or wait for automatic refresh
4. Verify one of the following:
   - **If NOT implemented**: Token refresh is not handled (this is expected - feature missing)
   - **If implemented**: Token refresh is handled
5. If implemented:
   - Verify token refresh:
     - New token is retrieved
     - New token is different from old token
     - New token is saved to Firebase database
     - New token is saved to local storage
     - Old token is replaced with new token
   - Verify deviceId persists:
     - DeviceId remains the same
     - DeviceId is not changed on token refresh
     - Device record still contains deviceId
   - Verify refresh listener:
     - `onTokenRefresh` listener is set up
     - Listener triggers on token change
     - Listener updates database automatically
   - Check Firebase database:
     - Verify `fcmToken` field is updated
     - Verify `deviceId` field remains unchanged
     - Verify `lastActiveAt` timestamp is updated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token refresh handling is NOT implemented (missing)
- ✅ **When implemented**: Token refresh is handled correctly
- ✅ New token is saved automatically
- ✅ DeviceId persists across token refresh

---

## Test Case 3: Push Notification on Task Create - Missing Feature

**Objective**: Verify push notification is sent when task is created (currently missing).

**Preconditions**:
- User is logged in
- Another user exists
- Task creation triggers push notification
- Push trigger is implemented

**Steps**:
1. User A creates a task assigned to User B
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification title is appropriate (e.g., "New Task Assigned")
     - Notification body contains task information
     - Notification payload contains task ID
   - Verify notification delivery:
     - Notification appears on User B's device
     - Notification can be tapped to open task
     - Notification is logged in Firebase
   - Verify notification timing:
     - Notification is sent immediately after task creation
     - No significant delay in notification delivery
   - Check notification log:
     - Notification delivery is logged
     - Success/failure status is recorded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task create is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task create
- ✅ Notification is delivered correctly
- ✅ Notification is logged

---

## Test Case 4: Push Notification on Task Update - Missing Feature

**Objective**: Verify push notification is sent when task is updated (currently missing).

**Preconditions**:
- User is logged in
- Task exists assigned to user
- Task update triggers push notification
- Push trigger is implemented

**Steps**:
1. User A updates task assigned to User B
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification indicates task was updated
     - Notification contains relevant update information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the update
     - Notification payload contains task ID
   - Verify notification timing:
     - Notification is sent immediately after task update
     - No significant delay in notification delivery

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task update is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task update
- ✅ Notification is delivered correctly

---

## Test Case 5: Push Notification on Task Delete - Missing Feature

**Objective**: Verify push notification is sent when task is deleted (currently missing).

**Preconditions**:
- User is logged in
- Task exists assigned to user
- Task delete triggers push notification
- Push trigger is implemented

**Steps**:
1. User A deletes task assigned to User B
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification indicates task was deleted
     - Notification contains task information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the deletion
     - Notification payload contains task ID

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task delete is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task delete
- ✅ Notification is delivered correctly

---

## Test Case 6: Push Notification on Task Assign - Missing Feature

**Objective**: Verify push notification is sent when task is assigned (currently missing).

**Preconditions**:
- User is logged in
- Task exists
- Task assignment triggers push notification
- Push trigger is implemented

**Steps**:
1. User A assigns task to User B
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification indicates task assignment
     - Notification contains task information
   - Verify notification content:
     - Notification title is "New Task Assigned" or similar
     - Notification body contains task title and assigner name
     - Notification payload contains task ID

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task assign is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task assign
- ✅ Notification is delivered correctly

---

## Test Case 7: Push Notification on Project Create - Missing Feature

**Objective**: Verify push notification is sent when project is created (currently missing).

**Preconditions**:
- User is logged in
- Project creation triggers push notification
- Push trigger is implemented

**Steps**:
1. User A creates a project
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - Workspace members receive push notification
     - Notification indicates project was created
     - Notification contains project information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the project
     - Notification payload contains project ID

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on project create is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on project create
- ✅ Notification is delivered correctly

---

## Test Case 8: Push Notification on Project Update - Missing Feature

**Objective**: Verify push notification is sent when project is updated (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project update triggers push notification
- Push trigger is implemented

**Steps**:
1. User A updates project
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - Workspace members receive push notification
     - Notification indicates project was updated
     - Notification contains relevant update information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the update
     - Notification payload contains project ID

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on project update is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on project update
- ✅ Notification is delivered correctly

---

## Test Case 9: Push Notification on Workspace Membership Change - Missing Feature

**Objective**: Verify push notification is sent when workspace membership changes (currently missing).

**Preconditions**:
- User is logged in
- User has permission to manage workspace members
- Workspace membership change triggers push notification
- Push trigger is implemented

**Steps**:
1. User A adds User B to workspace
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification indicates workspace membership change
     - Notification contains workspace information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the membership change
     - Notification payload contains workspace ID
4. Test other membership changes:
   - Remove user from workspace
   - Change user role in workspace
   - Verify notifications are sent for each change

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on workspace membership change is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on workspace membership change
- ✅ Notification is delivered correctly

---

## Test Case 10: Retry Mechanism for Failed Push Notifications - Missing Feature

**Objective**: Verify retry mechanism works when push notification sending fails (currently missing).

**Preconditions**:
- User is logged in
- Notification sending fails (simulated)
- Retry mechanism is implemented

**Steps**:
1. Trigger notification (e.g., create task)
2. Simulate failure:
   - Network error
   - Invalid token error
   - Server error
3. Verify one of the following:
   - **If NOT implemented**: No retry mechanism (this is expected - feature missing)
   - **If implemented**: Retry mechanism works
4. If implemented:
   - Verify retry:
     - Notification sending is retried
     - Retry count is tracked
     - Retry uses exponential backoff
     - Maximum retry attempts are enforced
   - Verify retry success:
     - Notification is eventually sent successfully
     - Retry attempts are logged
   - Verify retry failure:
     - If all retries fail, fallback mechanism is used
     - Failure is logged appropriately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Retry mechanism is NOT implemented (missing)
- ✅ **When implemented**: Retry mechanism works correctly
- ✅ Notifications are eventually delivered
- ✅ Retry attempts are logged

---

## Test Case 11: Fallback Mechanism for Failed Push Notifications - Missing Feature

**Objective**: Verify fallback mechanism works when push notification sending fails after retries (currently missing).

**Preconditions**:
- User is logged in
- Notification sending fails after retries
- Fallback mechanism is implemented

**Steps**:
1. Trigger notification (e.g., create task)
2. Simulate failure that persists after retries
3. Verify one of the following:
   - **If NOT implemented**: No fallback mechanism (this is expected - feature missing)
   - **If implemented**: Fallback mechanism works
4. If implemented:
   - Verify fallback:
     - If retry fails, fallback mechanism is used
     - Fallback may use local notification
     - Fallback may queue notification for later
   - Verify fallback delivery:
     - Notification is eventually delivered via fallback
     - Fallback method is logged
   - Verify fallback logging:
     - Fallback attempts are logged
     - Failure reasons are logged
     - Final status (success/failure) is logged

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Fallback mechanism is NOT implemented (missing)
- ✅ **When implemented**: Fallback mechanism works correctly
- ✅ Notifications are eventually delivered
- ✅ Failures are handled gracefully

---

## Test Case 12: Token Revocation on Logout - Missing Feature

**Objective**: Verify device token is revoked when user logs out (currently missing).

**Preconditions**:
- User is logged in
- Device is registered
- Token revocation is implemented

**Steps**:
1. Log in to the app
2. Note device registration in Firebase
3. Log out from the app
4. Verify one of the following:
   - **If NOT implemented**: Token is not revoked (this is expected - feature missing)
   - **If implemented**: Token is revoked
5. If implemented:
   - Verify token revocation:
     - Device record is marked as inactive
     - `isActive` field is set to false
     - `revokedAt` timestamp is set
     - FCM token may be removed or marked invalid
   - Verify local storage cleanup:
     - FCM token is removed from local storage
     - DeviceId is removed from local storage
   - Check Firebase database:
     - Navigate to device record
     - Verify `isActive` is false
     - Verify `revokedAt` timestamp exists
   - Verify no notifications:
     - Push notifications are not sent to revoked device
     - Device is excluded from notification lists

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token revocation is NOT implemented (missing)
- ✅ **When implemented**: Token is revoked on logout
- ✅ Device is marked inactive
- ✅ Local storage is cleaned up
- ✅ Notifications are not sent to revoked device

---

## Test Case 13: Token Refresh on App Resume - Missing Feature

**Objective**: Verify FCM token is refreshed when app resumes (currently missing).

**Preconditions**:
- User is logged in
- Device is registered
- Token refresh on app resume is implemented

**Steps**:
1. Log in to the app
2. Note current FCM token
3. Close the app (background or force close)
4. Wait for some time
5. Resume the app
6. Verify one of the following:
   - **If NOT implemented**: Token is not refreshed (this is expected - feature missing)
   - **If implemented**: Token is refreshed
7. If implemented:
   - Verify token refresh:
     - New token is retrieved
     - New token is saved to Firebase database
     - New token is saved to local storage
   - Verify refresh timing:
     - Token refresh happens on app resume
     - No significant delay in token refresh
   - Check Firebase database:
     - Verify `fcmToken` field is updated
     - Verify `lastActiveAt` timestamp is updated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token refresh on app resume is NOT implemented (missing)
- ✅ **When implemented**: Token is refreshed on app resume
- ✅ New token is saved automatically

---

## Test Case 14: Multiple Push Notifications for Multiple Events - Missing Feature

**Objective**: Verify multiple push notifications are sent when multiple events occur (currently missing).

**Preconditions**:
- User is logged in
- Multiple events occur (e.g., multiple tasks created)
- Multiple push notifications are implemented

**Steps**:
1. User A creates multiple tasks assigned to User B
2. Verify one of the following:
   - **If NOT implemented**: No push notifications are sent (this is expected - feature missing)
   - **If implemented**: Multiple push notifications are sent
3. If implemented:
   - Verify notifications are sent:
     - User B receives multiple push notifications
     - Each notification corresponds to a task
     - Notifications are delivered in order
   - Verify notification content:
     - Each notification has correct task information
     - Notifications are not duplicated
     - Notifications are not lost
   - Verify notification handling:
     - All notifications are delivered
     - No notifications are missed
     - Notifications are logged correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multiple push notifications are NOT implemented (missing)
- ✅ **When implemented**: Multiple push notifications are sent correctly
- ✅ All notifications are delivered
- ✅ Notifications are not duplicated or lost

---

## Test Case 15: Push Notification Error Handling - Missing Feature

**Objective**: Verify error handling works when push notification sending fails (currently missing).

**Preconditions**:
- User is logged in
- Notification sending fails
- Error handling is implemented

**Steps**:
1. Trigger notification (e.g., create task)
2. Simulate various errors:
   - Network error
   - Invalid token error
   - Server error
   - Permission error
3. Verify one of the following:
   - **If NOT implemented**: Errors are not handled (this is expected - feature missing)
   - **If implemented**: Errors are handled
4. If implemented:
   - Verify error handling:
     - Errors are caught and handled gracefully
     - Error messages are logged
     - App continues to function normally
     - User is not shown error messages (unless critical)
   - Verify error logging:
     - Errors are logged with details
     - Error types are identified
     - Error timestamps are recorded
   - Verify error recovery:
     - App recovers from errors
     - Subsequent notifications work correctly
     - No permanent failures occur

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Error handling is NOT implemented (missing)
- ✅ **When implemented**: Errors are handled gracefully
- ✅ Errors are logged appropriately
- ✅ App continues to function normally

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] FCM token and deviceId save on login works (missing)
- [ ] FCM token and deviceId save on token refresh works (missing)
- [ ] Push on task create works (missing)
- [ ] Push on task update works (missing)
- [ ] Push on task delete works (missing)
- [ ] Push on task assign works (missing)
- [ ] Push on project create works (missing)
- [ ] Push on project update works (missing)
- [ ] Push on workspace membership change works (missing)
- [ ] Retry mechanism works (missing)
- [ ] Fallback mechanism works (missing)
- [ ] Token revocation on logout works (missing)
- [ ] Token refresh on app resume works (missing)
- [ ] Multiple push notifications work (missing)
- [ ] Error handling works (missing)

---

## Known Issues (Based on Audit Report)

1. **Main Flow Not Implemented**:
   - `AuthController` saves ID token to StorageService (not FCM)
   - No deviceId capture
   - No refresh/retry/revoke flows
   - No push triggers for task/project/workspace events
   - **Status**: ⛔ Missing

2. **Existing Components**:
   - `AuthController` exists and saves ID token
   - `StorageService` exists and can save tokens
   - `NotificationService` exists but doesn't handle FCM token save
   - No deviceId capture
   - No token refresh handling
   - No push triggers

3. **Missing Components**:
   - No FCM token save on login
   - No deviceId save on login
   - No token refresh handling
   - No push triggers for task operations
   - No push triggers for project operations
   - No push triggers for workspace membership changes
   - No retry/fallback mechanism
   - No token revocation on logout

---

## Notes for Testers

1. **Current Status**: Main flow is completely missing:
   - Only ID token is saved (not FCM token)
   - No deviceId capture
   - No refresh/retry/revoke flows
   - No push triggers

2. **Existing Components**: Some components exist but are incomplete:
   - `AuthController` saves ID token but not FCM token
   - `StorageService` can save tokens but FCM token is not saved
   - No deviceId capture or save

3. **Design Considerations**: When implementing, consider:
   - Save FCM token and deviceId on login
   - Handle token refresh automatically
   - Add push triggers for all relevant events
   - Implement retry/fallback for failed notifications
   - Revoke token on logout
   - Handle errors gracefully

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether FCM token is saved on login
- Whether deviceId is saved on login
- Whether push notifications are sent
- Whether retry/fallback works
- Whether token revocation works
- Firebase database state (if accessible)
- FCM token value (if accessible)
