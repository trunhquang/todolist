# FCM Token + DeviceId Registration - Test Cases

## Overview
This document contains step-by-step test cases for testing the **FCM Token + DeviceId Registration** feature for push notifications. This feature is currently **MISSING** - no deviceId capture, token saved only as ID token via `StorageService.setUserToken` (not FCM), and no push registration flow.

## Prerequisites
- User must be logged in
- Device should have internet connection (for Firebase sync)
- Device should have notification permissions enabled
- FCM should be configured in Firebase project

---

## Test Case 1: FCM Token Retrieval on Login - Missing Feature

**Objective**: Verify FCM token is retrieved and saved when user logs in.

**Preconditions**:
- User is not logged in
- FCM token registration feature is implemented
- Device has notification permissions

**Steps**:
1. Launch the app
2. Log in with valid credentials
3. Verify one of the following:
   - **If NOT implemented**: FCM token is not saved (this is expected - feature missing)
   - **If implemented**: FCM token is retrieved automatically
4. If implemented:
   - Verify FCM token is obtained from Firebase Messaging
   - Verify token is saved to Firebase database under user's device record
   - Verify token is saved to local storage (for offline access)
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify `fcmToken` field exists and contains token
     - Verify `registeredAt` timestamp is set
5. Verify token retrieval doesn't block login flow
6. Verify no errors occur during token retrieval

**Expected Results**:
- ⚠️ **CURRENT STATUS**: FCM token registration is NOT available (missing)
- ✅ **When implemented**: FCM token is retrieved on login
- ✅ Token is saved to Firebase
- ✅ Token is saved to local storage
- ✅ Login flow is not blocked

---

## Test Case 2: DeviceId Capture on Login - Missing Feature

**Objective**: Verify deviceId is captured and saved when user logs in.

**Preconditions**:
- User is not logged in
- DeviceId capture feature is implemented
- Device has unique identifier

**Steps**:
1. Launch the app
2. Log in with valid credentials
3. Verify one of the following:
   - **If NOT implemented**: DeviceId is not captured (this is expected - feature missing)
   - **If implemented**: DeviceId is captured automatically
4. If implemented:
   - Verify deviceId is obtained from device_info_plus package
   - Verify deviceId is unique for this device
   - Verify deviceId is saved to Firebase database under user's device record
   - Verify deviceId is saved to local storage
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify `deviceId` field exists and contains unique identifier
     - Verify device information is stored:
       - Platform (Android/iOS)
       - Device model
       - OS version
       - App version
5. Verify deviceId capture doesn't block login flow
6. Verify deviceId persists across app restarts

**Expected Results**:
- ⚠️ **CURRENT STATUS**: DeviceId capture is NOT available (missing)
- ✅ **When implemented**: DeviceId is captured on login
- ✅ DeviceId is unique per device
- ✅ DeviceId is saved to Firebase
- ✅ DeviceId persists across sessions

---

## Test Case 3: FCM Token + DeviceId Registration Flow

**Objective**: Verify complete registration flow saves both FCM token and deviceId.

**Preconditions**:
- User is not logged in
- FCM token + deviceId registration feature is implemented

**Steps**:
1. Launch the app
2. Log in with valid credentials
3. Verify registration flow:
   - FCM token is retrieved
   - DeviceId is captured
   - Both are saved together to Firebase
4. Check Firebase database structure:
   - Navigate to `users/{userId}/devices/{deviceId}`
   - Verify structure:
     ```json
     {
       "deviceId": "unique-device-id",
       "fcmToken": "fcm-token-string",
       "platform": "android" | "ios",
       "deviceModel": "device-model",
       "osVersion": "os-version",
       "appVersion": "app-version",
       "registeredAt": timestamp,
       "lastActiveAt": timestamp,
       "isActive": true
     }
     ```
5. Verify registration is atomic (both token and deviceId saved together or not at all)
6. Verify registration doesn't fail if one component fails

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Registration flow is NOT available (missing)
- ✅ **When implemented**: Both FCM token and deviceId are saved
- ✅ Registration is atomic
- ✅ Database structure is correct

---

## Test Case 4: FCM Token Refresh Handling

**Objective**: Verify FCM token refresh is handled and updated in Firebase.

**Preconditions**:
- User is logged in
- FCM token is registered
- Token refresh handling feature is implemented

**Steps**:
1. Log in to the app
2. Verify FCM token is registered
3. Simulate token refresh (or wait for automatic refresh):
   - FCM may refresh token automatically
   - OR manually trigger refresh (if implemented)
4. Verify one of the following:
   - **If NOT implemented**: Token refresh is not handled (this is expected - feature missing)
   - **If implemented**: Token refresh is detected
5. If implemented:
   - Verify new token is obtained
   - Verify old token is replaced in Firebase
   - Verify device record is updated with new token
   - Verify `lastActiveAt` timestamp is updated
   - Verify local storage is updated with new token
6. Verify token refresh doesn't interrupt user experience
7. Verify no duplicate tokens are stored

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token refresh handling is NOT available (missing)
- ✅ **When implemented**: Token refresh is handled automatically
- ✅ New token replaces old token
- ✅ Database is updated correctly
- ✅ User experience is not interrupted

---

## Test Case 5: Multiple Devices Registration

**Objective**: Verify user can register multiple devices.

**Preconditions**:
- User is logged in on Device A
- User logs in on Device B (different device)
- Multiple device registration feature is implemented

**Steps**:
1. Log in on Device A
2. Verify Device A is registered with FCM token and deviceId
3. Log in on Device B (same user, different device)
4. Verify one of the following:
   - **If NOT implemented**: Device B is not registered (this is expected - feature missing)
   - **If implemented**: Device B is registered separately
5. If implemented:
   - Verify Device B has different deviceId
   - Verify Device B has different FCM token
   - Check Firebase database:
     - Navigate to `users/{userId}/devices`
     - Verify both devices are listed:
       - `devices/{deviceIdA}` - Device A
       - `devices/{deviceIdB}` - Device B
   - Verify both devices can receive push notifications
6. Test push notification:
   - Send push notification to user
   - Verify both devices receive notification
   - Verify notification appears on both devices

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multiple device registration is NOT available (missing)
- ✅ **When implemented**: Multiple devices can be registered
- ✅ Each device has unique deviceId and FCM token
- ✅ Both devices can receive push notifications

---

## Test Case 6: Token Revocation on Logout

**Objective**: Verify FCM token is revoked/removed when user logs out.

**Preconditions**:
- User is logged in
- FCM token is registered
- Token revocation on logout feature is implemented

**Steps**:
1. Log in to the app
2. Verify FCM token is registered in Firebase
3. Log out from the app
4. Verify one of the following:
   - **If NOT implemented**: Token remains in Firebase (this is expected - feature missing)
   - **If implemented**: Token is revoked/removed
5. If implemented:
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify one of the following:
       - Device record is deleted
       - OR `isActive` is set to false
       - OR `fcmToken` is removed
   - Verify local storage is cleared
   - Verify device cannot receive push notifications after logout
6. Log in again
7. Verify new token is registered

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token revocation is NOT available (missing)
- ✅ **When implemented**: Token is revoked on logout
- ✅ Device record is updated/deleted
- ✅ Device cannot receive notifications after logout

---

## Test Case 7: Token Registration on App Start (If Not Logged In)

**Objective**: Verify token registration happens after login, not on app start.

**Preconditions**:
- User is not logged in
- App is launched
- Token registration feature is implemented

**Steps**:
1. Launch the app without logging in
2. Verify one of the following:
   - **If NOT implemented**: No token registration (this is expected - feature missing)
   - **If implemented**: Token is NOT registered (correct behavior)
3. If implemented:
   - Verify FCM token is not saved to Firebase
   - Verify deviceId is not saved to Firebase
   - Verify no device record is created
4. Log in
5. Verify token and deviceId are registered after login
6. Verify device record is created in Firebase

**Expected Results**:
- ✅ Token registration only happens after login
- ✅ No device record is created before login
- ✅ Registration happens after successful authentication

---

## Test Case 8: Token Registration Error Handling

**Objective**: Verify error handling when token registration fails.

**Preconditions**:
- User is logged in
- Token registration feature is implemented
- Network issues or Firebase errors can be simulated

**Steps**:
1. Log in to the app
2. Simulate error scenarios:
   - **Scenario A**: Network offline
     - Disable network connection
     - Attempt login
     - Verify error handling
   - **Scenario B**: Firebase permission denied
     - Simulate permission error
     - Verify error handling
   - **Scenario C**: FCM token retrieval fails
     - Simulate FCM error
     - Verify error handling
3. Verify one of the following:
   - **If NOT implemented**: No error handling (this is expected - feature missing)
   - **If implemented**: Errors are handled gracefully
4. If implemented:
   - Verify user can still log in (registration failure doesn't block login)
   - Verify error is logged (if logging exists)
   - Verify retry mechanism (if implemented):
     - Retry registration after network is restored
     - Retry registration on token refresh
   - Verify user is notified of registration failure (optional)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Error handling is NOT available (missing)
- ✅ **When implemented**: Errors are handled gracefully
- ✅ Login is not blocked by registration failure
- ✅ Retry mechanism works (if implemented)

---

## Test Case 9: Device Information Storage

**Objective**: Verify device information (platform, model, OS version) is stored.

**Preconditions**:
- User is logged in
- Device information storage feature is implemented

**Steps**:
1. Log in to the app
2. Verify one of the following:
   - **If NOT implemented**: Device information is not stored (this is expected - feature missing)
   - **If implemented**: Device information is captured and stored
3. If implemented:
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify device information fields:
       - `platform`: "android" or "ios"
       - `deviceModel`: Device model name
       - `osVersion`: Operating system version
       - `appVersion`: App version
   - Verify information is accurate:
     - Platform matches device
     - Model matches device
     - OS version matches device
     - App version matches installed app
4. Test on different devices:
   - Android device
   - iOS device
   - Verify platform-specific information is captured correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Device information storage is NOT available (missing)
- ✅ **When implemented**: Device information is stored
- ✅ Information is accurate
- ✅ Platform-specific information is captured

---

## Test Case 10: Token Update on App Update

**Objective**: Verify token and device information are updated when app is updated.

**Preconditions**:
- User is logged in
- FCM token is registered
- App is updated to new version
- Token update on app update feature is implemented

**Steps**:
1. Log in to the app (version 1.0.0)
2. Verify FCM token is registered
3. Update app to new version (e.g., 1.0.1)
4. Launch updated app
5. Verify one of the following:
   - **If NOT implemented**: Token is not updated (this is expected - feature missing)
   - **If implemented**: Token and app version are updated
6. If implemented:
   - Check Firebase database:
     - Navigate to `users/{userId}/devices/{deviceId}`
     - Verify `appVersion` is updated to new version
     - Verify `lastActiveAt` is updated
     - Verify FCM token is still valid (or refreshed if needed)
7. Verify device can still receive push notifications

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token update on app update is NOT available (missing)
- ✅ **When implemented**: App version is updated
- ✅ Device record is updated
- ✅ Push notifications still work

---

## Test Case 11: Token Registration Permission Check

**Objective**: Verify token registration respects notification permissions.

**Preconditions**:
- User is not logged in
- Notification permissions can be controlled
- Permission-aware registration feature is implemented

**Steps**:
1. Disable notification permissions for the app
2. Log in to the app
3. Verify one of the following:
   - **If NOT implemented**: Token registration proceeds anyway (this is expected - feature missing)
   - **If implemented**: Token registration is skipped or handled appropriately
4. If implemented:
   - Verify FCM token retrieval respects permissions
   - Verify device record is created but may not have FCM token
   - OR verify device record is not created until permissions are granted
5. Enable notification permissions
6. Verify token registration proceeds:
   - FCM token is retrieved
   - Device record is updated with token
   - OR device record is created with token
7. Verify device can receive push notifications

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission-aware registration is NOT available (missing)
- ✅ **When implemented**: Registration respects permissions
- ✅ Token is registered when permissions are granted
- ✅ Device can receive notifications when permissions are granted

---

## Test Case 12: Token Registration Retry Mechanism

**Objective**: Verify retry mechanism for failed token registrations.

**Preconditions**:
- User is logged in
- Token registration retry feature is implemented

**Steps**:
1. Log in to the app
2. Simulate registration failure (network offline, etc.)
3. Verify one of the following:
   - **If NOT implemented**: No retry mechanism (this is expected - feature missing)
   - **If implemented**: Retry mechanism is triggered
4. If implemented:
   - Verify retry attempts are made:
     - After network is restored
     - On app resume
     - On token refresh
   - Verify retry has maximum attempts (to prevent infinite loops)
   - Verify retry has exponential backoff (optional)
   - Verify registration succeeds after retry
5. Check Firebase database:
   - Verify token is eventually registered
   - Verify device record is created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Retry mechanism is NOT available (missing)
- ✅ **When implemented**: Retry mechanism works
- ✅ Registration eventually succeeds
- ✅ No infinite retry loops

---

## Test Case 13: Token Storage in Local Storage

**Objective**: Verify FCM token is stored in local storage for offline access.

**Preconditions**:
- User is logged in
- Local storage for FCM token feature is implemented

**Steps**:
1. Log in to the app
2. Verify FCM token is registered
3. Check local storage:
   - Verify FCM token is saved to local storage (SharedPreferences or Hive)
   - Verify deviceId is saved to local storage
   - Verify storage keys are appropriate (e.g., "fcm_token", "device_id")
4. Go offline
5. Restart app
6. Verify token can be retrieved from local storage:
   - Token is available even when offline
   - Token can be used for local operations
7. Go online
8. Verify token syncs with Firebase:
   - Local token matches Firebase token
   - OR local token is updated if Firebase token changed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Local storage for FCM token is NOT available (missing)
- ✅ **When implemented**: Token is stored locally
- ✅ Token is available offline
- ✅ Token syncs with Firebase when online

---

## Test Case 14: Device Record Cleanup for Inactive Devices

**Objective**: Verify inactive device records are cleaned up (if implemented).

**Preconditions**:
- User has multiple registered devices
- Some devices are inactive (not used for long time)
- Device cleanup feature is implemented

**Steps**:
1. Register multiple devices for user
2. Stop using one device for extended period (e.g., 30+ days)
3. Verify one of the following:
   - **If NOT implemented**: Inactive devices remain in database (this is expected - feature missing)
   - **If implemented**: Inactive devices are cleaned up
4. If implemented:
   - Check Firebase database:
     - Verify inactive device records are:
       - Deleted after inactivity period
       - OR marked as inactive
       - OR archived
   - Verify cleanup happens automatically (scheduled job)
   - OR verify cleanup happens on login (check for inactive devices)
5. Verify active devices are not affected
6. Verify user can re-register device if needed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Device cleanup is NOT available (missing)
- ✅ **When implemented**: Inactive devices are cleaned up
- ✅ Active devices are not affected
- ✅ Cleanup is automatic

**Note**: This is an optional feature for database maintenance.

---

## Test Case 15: Token Registration Security

**Objective**: Verify token registration is secure and only accessible by authorized users.

**Preconditions**:
- User is logged in
- Token registration feature is implemented
- Firebase security rules are configured

**Steps**:
1. Log in as User A
2. Verify User A can register their own device
3. Attempt to register device for User B (different user):
   - Try to write to `users/{userB}/devices/{deviceId}`
   - Verify one of the following:
     - **If NOT implemented**: Security may not be enforced (this is expected - feature missing)
     - **If implemented**: Access is denied
4. If implemented:
   - Verify Firebase security rules prevent unauthorized access
   - Verify only authenticated user can register their own devices
   - Verify deviceId cannot be spoofed
5. Test token retrieval:
   - Verify only user can retrieve their own device tokens
   - Verify tokens are not exposed in client-side code unnecessarily

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Security enforcement may not be available (missing)
- ✅ **When implemented**: Security is enforced
- ✅ Only authorized users can register devices
- ✅ Tokens are protected

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] FCM token is retrieved on login
- [ ] DeviceId is captured on login
- [ ] Both token and deviceId are saved to Firebase
- [ ] Token refresh is handled
- [ ] Multiple devices can be registered
- [ ] Token is revoked on logout
- [ ] Token registration only happens after login
- [ ] Error handling works correctly
- [ ] Device information is stored
- [ ] Token is updated on app update
- [ ] Permission check works
- [ ] Retry mechanism works (if implemented)
- [ ] Token is stored in local storage
- [ ] Device cleanup works (if implemented)
- [ ] Security is enforced

---

## Known Issues (Based on Audit Report)

1. **No DeviceId Capture**:
   - DeviceId is not captured
   - No device identifier is stored
   - **Status**: ⛔ Missing

2. **Token Saved as ID Token**:
   - `StorageService.setUserToken` saves ID token (not FCM token)
   - FCM token is not saved to Firebase
   - **Status**: ⛔ Missing

3. **No Push Registration Flow**:
   - No flow to register FCM token + deviceId
   - No integration with login flow
   - **Status**: ⛔ Missing

4. **No Token Refresh Handling**:
   - Token refresh is not handled
   - No update to Firebase on token refresh
   - **Status**: ⛔ Missing

5. **No Token Revocation**:
   - Token is not revoked on logout
   - Device records remain in database
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: FCM token + deviceId registration is completely missing. Only ID token is saved via `StorageService.setUserToken`, which is not the FCM token needed for push notifications.

2. **FCM vs ID Token**: FCM token is for push notifications. ID token is for authentication. These are different tokens with different purposes.

3. **DeviceId Purpose**: DeviceId is used to identify unique devices so push notifications can be sent to specific devices.

4. **Registration Timing**: Token registration should happen after successful login, not on app start.

5. **Multiple Devices**: Users should be able to register multiple devices (phone, tablet, etc.) and receive notifications on all devices.

6. **Token Refresh**: FCM tokens can refresh automatically. System should handle refresh and update Firebase.

7. **Security**: Device registration should be secure - only authenticated users can register their own devices.

8. **Error Handling**: Registration failures should not block login. System should retry registration when possible.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User account used
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase database structure (if accessible) showing device records
- Network conditions (online/offline)
- Notification permission status
