# Notification Main Flow (Token/DeviceId Save, Push Triggers, Retry/Fallback, Token Revocation) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Notification Main Flow** feature (save token/deviceId on login/refresh; push when task/project/workspace membership changes; retry/fallback; revoke token on logout). Currently, this feature is **MISSING** - `AuthController` saves ID token to StorageService (not FCM), no deviceId, no refresh/retry/revoke flows.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `AuthController` exists and saves ID token to StorageService
- ✅ `StorageService` exists and can save tokens
- ✅ `NotificationService` exists but doesn't handle FCM token save
- ✅ `NotificationServiceImpl` exists but has TODOs
- ✅ `firebase_messaging` package is in pubspec.yaml
- ✅ `device_info_plus` package is in pubspec.yaml

### What's Missing/Broken:
- ⛔ No FCM token save on login (only ID token is saved)
- ⛔ No deviceId save on login
- ⛔ No token refresh handling
- ⛔ No push triggers for task operations
- ⛔ No push triggers for project operations
- ⛔ No push triggers for workspace membership changes
- ⛔ No retry/fallback mechanism
- ⛔ No token revocation on logout

---

## Task List

### Task 1: Save FCM Token and DeviceId on Login

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Modify AuthController to save FCM token and deviceId on login (currently only ID token is saved).

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Inject `DeviceRegistrationService`:
   ```dart
   final DeviceRegistrationService _deviceRegistrationService = Get.find<DeviceRegistrationService>();
   ```

2. Update `_handleUserSignIn` method:
   ```dart
   Future<void> _handleUserSignIn(firebase_auth.User firebaseUser) async {
     try {
       isLoading = true;
       
       // ... existing user creation/login logic ...
       
       // Save user data to local storage
       await _storageService.setUserData('current_user', user.toMap());
       await _storageService.setUserId(user.id);
       
       // Save ID token (existing)
       final token = await firebaseUser.getIdToken();
       if (token != null) {
         await _storageService.setUserToken(token);
       }
       
       // NEW: Register device and save FCM token + deviceId
       final workspaceId = _storageService.getWorkspaceId();
       if (workspaceId != null) {
         await _deviceRegistrationService.registerDevice(
           userId: user.id,
           workspaceId: workspaceId,
         );
       }
       
       isLoading = false;
     } on Exception catch (e) {
       isLoading = false;
       handleError(UnknownFailure(message: 'Failed to sign in: $e'));
     }
   }
   ```

3. Ensure registration doesn't block login:
   - Wrap in try-catch
   - Don't throw error if registration fails
   - Log error for debugging

**Expected Results**:
- ✅ FCM token is saved on login
- ✅ DeviceId is saved on login
- ✅ Both are saved to Firebase and local storage
- ✅ Login flow is not blocked

**Test Criteria**:
- Test: Login, verify FCM token is saved
- Test: Login, verify deviceId is saved
- Test: Verify login is not blocked if registration fails

---

### Task 2: Handle FCM Token Refresh

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Handle FCM token refresh and update Firebase database and local storage.

**Files to Modify**:
- `lib/core/services/device_registration_service.dart`
- `lib/core/services/notification_service.dart`

**Implementation Steps**:
1. Update `DeviceRegistrationService` to set up token refresh listener:
   ```dart
   void setupTokenRefreshListener() {
     _firebaseMessaging.onTokenRefresh.listen((newToken) async {
       try {
         final userId = Get.find<AuthController>().currentUser?.id;
         final deviceId = await _storageService.getString('device_id');
         
         if (userId != null && deviceId != null) {
           await updateDeviceToken(
             userId: userId,
             deviceId: deviceId,
             newToken: newToken,
           );
         }
       } catch (e) {
         Get.log('Failed to update FCM token on refresh: $e');
       }
     });
   }
   ```

2. Call setup in `registerDevice` method:
   ```dart
   Future<void> registerDevice({
     required String userId,
     required String workspaceId,
   }) async {
     // ... existing registration logic ...
     
     // Set up token refresh listener
     setupTokenRefreshListener();
   }
   ```

3. Update `NotificationService` to also handle token refresh:
   ```dart
   Future<void> _initializeFirebaseMessaging() async {
     // ... existing initialization ...
     
     // Listen to token refresh
     firebaseMessaging.onTokenRefresh.listen((token) async {
       try {
         final deviceRegistrationService = Get.find<DeviceRegistrationService>();
         final userId = Get.find<AuthController>().currentUser?.id;
         final deviceId = await StorageService().getString('device_id');
         
         if (userId != null && deviceId != null) {
           await deviceRegistrationService.updateDeviceToken(
             userId: userId,
             deviceId: deviceId,
             newToken: token,
           );
         }
       } catch (e) {
         debugPrint('Failed to update FCM token on refresh: $e');
       }
     });
   }
   ```

**Expected Results**:
- ✅ Token refresh is handled automatically
- ✅ Firebase database is updated with new token
- ✅ Local storage is updated with new token
- ✅ No duplicate tokens

**Test Criteria**:
- Test: Simulate token refresh, verify update
- Test: Verify Firebase is updated
- Test: Verify local storage is updated

---

### Task 3: Add Push Triggers for Task Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add push notification triggers for task create/update/delete/assign operations.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/core/services/firebase_database_service.dart` (task operations)

**Implementation Steps**:
1. Inject `PushNotificationService` in TaskController:
   ```dart
   final PushNotificationService _pushService = Get.find<PushNotificationService>();
   ```

2. Add push trigger on task create:
   ```dart
   Future<void> createTask(TaskEntity task) async {
     try {
       // ... existing create logic ...
       
       // Send push notification to assignee
       if (task.assignee != null) {
         await _pushService.sendToUser(
           userId: task.assignee!,
           title: AppStrings.newTaskAssigned,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_assigned',
             'taskId': task.id,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error (don't block task creation)
       Get.log('Failed to send push notification on task create: $e');
     }
   }
   ```

3. Add push trigger on task update:
   ```dart
   Future<void> updateTask(TaskEntity task) async {
     try {
       // ... existing update logic ...
       
       // Send push notification to assignee
       if (task.assignee != null) {
         await _pushService.sendToUser(
           userId: task.assignee!,
           title: AppStrings.taskUpdated,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_updated',
             'taskId': task.id,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error (don't block task update)
       Get.log('Failed to send push notification on task update: $e');
     }
   }
   ```

4. Add push trigger on task delete:
   ```dart
   Future<void> deleteTask(String taskId) async {
     try {
       // Get task before deleting
       final task = await _getTask(taskId);
       
       // ... existing delete logic ...
       
       // Send push notification to assignee
       if (task?.assignee != null) {
         await _pushService.sendToUser(
           userId: task!.assignee!,
           title: AppStrings.taskDeleted,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_deleted',
             'taskId': taskId,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error (don't block task delete)
       Get.log('Failed to send push notification on task delete: $e');
     }
   }
   ```

5. Add push trigger on task assign:
   ```dart
   Future<void> assignTask(String taskId, String assigneeId) async {
     try {
       // ... existing assign logic ...
       
       // Get task for notification
       final task = await _getTask(taskId);
       
       // Send push notification to new assignee
       await _pushService.sendToUser(
         userId: assigneeId,
         title: AppStrings.newTaskAssigned,
         body: '${AppStrings.task}: ${task?.title ?? AppStrings.task}',
         data: {
           'type': 'task_assigned',
           'taskId': taskId,
           'workspaceId': task?.workspaceId ?? '',
         },
       );
     } catch (e) {
       // Handle error (don't block task assign)
       Get.log('Failed to send push notification on task assign: $e');
     }
   }
   ```

6. Use AppStrings for all notification text

**Expected Results**:
- ✅ Push triggers are added to task operations
- ✅ Notifications are sent correctly
- ✅ Notifications use AppStrings
- ✅ Task operations are not blocked by notification failures

**Test Criteria**:
- Test: Task create triggers notification
- Test: Task update triggers notification
- Test: Task delete triggers notification
- Test: Task assign triggers notification
- Test: Verify task operations work even if notification fails

---

### Task 4: Add Push Triggers for Project Operations

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add push notification triggers for project create/update operations.

**Files to Modify**:
- `lib/features/projects/presentation/controllers/project_controller.dart`
- Project-related controllers

**Implementation Steps**:
1. Inject `PushNotificationService`:
   ```dart
   final PushNotificationService _pushService = Get.find<PushNotificationService>();
   ```

2. Add push trigger on project create:
   ```dart
   Future<void> createProject(ProjectEntity project) async {
     try {
       // ... existing create logic ...
       
       // Send push notification to workspace members
       await _pushService.sendToWorkspace(
         workspaceId: project.workspaceId,
         title: AppStrings.newProjectCreated,
         body: '${AppStrings.project}: ${project.name}',
         data: {
           'type': 'project_created',
           'projectId': project.id,
           'workspaceId': project.workspaceId,
         },
       );
     } catch (e) {
       // Handle error (don't block project creation)
       Get.log('Failed to send push notification on project create: $e');
     }
   }
   ```

3. Add push trigger on project update:
   ```dart
   Future<void> updateProject(ProjectEntity project) async {
     try {
       // ... existing update logic ...
       
       // Send push notification to workspace members
       await _pushService.sendToWorkspace(
         workspaceId: project.workspaceId,
         title: AppStrings.projectUpdated,
         body: '${AppStrings.project}: ${project.name}',
         data: {
           'type': 'project_updated',
           'projectId': project.id,
           'workspaceId': project.workspaceId,
         },
       );
     } catch (e) {
       // Handle error (don't block project update)
       Get.log('Failed to send push notification on project update: $e');
     }
   }
   ```

4. Use AppStrings for all notification text

**Expected Results**:
- ✅ Push triggers are added to project operations
- ✅ Notifications are sent to workspace members
- ✅ Notifications use AppStrings
- ✅ Project operations are not blocked by notification failures

**Test Criteria**:
- Test: Project create triggers notification
- Test: Project update triggers notification
- Test: Verify project operations work even if notification fails

---

### Task 5: Add Push Triggers for Workspace Membership Changes

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add push notification triggers for workspace membership changes (add/remove/role change).

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- Workspace membership controllers

**Implementation Steps**:
1. Inject `PushNotificationService`:
   ```dart
   final PushNotificationService _pushService = Get.find<PushNotificationService>();
   ```

2. Add push trigger on add member:
   ```dart
   Future<void> addWorkspaceMember({
     required String workspaceId,
     required String userId,
   }) async {
     try {
       // ... existing add member logic ...
       
       // Send push notification to new member
       await _pushService.sendToUser(
         userId: userId,
         title: AppStrings.workspaceInvitationAccepted,
         body: '${AppStrings.youHaveBeenAddedToWorkspace}: ${workspace.name}',
         data: {
           'type': 'workspace_member_added',
           'workspaceId': workspaceId,
           'userId': userId,
         },
       );
     } catch (e) {
       // Handle error (don't block member addition)
       Get.log('Failed to send push notification on add member: $e');
     }
   }
   ```

3. Add push trigger on remove member:
   ```dart
   Future<void> removeWorkspaceMember({
     required String workspaceId,
     required String userId,
   }) async {
     try {
       // ... existing remove member logic ...
       
       // Send push notification to removed member
       await _pushService.sendToUser(
         userId: userId,
         title: AppStrings.removedFromWorkspace,
         body: '${AppStrings.youHaveBeenRemovedFromWorkspace}: ${workspace.name}',
         data: {
           'type': 'workspace_member_removed',
           'workspaceId': workspaceId,
           'userId': userId,
         },
       );
     } catch (e) {
       // Handle error (don't block member removal)
       Get.log('Failed to send push notification on remove member: $e');
     }
   }
   ```

4. Add push trigger on role change:
   ```dart
   Future<void> updateUserRole({
     required String workspaceId,
     required String userId,
     required WorkspaceRole newRole,
   }) async {
     try {
       // ... existing role update logic ...
       
       // Send push notification to user
       await _pushService.sendToUser(
         userId: userId,
         title: AppStrings.roleChanged,
         body: '${AppStrings.yourRoleHasBeenChangedTo}: ${newRole.displayName}',
         data: {
           'type': 'workspace_role_changed',
           'workspaceId': workspaceId,
           'userId': userId,
           'newRole': newRole.value,
         },
       );
     } catch (e) {
       // Handle error (don't block role change)
       Get.log('Failed to send push notification on role change: $e');
     }
   }
   ```

5. Use AppStrings for all notification text

**Expected Results**:
- ✅ Push triggers are added to workspace membership operations
- ✅ Notifications are sent correctly
- ✅ Notifications use AppStrings
- ✅ Workspace operations are not blocked by notification failures

**Test Criteria**:
- Test: Add member triggers notification
- Test: Remove member triggers notification
- Test: Role change triggers notification
- Test: Verify workspace operations work even if notification fails

---

### Task 6: Implement Retry Mechanism for Failed Push Notifications

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Implement retry mechanism with exponential backoff for failed push notifications.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Add retry logic to `sendToUser` method:
   ```dart
   Future<PushNotificationResult> sendToUser({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
     int maxRetries = 3,
   }) async {
     int retryCount = 0;
     Exception? lastError;
     
     while (retryCount < maxRetries) {
       try {
         final result = await _sendToUserInternal(
           userId: userId,
           title: title,
           body: body,
           data: data,
         );
         
         if (result.success) {
           return result;
         }
         
         // Retry with exponential backoff
         retryCount++;
         if (retryCount < maxRetries) {
           final delay = Duration(seconds: pow(2, retryCount).toInt());
           await Future.delayed(delay);
         }
       } catch (e) {
         lastError = e is Exception ? e : Exception(e.toString());
         retryCount++;
         
         if (retryCount < maxRetries) {
           final delay = Duration(seconds: pow(2, retryCount).toInt());
           await Future.delayed(delay);
         }
       }
     }
     
     // All retries failed, use fallback
     return await _fallbackToLocalNotification(
       userId: userId,
       title: title,
       body: body,
       data: data,
     );
   }
   ```

2. Add retry logging:
   ```dart
   Future<PushNotificationResult> _sendToUserInternal({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
   }) async {
     try {
       // ... existing send logic ...
       
       // Log success
       await _logNotificationDelivery(
         userId: userId,
         success: true,
         retryCount: 0,
       );
       
       return PushNotificationResult(success: true);
     } catch (e) {
       // Log failure
       await _logNotificationDelivery(
         userId: userId,
         success: false,
         error: e.toString(),
         retryCount: 0,
       );
       
       rethrow;
     }
   }
   ```

3. Add retry count tracking in logs

**Expected Results**:
- ✅ Retry mechanism works
- ✅ Exponential backoff is used
- ✅ Maximum retry attempts are enforced
- ✅ Retry attempts are logged

**Test Criteria**:
- Test: Retry mechanism works
- Test: Exponential backoff is correct
- Test: Maximum retries are enforced
- Test: Retry attempts are logged

---

### Task 7: Implement Fallback Mechanism for Failed Push Notifications

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Implement fallback mechanism (local notification) when push notification fails after retries.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Add fallback method:
   ```dart
   Future<PushNotificationResult> _fallbackToLocalNotification({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
   }) async {
     try {
       final notificationService = Get.find<NotificationService>();
       await notificationService.showLocalNotification(
         id: userId.hashCode,
         title: title,
         body: body,
         payload: data != null ? jsonEncode(data) : null,
       );
       
       // Log fallback
       await _logNotificationDelivery(
         userId: userId,
         success: true,
         method: 'fallback_local',
       );
       
       return PushNotificationResult(success: true);
     } catch (e) {
       // Log fallback failure
       await _logNotificationDelivery(
         userId: userId,
         success: false,
         error: 'Fallback failed: $e',
         method: 'fallback_local',
       );
       
       return PushNotificationResult(
         success: false,
         error: 'Fallback failed: $e',
       );
     }
   }
   ```

2. Add fallback logging

**Expected Results**:
- ✅ Fallback mechanism works
- ✅ Local notification is shown
- ✅ Fallback is logged

**Test Criteria**:
- Test: Fallback mechanism works
- Test: Local notification is shown
- Test: Fallback is logged

---

### Task 8: Implement Token Revocation on Logout

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement token revocation when user logs out.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Update `signOut` method:
   ```dart
   Future<void> signOut() async {
     try {
       final userId = _currentUser.value?.id;
       final deviceId = await _storageService.getString('device_id');
       
       // Revoke device registration
       if (userId != null && deviceId != null) {
         await _deviceRegistrationService.revokeDevice(
           userId: userId,
           deviceId: deviceId,
         );
       }
       
       // ... existing sign out logic ...
       
       // Clear local storage
       await _storageService.remove('fcm_token');
       await _storageService.remove('device_id');
       
       // ... rest of sign out logic ...
     } catch (e) {
       // Handle error (don't block logout)
       Get.log('Failed to revoke device on logout: $e');
     }
   }
   ```

2. Ensure revocation doesn't block logout

**Expected Results**:
- ✅ Token is revoked on logout
- ✅ Device is marked inactive
- ✅ Local storage is cleaned up
- ✅ Logout flow is not blocked

**Test Criteria**:
- Test: Logout, verify token is revoked
- Test: Logout, verify device is marked inactive
- Test: Logout, verify local storage is cleaned up
- Test: Verify logout is not blocked if revocation fails

---

### Task 9: Add Error Handling for Push Notifications

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add comprehensive error handling for push notification operations.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`
- All controllers that use push notifications

**Implementation Steps**:
1. Add error handling wrapper:
   ```dart
   Future<PushNotificationResult> sendToUser({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
   }) async {
     try {
       // ... existing send logic with retry/fallback ...
     } catch (e) {
       // Log error
       await _logNotificationError(
         userId: userId,
         error: e.toString(),
         errorType: e.runtimeType.toString(),
       );
       
       // Return error result (don't throw)
       return PushNotificationResult(
         success: false,
         error: e.toString(),
       );
     }
   }
   ```

2. Add error logging:
   ```dart
   Future<void> _logNotificationError({
     required String userId,
     required String error,
     required String errorType,
   }) async {
     try {
       // Log to Firebase or local storage
       await _databaseService.logNotificationError(
         userId: userId,
         error: error,
         errorType: errorType,
         timestamp: DateTime.now(),
       );
     } catch (e) {
       // Don't throw, just log locally
       Get.log('Failed to log notification error: $e');
     }
   }
   ```

3. Ensure errors don't block operations:
   - Wrap all push notification calls in try-catch
   - Don't throw errors
   - Log errors appropriately
   - Continue with operation even if notification fails

**Expected Results**:
- ✅ Errors are handled gracefully
- ✅ Errors are logged
- ✅ Operations are not blocked by errors
- ✅ User experience is not affected

**Test Criteria**:
- Test: Error handling works
- Test: Errors are logged
- Test: Operations continue even if notification fails

---

### Task 10: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for notification main flow.

**Files to Create**:
- `test/features/auth/presentation/controllers/auth_controller_notification_test.dart`
- `test/core/services/push_notification_service_test.dart`
- `test/core/services/device_registration_service_test.dart`

**Expected Results**:
- ✅ Unit tests cover notification main flow
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Save FCM Token and DeviceId on Login (Critical - Foundation)
2. **Task 2**: Handle FCM Token Refresh (Critical - Core Logic)
3. **Task 8**: Implement Token Revocation on Logout (High Priority - Security)
4. **Task 3**: Add Push Triggers for Task Operations (High Priority - Feature)
5. **Task 4**: Add Push Triggers for Project Operations (Medium Priority - Feature)
6. **Task 5**: Add Push Triggers for Workspace Membership Changes (Medium Priority - Feature)
7. **Task 6**: Implement Retry Mechanism (Medium Priority - Quality Assurance)
8. **Task 7**: Implement Fallback Mechanism (Medium Priority - Quality Assurance)
9. **Task 9**: Add Error Handling (Medium Priority - Quality Assurance)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ FCM token and deviceId are saved on login
- ✅ FCM token refresh is handled automatically
- ✅ Token revocation works on logout
- ✅ Push triggers for task operations work
- ✅ Push triggers for project operations work
- ✅ Push triggers for workspace membership changes work
- ✅ Retry mechanism works
- ✅ Fallback mechanism works
- ✅ Error handling works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Device Registration Service**: Required for device registration (from Task 1 of Notification Architecture)
- **Push Notification Service**: Required for sending push notifications (from Task 4 of Notification Architecture)
- **Firebase Messaging**: Required for FCM tokens
- **Device Info Plus**: Required for deviceId capture
- **Firebase Realtime Database**: Required for storing device registrations
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Integration with Architecture**: This main flow depends on the notification architecture (device registration, push service) being implemented first.

2. **Error Handling**: All push notification operations should be wrapped in try-catch to ensure they don't block main operations (task create, project update, etc.).

3. **Workspace Scoping**: All push notifications should be scoped to workspace for data isolation.

4. **Existing Components**: `AuthController` already saves ID token. Need to add FCM token and deviceId save.

5. **Token Refresh**: FCM tokens can refresh automatically. Need to handle token refresh and update database.

6. **Multiple Devices**: Users can have multiple devices. Push notifications should be sent to all active devices.

---

## Related Documentation

- `NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `NOTIFICATION_MAIN_FLOW_TEST_CASES.md` - Test cases for this feature
- `NOTIFICATION_ARCHITECTURE_TASKS.md` - Related notification architecture tasks
- `docs/v1/feature_checklists/notifications/notifications.md` - Notification requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

