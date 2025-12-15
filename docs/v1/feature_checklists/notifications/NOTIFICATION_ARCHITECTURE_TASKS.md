# Notification Architecture (Device Registration, FCM Token Sync, Push Triggers) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Notification Architecture** feature (each device has its own BE service, sync Firebase token + deviceId; use FCM push when adding/deleting/editing/assigning tasks, changing roles). Currently, this feature is **MISSING** - Only `NotificationEntity` exists; no device/FCM registration, no service layer, no push triggers.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `NotificationEntity` - data class for notifications
- ✅ `NotificationService` - local notification service exists
- ✅ `NotificationServiceImpl` - backend notification service exists (but has TODOs)
- ✅ `firebase_messaging` package is in pubspec.yaml
- ✅ `device_info_plus` package is in pubspec.yaml
- ✅ FCM token can be retrieved via `FirebaseMessaging.getToken()`
- ✅ Token refresh listener exists (but doesn't update database)

### What's Missing/Broken:
- ⛔ No device registration entity
- ⛔ No deviceId capture
- ⛔ No FCM token sync to Firebase database
- ⛔ No device registration service
- ⛔ No push notification service layer
- ⛔ No push triggers for task operations
- ⛔ No push triggers for role changes
- ⛔ No retry/fallback mechanism
- ⛔ No token revocation on logout
- ⛔ No invalid token cleanup

---

## Task List

### Task 1: Create Device Registration Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent device registration with FCM token and deviceId.

**Files to Create**:
- `lib/features/notifications/domain/entities/device_registration.dart` (new file)

**Implementation Steps**:
1. Create `DeviceRegistration` entity:
   ```dart
   class DeviceRegistration {
     final String deviceId;
     final String userId;
     final String workspaceId;
     final String fcmToken;
     final String platform; // 'android' or 'ios'
     final String deviceModel;
     final String osVersion;
     final String appVersion;
     final DateTime registeredAt;
     final DateTime lastActiveAt;
     final bool isActive;
     
     const DeviceRegistration({
       required this.deviceId,
       required this.userId,
       required this.workspaceId,
       required this.fcmToken,
       required this.platform,
       required this.deviceModel,
       required this.osVersion,
       required this.appVersion,
       required this.registeredAt,
       required this.lastActiveAt,
       this.isActive = true,
     });
     
     factory DeviceRegistration.fromMap(Map<String, dynamic> map) {
       return DeviceRegistration(
         deviceId: map['deviceId'] ?? '',
         userId: map['userId'] ?? '',
         workspaceId: map['workspaceId'] ?? '',
         fcmToken: map['fcmToken'] ?? '',
         platform: map['platform'] ?? '',
         deviceModel: map['deviceModel'] ?? '',
         osVersion: map['osVersion'] ?? '',
         appVersion: map['appVersion'] ?? '',
         registeredAt: DateTime.fromMillisecondsSinceEpoch(
           map['registeredAt'] ?? 0,
         ),
         lastActiveAt: DateTime.fromMillisecondsSinceEpoch(
           map['lastActiveAt'] ?? 0,
         ),
         isActive: map['isActive'] ?? true,
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'deviceId': deviceId,
         'userId': userId,
         'workspaceId': workspaceId,
         'fcmToken': fcmToken,
         'platform': platform,
         'deviceModel': deviceModel,
         'osVersion': osVersion,
         'appVersion': appVersion,
         'registeredAt': registeredAt.millisecondsSinceEpoch,
         'lastActiveAt': lastActiveAt.millisecondsSinceEpoch,
         'isActive': isActive,
       };
     }
     
     DeviceRegistration copyWith({
       String? deviceId,
       String? userId,
       String? workspaceId,
       String? fcmToken,
       String? platform,
       String? deviceModel,
       String? osVersion,
       String? appVersion,
       DateTime? registeredAt,
       DateTime? lastActiveAt,
       bool? isActive,
     }) {
       return DeviceRegistration(
         deviceId: deviceId ?? this.deviceId,
         userId: userId ?? this.userId,
         workspaceId: workspaceId ?? this.workspaceId,
         fcmToken: fcmToken ?? this.fcmToken,
         platform: platform ?? this.platform,
         deviceModel: deviceModel ?? this.deviceModel,
         osVersion: osVersion ?? this.osVersion,
         appVersion: appVersion ?? this.appVersion,
         registeredAt: registeredAt ?? this.registeredAt,
         lastActiveAt: lastActiveAt ?? this.lastActiveAt,
         isActive: isActive ?? this.isActive,
       );
     }
   }
   ```

2. Add validation methods

**Expected Results**:
- ✅ Device registration entity exists
- ✅ Entity can be serialized/deserialized
- ✅ Entity includes all required fields

**Test Criteria**:
- Unit test: Test entity creation
- Unit test: Test serialization/deserialization

---

### Task 2: Create Device Registration Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for registering devices with FCM token and deviceId.

**Files to Create**:
- `lib/core/services/device_registration_service.dart` (new file)

**Implementation Steps**:
1. Create `DeviceRegistrationService`:
   ```dart
   class DeviceRegistrationService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
     final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
     final StorageService _storageService = Get.find<StorageService>();
     final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
     
     /// Register device for current user
     Future<void> registerDevice({
       required String userId,
       required String workspaceId,
     }) async {
       try {
         // Get device information
         final deviceId = await _getDeviceId();
         final fcmToken = await _getFCMToken();
         
         if (fcmToken == null) {
           throw Exception('Failed to get FCM token');
         }
         
         // Get device details
         final platform = Platform.isAndroid ? 'android' : 'ios';
         final deviceModel = await _getDeviceModel();
         final osVersion = await _getOSVersion();
         final appVersion = _packageInfo.version;
         
         // Create device registration
         final registration = DeviceRegistration(
           deviceId: deviceId,
           userId: userId,
           workspaceId: workspaceId,
           fcmToken: fcmToken,
           platform: platform,
           deviceModel: deviceModel,
           osVersion: osVersion,
           appVersion: appVersion,
           registeredAt: DateTime.now(),
           lastActiveAt: DateTime.now(),
           isActive: true,
         );
         
         // Save to Firebase
         await _databaseService.registerDevice(
           userId: userId,
           deviceId: deviceId,
           registration: registration,
         );
         
         // Save to local storage
         await _storageService.setString('fcm_token', fcmToken);
         await _storageService.setString('device_id', deviceId);
         
         // Set up token refresh listener
         _firebaseMessaging.onTokenRefresh.listen((newToken) async {
           await updateDeviceToken(userId: userId, deviceId: deviceId, newToken: newToken);
         });
       } catch (e) {
         // Log error but don't throw (don't block login)
         Get.log('Failed to register device: $e');
       }
     }
     
     /// Update device token (e.g., on refresh)
     Future<void> updateDeviceToken({
       required String userId,
       required String deviceId,
       required String newToken,
     }) async {
       try {
         await _databaseService.updateDeviceToken(
           userId: userId,
           deviceId: deviceId,
           token: newToken,
         );
         
         await _storageService.setString('fcm_token', newToken);
       } catch (e) {
         Get.log('Failed to update device token: $e');
       }
     }
     
     /// Revoke device registration (on logout)
     Future<void> revokeDevice({
       required String userId,
       required String deviceId,
     }) async {
       try {
         await _databaseService.revokeDevice(
           userId: userId,
           deviceId: deviceId,
         );
         
         // Clear local storage
         await _storageService.remove('fcm_token');
         await _storageService.remove('device_id');
       } catch (e) {
         Get.log('Failed to revoke device: $e');
       }
     }
     
     Future<String> _getDeviceId() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return androidInfo.id; // Android ID
       } else {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.identifierForVendor ?? '';
       }
     }
     
     Future<String?> _getFCMToken() async {
       try {
         return await _firebaseMessaging.getToken();
       } catch (e) {
         Get.log('Failed to get FCM token: $e');
         return null;
       }
     }
     
     Future<String> _getDeviceModel() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return '${androidInfo.manufacturer} ${androidInfo.model}';
       } else {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.model;
       }
     }
     
     Future<String> _getOSVersion() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return androidInfo.version.release;
       } else {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.systemVersion;
       }
     }
   }
   ```

2. Add package info import:
   ```dart
   import 'package:package_info_plus/package_info_plus.dart';
   ```

**Expected Results**:
- ✅ Device registration service exists
- ✅ Device registration works
- ✅ Token refresh is handled
- ✅ Device revocation works

**Test Criteria**:
- Unit test: Test device registration
- Test: Test token refresh
- Test: Test device revocation

---

### Task 3: Add Device Registration Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for device registration operations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add device registration methods:
   ```dart
   /// Register device for user
   Future<void> registerDevice({
     required String userId,
     required String deviceId,
     required DeviceRegistration registration,
   }) async {
     try {
       final ref = _database.ref('users/$userId/devices/$deviceId');
       await ref.set(registration.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to register device: $e');
     }
   }
   
   /// Update device token
   Future<void> updateDeviceToken({
     required String userId,
     required String deviceId,
     required String token,
   }) async {
     try {
       final ref = _database.ref('users/$userId/devices/$deviceId');
       await ref.update({
         'fcmToken': token,
         'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to update device token: $e');
     }
   }
   
   /// Revoke device
   Future<void> revokeDevice({
     required String userId,
     required String deviceId,
   }) async {
     try {
       final ref = _database.ref('users/$userId/devices/$deviceId');
       await ref.update({
         'isActive': false,
         'revokedAt': DateTime.now().millisecondsSinceEpoch,
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to revoke device: $e');
     }
   }
   
   /// Get user's active devices
   Future<List<DeviceRegistration>> getUserDevices(String userId) async {
     try {
       final ref = _database.ref('users/$userId/devices');
       final snapshot = await ref.get();
       
       if (!snapshot.exists) return [];
       
       final devices = <DeviceRegistration>[];
       final data = snapshot.value as Map<dynamic, dynamic>;
       
       for (final entry in data.entries) {
         try {
           final deviceData = Map<String, dynamic>.from(entry.value as Map);
           final device = DeviceRegistration.fromMap(deviceData);
           if (device.isActive) {
             devices.add(device);
           }
         } catch (e) {
           continue;
         }
       }
       
       return devices;
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get user devices: $e');
     }
   }
   
   /// Get user's FCM tokens
   Future<List<String>> getUserFCMTokens(String userId) async {
     try {
       final devices = await getUserDevices(userId);
       return devices.map((d) => d.fcmToken).where((t) => t.isNotEmpty).toList();
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get user FCM tokens: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Device registration methods exist
- ✅ Methods work correctly
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 4: Create Push Notification Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for sending push notifications via FCM.

**Files to Create**:
- `lib/core/services/push_notification_service.dart` (new file)

**Implementation Steps**:
1. Create `PushNotificationService`:
   ```dart
   class PushNotificationService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final NotificationServiceImpl _notificationService = Get.find<NotificationServiceImpl>();
     
     /// Send push notification to user
     Future<PushNotificationResult> sendToUser({
       required String userId,
       required String title,
       required String body,
       Map<String, String>? data,
     }) async {
       try {
         // Get user's FCM tokens
         final tokens = await _databaseService.getUserFCMTokens(userId);
         
         if (tokens.isEmpty) {
           return PushNotificationResult(
             success: false,
             error: 'No active devices found for user',
           );
         }
         
         // Send to all user's devices
         final results = <String, bool>{};
         for (final token in tokens) {
           try {
             final success = await _notificationService.sendNotificationToUserID(
               userId: userId,
               title: title,
               body: body,
               data: data,
             );
             results[token] = success;
           } catch (e) {
             results[token] = false;
             // Handle invalid token
             await _handleInvalidToken(userId, token);
           }
         }
         
         return PushNotificationResult(
           success: results.values.any((s) => s),
           results: results,
         );
       } catch (e) {
         return PushNotificationResult(
           success: false,
           error: 'Failed to send push notification: $e',
         );
       }
     }
     
     /// Send push notification to multiple users
     Future<Map<String, PushNotificationResult>> sendToUsers({
       required List<String> userIds,
       required String title,
       required String body,
       Map<String, String>? data,
     }) async {
       final results = <String, PushNotificationResult>{};
       
       for (final userId in userIds) {
         results[userId] = await sendToUser(
           userId: userId,
           title: title,
           body: body,
           data: data,
         );
       }
       
       return results;
     }
     
     /// Send push notification to workspace members
     Future<Map<String, PushNotificationResult>> sendToWorkspace({
       required String workspaceId,
       required String title,
       required String body,
       Map<String, String>? data,
     }) async {
       try {
         // Get workspace members
         final members = await _databaseService.getWorkspaceMembers(workspaceId);
         final userIds = members.map((m) => m.userId).toList();
         
         return await sendToUsers(
           userIds: userIds,
           title: title,
           body: body,
           data: data,
         );
       } catch (e) {
         return {};
       }
     }
     
     Future<void> _handleInvalidToken(String userId, String token) async {
       // Find device with invalid token and mark as inactive
       final devices = await _databaseService.getUserDevices(userId);
       for (final device in devices) {
         if (device.fcmToken == token) {
           await _databaseService.revokeDevice(
             userId: userId,
             deviceId: device.deviceId,
           );
         }
       }
     }
   }
   
   class PushNotificationResult {
     final bool success;
     final String? error;
     final Map<String, bool>? results; // token -> success
     
     const PushNotificationResult({
       required this.success,
       this.error,
       this.results,
     });
   }
   ```

2. Note: This requires server-side implementation for actual FCM sending

**Expected Results**:
- ✅ Push notification service exists
- ✅ Service can send to users/workspaces
- ✅ Invalid token handling works

**Test Criteria**:
- Unit test: Test push service
- Test: Test invalid token handling

---

### Task 5: Integrate Device Registration with Login Flow

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate device registration into AuthController login flow.

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
       
       // Register device for push notifications
       final workspaceId = _storageService.getWorkspaceId();
       if (workspaceId != null) {
         await _deviceRegistrationService.registerDevice(
           userId: user.id,
           workspaceId: workspaceId,
         );
       }
       
       // ... rest of login flow ...
     } catch (e) {
       // Handle error
     } finally {
       isLoading = false;
     }
   }
   ```

3. Update `signOut` method:
   ```dart
   Future<void> signOut() async {
     try {
       final userId = _currentUser.value?.id;
       final deviceId = await _storageService.getString('device_id');
       
       if (userId != null && deviceId != null) {
         await _deviceRegistrationService.revokeDevice(
           userId: userId,
           deviceId: deviceId,
         );
       }
       
       // ... rest of sign out logic ...
     } catch (e) {
       // Handle error
     }
   }
   ```

4. Ensure registration doesn't block login

**Expected Results**:
- ✅ Device registration happens on login
- ✅ Device revocation happens on logout
- ✅ Registration doesn't block login

**Test Criteria**:
- Test: Login, verify device is registered
- Test: Logout, verify device is revoked

---

### Task 6: Add Push Triggers for Task Operations

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
           title: AppStrings.I.newTaskAssigned,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_assigned',
             'taskId': task.id,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error
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
           title: AppStrings.I.taskUpdated,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_updated',
             'taskId': task.id,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error
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
           title: AppStrings.I.taskDeleted,
           body: '${AppStrings.task}: ${task.title}',
           data: {
             'type': 'task_deleted',
             'taskId': taskId,
             'workspaceId': task.workspaceId,
           },
         );
       }
     } catch (e) {
       // Handle error
     }
   }
   ```

5. Add push trigger on task assign:
   ```dart
   Future<void> assignTask(String taskId, String assigneeId) async {
     try {
       // ... existing assign logic ...
       
       // Send push notification to new assignee
       await _pushService.sendToUser(
         userId: assigneeId,
         title: AppStrings.I.newTaskAssigned,
         body: '${AppStrings.task}: ${task.title}',
         data: {
           'type': 'task_assigned',
           'taskId': taskId,
           'workspaceId': task.workspaceId,
         },
       );
     } catch (e) {
       // Handle error
     }
   }
   ```

6. Use AppStrings for all notification text

**Expected Results**:
- ✅ Push triggers are added to task operations
- ✅ Notifications are sent correctly
- ✅ Notifications use AppStrings

**Test Criteria**:
- Test: Task create triggers notification
- Test: Task update triggers notification
- Test: Task delete triggers notification
- Test: Task assign triggers notification

---

### Task 7: Add Push Triggers for Role Changes

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add push notification triggers for role change operations.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- Role management controllers

**Implementation Steps**:
1. Inject `PushNotificationService`:
   ```dart
   final PushNotificationService _pushService = Get.find<PushNotificationService>();
   ```

2. Add push trigger on role change:
   ```dart
   Future<void> updateUserRole({
     required String userId,
     required WorkspaceRole newRole,
   }) async {
     try {
       // ... existing role update logic ...
       
       // Send push notification to user
       await _pushService.sendToUser(
         userId: userId,
         title: AppStrings.I.roleChanged,
         body: '${AppStrings.yourRoleHasBeenChangedTo}: ${newRole.displayName}',
         data: {
           'type': 'role_changed',
           'userId': userId,
           'newRole': newRole.value,
           'workspaceId': _currentWorkspaceId,
         },
       );
     } catch (e) {
       // Handle error
     }
   }
   ```

3. Use AppStrings for notification text

**Expected Results**:
- ✅ Push trigger is added to role change
- ✅ Notification is sent correctly
- ✅ Notification uses AppStrings

**Test Criteria**:
- Test: Role change triggers notification
- Test: Notification is delivered correctly

---

### Task 8: Add Retry/Fallback Mechanism

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add retry/fallback mechanism for failed push notifications.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Add retry logic:
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
     
     // Fallback to local notification
     return await _fallbackToLocalNotification(
       userId: userId,
       title: title,
       body: body,
       data: data,
     );
   }
   
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
       
       return PushNotificationResult(success: true);
     } catch (e) {
       return PushNotificationResult(
         success: false,
         error: 'Fallback failed: $e',
       );
     }
   }
   ```

2. Add logging for retry attempts

**Expected Results**:
- ✅ Retry mechanism works
- ✅ Fallback to local notification works
- ✅ Retry attempts are logged

**Test Criteria**:
- Test: Retry mechanism works
- Test: Fallback works
- Test: Retry attempts are logged

---

### Task 9: Add Invalid Token Cleanup

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add cleanup mechanism for invalid FCM tokens.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Enhance invalid token handling:
   ```dart
   Future<void> _handleInvalidToken(String userId, String token) async {
     try {
       // Find device with invalid token
       final devices = await _databaseService.getUserDevices(userId);
       for (final device in devices) {
         if (device.fcmToken == token) {
           // Mark device as inactive
           await _databaseService.revokeDevice(
             userId: userId,
             deviceId: device.deviceId,
           );
           
           // Log cleanup
           await _logTokenCleanup(userId, device.deviceId, token);
         }
       }
     } catch (e) {
       Get.log('Failed to cleanup invalid token: $e');
     }
   }
   
   Future<void> _logTokenCleanup(String userId, String deviceId, String token) async {
     // Log to Firebase or local storage
     // Implementation depends on logging strategy
   }
   ```

2. Add periodic cleanup job (optional)

**Expected Results**:
- ✅ Invalid tokens are cleaned up
- ✅ Cleanup is logged
- ✅ Database is kept clean

**Test Criteria**:
- Test: Invalid tokens are cleaned up
- Test: Cleanup is logged

---

### Task 10: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for notification architecture.

**Files to Create**:
- `test/core/services/device_registration_service_test.dart`
- `test/core/services/push_notification_service_test.dart`
- `test/features/notifications/domain/entities/device_registration_test.dart`

**Expected Results**:
- ✅ Unit tests cover notification architecture
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Device Registration Entity (Critical - Foundation)
2. **Task 2**: Create Device Registration Service (Critical - Core Logic)
3. **Task 3**: Add Device Registration Methods to FirebaseDatabaseService (Critical - Data Layer)
4. **Task 5**: Integrate Device Registration with Login Flow (High Priority - Integration)
5. **Task 4**: Create Push Notification Service (High Priority - Core Logic)
6. **Task 6**: Add Push Triggers for Task Operations (High Priority - Feature)
7. **Task 7**: Add Push Triggers for Role Changes (Medium Priority - Feature)
8. **Task 8**: Add Retry/Fallback Mechanism (Medium Priority - Quality Assurance)
9. **Task 9**: Add Invalid Token Cleanup (Medium Priority - Maintenance)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Device registration entity exists
- ✅ Device registration service exists
- ✅ Device registration works on login
- ✅ FCM token sync works
- ✅ DeviceId capture works
- ✅ Token refresh handling works
- ✅ Push notification service exists
- ✅ Push triggers for task operations work
- ✅ Push triggers for role changes work
- ✅ Retry/fallback mechanism works
- ✅ Invalid token cleanup works
- ✅ Token revocation works on logout
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Messaging**: Required for FCM tokens
- **Device Info Plus**: Required for deviceId capture
- **Package Info Plus**: Required for app version (may need to add to pubspec.yaml)
- **Firebase Realtime Database**: Required for storing device registrations
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Server-Side Implementation**: Actual FCM push sending requires server-side implementation with Firebase Admin SDK. Client-side can only receive notifications, not send to other devices.

2. **Device Registration**: Each device should be registered per workspace, as users can be in multiple workspaces.

3. **Token Refresh**: FCM tokens can refresh automatically. Need to handle token refresh and update database.

4. **Multiple Devices**: Users can have multiple devices. Push notifications should be sent to all active devices.

5. **Workspace Scoping**: Device registrations should be scoped to workspace for data isolation.

6. **Existing Components**: `NotificationServiceImpl` exists but has TODOs. Can enhance existing service rather than creating new one.

---

## Related Documentation

- `NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `NOTIFICATION_ARCHITECTURE_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/user_management/FCM_TOKEN_DEVICEID_TASKS.md` - Related FCM token registration
- `docs/v1/feature_checklists/notifications/notifications.md` - Notification requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

