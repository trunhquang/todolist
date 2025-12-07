# Notification Architecture (Device Registration, FCM Token Sync, Push Triggers) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Notification Architecture** feature (each device has its own BE service, sync Firebase token + deviceId; use FCM push when adding/deleting/editing/assigning tasks, changing roles). This feature is currently **MISSING** - Only `NotificationEntity` exists; no device/FCM registration, no service layer, no push triggers.

## Prerequisites
- User must be logged in
- Device should have internet connection (for Firebase sync)
- Device should have notification permissions enabled
- FCM should be configured in Firebase project
- Multiple devices may be needed for testing

---

## Test Case 1: Device Registration on Login - Missing Feature

**Objective**: Verify device is registered with FCM token and deviceId when user logs in (currently missing).

**Preconditions**:
- User is not logged in
- Device registration feature is implemented
- Device has notification permissions

**Steps**:
1. Launch the app
2. Log in with valid credentials
3. Verify one of the following:
   - **If NOT implemented**: Device is not registered (this is expected - feature missing)
   - **If implemented**: Device registration happens
4. If implemented:
   - Verify device registration:
     - FCM token is retrieved
     - DeviceId is captured
     - Both are saved to Firebase database
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify device record exists:
       - `fcmToken` field contains token
       - `deviceId` field contains unique identifier
       - `platform` field contains platform (Android/iOS)
       - `deviceModel` field contains device model
       - `osVersion` field contains OS version
       - `registeredAt` timestamp is set
       - `lastActiveAt` timestamp is set
       - `isActive` is true
   - Verify registration doesn't block login:
     - Login completes successfully
     - No errors are shown to user

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Device registration is NOT implemented (missing)
- ✅ **When implemented**: Device is registered on login
- ✅ FCM token and deviceId are saved
- ✅ Login flow is not blocked

---

## Test Case 2: FCM Token Sync to Firebase - Missing Feature

**Objective**: Verify FCM token is synced to Firebase database (currently missing).

**Preconditions**:
- User is logged in
- FCM token sync is implemented

**Steps**:
1. Log in to the app
2. Verify one of the following:
   - **If NOT implemented**: Token is not synced (this is expected - feature missing)
   - **If implemented**: Token is synced
3. If implemented:
   - Get FCM token:
     - Token is retrieved from Firebase Messaging
     - Token is valid (not null/empty)
   - Verify token sync:
     - Token is saved to Firebase database
     - Token is saved under correct path: `users/{userId}/devices/{deviceId}/fcmToken`
     - Token is saved to local storage (for offline access)
   - Check Firebase database:
     - Navigate to device record
     - Verify `fcmToken` field matches retrieved token
     - Verify token is updated if it changes

**Expected Results**:
- ⚠️ **CURRENT STATUS**: FCM token sync is NOT implemented (missing)
- ✅ **When implemented**: Token is synced to Firebase
- ✅ Token is saved correctly
- ✅ Token persists across sessions

---

## Test Case 3: DeviceId Capture and Storage - Missing Feature

**Objective**: Verify deviceId is captured and stored (currently missing).

**Preconditions**:
- User is logged in
- DeviceId capture is implemented

**Steps**:
1. Log in to the app
2. Verify one of the following:
   - **If NOT implemented**: DeviceId is not captured (this is expected - feature missing)
   - **If implemented**: DeviceId is captured
3. If implemented:
   - Verify deviceId capture:
     - DeviceId is obtained from device_info_plus package
     - DeviceId is unique for this device
     - DeviceId is consistent across app restarts
   - Verify deviceId storage:
     - DeviceId is saved to Firebase database
     - DeviceId is saved to local storage
     - DeviceId is used as key for device record
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify `deviceId` field exists
     - Verify deviceId matches captured value

**Expected Results**:
- ⚠️ **CURRENT STATUS**: DeviceId capture is NOT implemented (missing)
- ✅ **When implemented**: DeviceId is captured and stored
- ✅ DeviceId is unique per device
- ✅ DeviceId persists across sessions

---

## Test Case 4: FCM Token Refresh Handling - Missing Feature

**Objective**: Verify FCM token refresh is handled and synced (currently missing).

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
     - New token is synced to Firebase database
     - Old token is replaced with new token
   - Verify refresh listener:
     - `onTokenRefresh` listener is set up
     - Listener triggers on token change
     - Listener updates database automatically
   - Check Firebase database:
     - Verify `fcmToken` field is updated
     - Verify `lastActiveAt` timestamp is updated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token refresh handling is NOT implemented (missing)
- ✅ **When implemented**: Token refresh is handled correctly
- ✅ New token is synced automatically
- ✅ Database is updated

---

## Test Case 5: Push Notification on Task Create - Missing Feature

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
   - Check notification log:
     - Notification delivery is logged
     - Success/failure status is recorded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task create is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task create
- ✅ Notification is delivered correctly
- ✅ Notification is logged

---

## Test Case 6: Push Notification on Task Update - Missing Feature

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

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task update is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task update
- ✅ Notification is delivered correctly

---

## Test Case 7: Push Notification on Task Delete - Missing Feature

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

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on task delete is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on task delete
- ✅ Notification is delivered correctly

---

## Test Case 8: Push Notification on Task Assign - Missing Feature

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

## Test Case 9: Push Notification on Role Change - Missing Feature

**Objective**: Verify push notification is sent when user role is changed (currently missing).

**Preconditions**:
- User is logged in
- User has permission to change roles
- Role change triggers push notification
- Push trigger is implemented

**Steps**:
1. User A (Admin) changes User B's role
2. Verify one of the following:
   - **If NOT implemented**: No push notification is sent (this is expected - feature missing)
   - **If implemented**: Push notification is sent
3. If implemented:
   - Verify notification is sent:
     - User B receives push notification
     - Notification indicates role change
     - Notification contains new role information
   - Verify notification content:
     - Notification title is appropriate
     - Notification body describes the role change
     - Notification payload contains role information

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push trigger on role change is NOT implemented (missing)
- ✅ **When implemented**: Push notification is sent on role change
- ✅ Notification is delivered correctly

---

## Test Case 10: Multiple Device Registration - Missing Feature

**Objective**: Verify multiple devices can be registered for same user (currently missing).

**Preconditions**:
- User account exists
- Multiple devices available
- Multiple device registration is implemented

**Steps**:
1. Log in to Device 1
2. Verify device registration:
   - Device 1 is registered
   - Device 1 has unique deviceId
   - Device 1 has FCM token
3. Log out from Device 1
4. Log in to Device 2 (same user)
5. Verify one of the following:
   - **If NOT implemented**: Device 2 is not registered (this is expected - feature missing)
   - **If implemented**: Device 2 is registered
6. If implemented:
   - Verify multiple devices:
     - Device 2 is registered
     - Device 2 has different deviceId
     - Device 2 has different FCM token
   - Check Firebase database:
     - Navigate to `users/{userId}/devices`
     - Verify multiple device records exist
     - Verify each device has unique deviceId
     - Verify each device has its own FCM token
   - Verify notifications:
     - Push notifications are sent to all devices
     - Each device receives notifications independently

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multiple device registration is NOT implemented (missing)
- ✅ **When implemented**: Multiple devices can be registered
- ✅ Each device has unique registration
- ✅ Notifications are sent to all devices

---

## Test Case 11: Token Revocation on Logout - Missing Feature

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
- ✅ Notifications are not sent to revoked device

---

## Test Case 12: Retry/Fallback Mechanism - Missing Feature

**Objective**: Verify retry/fallback mechanism works when notification sending fails (currently missing).

**Preconditions**:
- User is logged in
- Notification sending fails (simulated)
- Retry/fallback mechanism is implemented

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
   - Verify fallback:
     - If retry fails, fallback mechanism is used
     - Fallback may use local notification
     - Fallback may queue notification for later
   - Verify logging:
     - Retry attempts are logged
     - Failure reasons are logged
     - Final status (success/failure) is logged

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Retry/fallback mechanism is NOT implemented (missing)
- ✅ **When implemented**: Retry/fallback works correctly
- ✅ Notifications are eventually delivered
- ✅ Failures are handled gracefully

---

## Test Case 13: Invalid Token Cleanup - Missing Feature

**Objective**: Verify invalid tokens are cleaned up (currently missing).

**Preconditions**:
- User is logged in
- Invalid tokens exist
- Token cleanup is implemented

**Steps**:
1. Create invalid token scenario:
   - Device is uninstalled
   - Token expires
   - Token is invalidated
2. Attempt to send notification to invalid token
3. Verify one of the following:
   - **If NOT implemented**: Invalid tokens are not cleaned up (this is expected - feature missing)
   - **If implemented**: Token cleanup works
4. If implemented:
   - Verify cleanup:
     - Invalid token is detected
     - Invalid token is removed from database
     - Device record is updated or removed
     - Cleanup is logged
   - Verify notification handling:
     - Notifications are not sent to invalid tokens
     - Invalid tokens are excluded from notification lists
   - Check Firebase database:
     - Invalid tokens are removed
     - Device records are cleaned up

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Invalid token cleanup is NOT implemented (missing)
- ✅ **When implemented**: Invalid tokens are cleaned up
- ✅ Database is kept clean
- ✅ Notifications are not sent to invalid tokens

---

## Test Case 14: Push Notification Service Layer - Missing Feature

**Objective**: Verify push notification service layer exists and works (currently missing).

**Preconditions**:
- User is logged in
- Service layer is implemented

**Steps**:
1. Navigate to app
2. Verify one of the following:
   - **If NOT implemented**: No service layer (this is expected - feature missing)
   - **If implemented**: Service layer exists
3. If implemented:
   - Verify service layer:
     - `NotificationPushService` or similar exists
     - Service handles FCM token management
     - Service handles device registration
     - Service handles push notification sending
   - Verify service methods:
     - `registerDevice()` method exists
     - `sendPushNotification()` method exists
     - `revokeDevice()` method exists
     - `updateToken()` method exists
   - Verify service integration:
     - Service is initialized on app start
     - Service is used by controllers
     - Service handles errors gracefully

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push notification service layer is NOT implemented (missing)
- ✅ **When implemented**: Service layer exists and works
- ✅ Service methods are available
- ✅ Service is properly integrated

---

## Test Case 15: Push Notification Integration with Task Operations - Missing Feature

**Objective**: Verify push notifications are integrated with all task operations (currently missing).

**Preconditions**:
- User is logged in
- Task operations trigger push notifications
- Integration is implemented

**Steps**:
1. Test task create:
   - Create task assigned to another user
   - Verify push notification is sent
2. Test task update:
   - Update task assigned to another user
   - Verify push notification is sent
3. Test task delete:
   - Delete task assigned to another user
   - Verify push notification is sent
4. Test task assign:
   - Assign task to another user
   - Verify push notification is sent
5. Verify one of the following:
   - **If NOT implemented**: No push notifications are sent (this is expected - feature missing)
   - **If implemented**: Push notifications are sent for all operations
6. If implemented:
   - Verify integration:
     - All task operations trigger notifications
     - Notifications are sent to correct users
     - Notifications contain relevant information
   - Verify notification content:
     - Each operation has appropriate notification
     - Notification payloads are correct
     - Notifications are actionable

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Push notification integration is NOT implemented (missing)
- ✅ **When implemented**: Push notifications are integrated with task operations
- ✅ All operations trigger notifications
- ✅ Notifications are delivered correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Device registration on login works (missing)
- [ ] FCM token sync works (missing)
- [ ] DeviceId capture works (missing)
- [ ] Token refresh handling works (missing)
- [ ] Push on task create works (missing)
- [ ] Push on task update works (missing)
- [ ] Push on task delete works (missing)
- [ ] Push on task assign works (missing)
- [ ] Push on role change works (missing)
- [ ] Multiple device registration works (missing)
- [ ] Token revocation works (missing)
- [ ] Retry/fallback mechanism works (missing)
- [ ] Invalid token cleanup works (missing)
- [ ] Service layer exists (missing)
- [ ] Integration with task operations works (missing)

---

## Known Issues (Based on Audit Report)

1. **Notification Architecture Not Implemented**:
   - Only `NotificationEntity` exists
   - No device/FCM registration
   - No service layer
   - No push triggers
   - **Status**: ⛔ Missing

2. **Existing Components**:
   - `NotificationEntity` - data class for notifications
   - `NotificationService` - local notification service exists
   - `NotificationServiceImpl` - backend notification service exists but has TODOs
   - `firebase_messaging` package is in pubspec.yaml
   - `device_info_plus` package is in pubspec.yaml
   - FCM token can be retrieved but not saved to database

3. **Missing Components**:
   - No device registration entity/service
   - No deviceId capture
   - No FCM token sync to Firebase
   - No push triggers for task/project/workspace events
   - No retry/fallback mechanism
   - No token revocation flow

---

## Notes for Testers

1. **Current Status**: Notification architecture is completely missing:
   - No device registration
   - No FCM token sync
   - No push triggers
   - Only `NotificationEntity` data class exists

2. **Existing Components**: Some components exist but are incomplete:
   - `NotificationService` can get FCM token but doesn't save to database
   - `NotificationServiceImpl` has methods but with TODOs
   - Token refresh listener exists but doesn't update database

3. **Design Considerations**: When implementing, consider:
   - Device registration on login
   - FCM token sync to Firebase
   - Push triggers for all relevant events
   - Retry/fallback for failed notifications
   - Token revocation on logout
   - Multiple device support
   - Invalid token cleanup

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
- Whether device registration exists
- Whether FCM token is synced
- Whether push notifications are sent
- Firebase database state (if accessible)
- FCM token value (if accessible)
