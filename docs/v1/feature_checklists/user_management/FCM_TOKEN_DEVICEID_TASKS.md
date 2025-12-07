# FCM Token + DeviceId Registration - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **FCM Token + DeviceId Registration** feature for push notifications. Currently, this feature is **MISSING** - no deviceId capture, token saved only as ID token via `StorageService.setUserToken` (not FCM), and no push registration flow.

## Current Status: ⛔ MISSING

### What Exists (Related):
- ✅ `firebase_messaging` package is included in `pubspec.yaml`
- ✅ `device_info_plus` package is included in `pubspec.yaml`
- ✅ `NotificationService` exists and can get FCM token
- ✅ `StorageService.setUserToken` exists (but saves ID token, not FCM token)

### What's Missing/Broken:
- ⛔ No deviceId capture
- ⛔ No FCM token registration to Firebase
- ⛔ No device registration flow
- ⛔ No token refresh handling
- ⛔ No token revocation on logout
- ⛔ No device record structure in Firebase
- ⛔ No integration with login flow

---

## Task List

### Task 1: Create Device Registration Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent device registration with FCM token and deviceId.

**Files to Create**:
- `lib/features/auth/domain/entities/device_registration.dart` (new file)

**Implementation Steps**:
1. Create `DeviceRegistration` entity:
   ```dart
   class DeviceRegistration {
     final String deviceId;
     final String fcmToken;
     final String platform; // 'android' | 'ios'
     final String deviceModel;
     final String osVersion;
     final String appVersion;
     final DateTime registeredAt;
     final DateTime lastActiveAt;
     final bool isActive;
     
     const DeviceRegistration({
       required this.deviceId,
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
         deviceId: map['deviceId'] as String,
         fcmToken: map['fcmToken'] as String,
         platform: map['platform'] as String,
         deviceModel: map['deviceModel'] as String,
         osVersion: map['osVersion'] as String,
         appVersion: map['appVersion'] as String,
         registeredAt: DateTime.fromMillisecondsSinceEpoch(
           map['registeredAt'] as int,
         ),
         lastActiveAt: DateTime.fromMillisecondsSinceEpoch(
           map['lastActiveAt'] as int,
         ),
         isActive: (map['isActive'] as bool?) ?? true,
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'deviceId': deviceId,
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
   }
   ```

2. Add helper methods:
   - `copyWith` method
   - `isValid` method (check if token is not expired)
   - Equality and hashCode

**Expected Results**:
- ✅ DeviceRegistration entity exists
- ✅ Entity is serializable
- ✅ All device information fields are included

**Test Criteria**:
- Unit test: Test entity creation and serialization
- Test: Verify all fields are included

---

### Task 2: Create Device Info Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to capture device information (deviceId, platform, model, OS version, app version).

**Files to Create**:
- `lib/core/services/device_info_service.dart` (new file)

**Implementation Steps**:
1. Create `DeviceInfoService`:
   ```dart
   class DeviceInfoService {
     factory DeviceInfoService() => _instance ??= DeviceInfoService._();
     DeviceInfoService._();
     static DeviceInfoService? _instance;
     
     final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
     final PackageInfo _packageInfo = PackageInfo.fromPlatform();
     
     Future<String> getDeviceId() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return androidInfo.id; // Android ID
       } else if (Platform.isIOS) {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.identifierForVendor ?? '';
       }
       throw UnsupportedError('Platform not supported');
     }
     
     Future<String> getPlatform() async {
       if (Platform.isAndroid) return 'android';
       if (Platform.isIOS) return 'ios';
       throw UnsupportedError('Platform not supported');
     }
     
     Future<String> getDeviceModel() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return '${androidInfo.manufacturer} ${androidInfo.model}';
       } else if (Platform.isIOS) {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.model;
       }
       throw UnsupportedError('Platform not supported');
     }
     
     Future<String> getOsVersion() async {
       if (Platform.isAndroid) {
         final androidInfo = await _deviceInfo.androidInfo;
         return androidInfo.version.release;
       } else if (Platform.isIOS) {
         final iosInfo = await _deviceInfo.iosInfo;
         return iosInfo.systemVersion;
       }
       throw UnsupportedError('Platform not supported');
     }
     
     Future<String> getAppVersion() async {
       final packageInfo = await PackageInfo.fromPlatform();
       return packageInfo.version;
     }
     
     Future<Map<String, String>> getAllDeviceInfo() async {
       return {
         'deviceId': await getDeviceId(),
         'platform': await getPlatform(),
         'deviceModel': await getDeviceModel(),
         'osVersion': await getOsVersion(),
         'appVersion': await getAppVersion(),
       };
     }
   }
   ```

2. Add error handling for unsupported platforms
3. Add caching (optional - cache device info to avoid repeated calls)

**Expected Results**:
- ✅ DeviceInfoService exists
- ✅ All device information can be retrieved
- ✅ Platform-specific information is captured correctly
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test on Android and iOS (if possible)
- Test: Verify deviceId is unique
- Test: Verify all information is accurate

**Note**: May need to add `package_info_plus` dependency if not already included.

---

### Task 3: Create Device Registration Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to handle device registration (FCM token + deviceId) to Firebase.

**Files to Create**:
- `lib/core/services/device_registration_service.dart` (new file)

**Implementation Steps**:
1. Create `DeviceRegistrationService`:
   ```dart
   class DeviceRegistrationService {
     factory DeviceRegistrationService() => _instance ??= DeviceRegistrationService._();
     DeviceRegistrationService._();
     static DeviceRegistrationService? _instance;
     
     final DeviceInfoService _deviceInfoService = DeviceInfoService();
     final NotificationService _notificationService = NotificationService();
     final FirebaseDatabaseService _databaseService = FirebaseDatabaseService.instance;
     final StorageService _storageService = StorageService();
     
     /// Register device for current user
     Future<void> registerDevice(String userId) async {
       try {
         // Get device information
         final deviceInfo = await _deviceInfoService.getAllDeviceInfo();
         final deviceId = deviceInfo['deviceId']!;
         
         // Get FCM token
         final fcmToken = await _notificationService.getFCMToken();
         if (fcmToken == null) {
           throw Exception('Failed to get FCM token');
         }
         
         // Create device registration
         final registration = DeviceRegistration(
           deviceId: deviceId,
           fcmToken: fcmToken,
           platform: deviceInfo['platform']!,
           deviceModel: deviceInfo['deviceModel']!,
           osVersion: deviceInfo['osVersion']!,
           appVersion: deviceInfo['appVersion']!,
           registeredAt: DateTime.now(),
           lastActiveAt: DateTime.now(),
           isActive: true,
         );
         
         // Save to Firebase
         await _databaseService.registerDevice(userId, registration);
         
         // Save to local storage
         await _storageService.setString('fcm_token', fcmToken);
         await _storageService.setString('device_id', deviceId);
         
       } catch (e) {
         // Log error but don't throw (don't block login)
         debugPrint('Failed to register device: $e');
       }
     }
     
     /// Update device registration (e.g., on token refresh)
     Future<void> updateDeviceRegistration(String userId, String deviceId, {String? fcmToken}) async {
       try {
         final updates = <String, dynamic>{
           'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
         };
         
         if (fcmToken != null) {
           updates['fcmToken'] = fcmToken;
         }
         
         await _databaseService.updateDevice(userId, deviceId, updates);
         
         if (fcmToken != null) {
           await _storageService.setString('fcm_token', fcmToken);
         }
       } catch (e) {
         debugPrint('Failed to update device registration: $e');
       }
     }
     
     /// Revoke device registration (on logout)
     Future<void> revokeDeviceRegistration(String userId, String deviceId) async {
       try {
         await _databaseService.deleteDevice(userId, deviceId);
         
         // Clear local storage
         await _storageService.remove('fcm_token');
         await _storageService.remove('device_id');
       } catch (e) {
         debugPrint('Failed to revoke device registration: $e');
       }
     }
   }
   ```

2. Add error handling (don't block login if registration fails)
3. Add retry mechanism (optional)

**Expected Results**:
- ✅ DeviceRegistrationService exists
- ✅ Device registration works
- ✅ Token refresh is handled
- ✅ Token revocation works
- ✅ Errors don't block login

**Test Criteria**:
- Unit test: Test registration, update, revocation
- Integration test: Test with Firebase
- Test: Verify errors don't block login

---

### Task 4: Add Device Registration Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService to save/update/delete device registrations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add `registerDevice` method:
   ```dart
   Future<void> registerDevice(String userId, DeviceRegistration registration) async {
     try {
       final deviceRef = _database.ref('users/$userId/devices/${registration.deviceId}');
       await deviceRef.set(registration.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to register device: $e');
     }
   }
   ```

2. Add `updateDevice` method:
   ```dart
   Future<void> updateDevice(String userId, String deviceId, Map<String, dynamic> updates) async {
     try {
       final deviceRef = _database.ref('users/$userId/devices/$deviceId');
       await deviceRef.update(updates);
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to update device: $e');
     }
   }
   ```

3. Add `deleteDevice` method:
   ```dart
   Future<void> deleteDevice(String userId, String deviceId) async {
     try {
       final deviceRef = _database.ref('users/$userId/devices/$deviceId');
       await deviceRef.remove();
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to delete device: $e');
     }
   }
   ```

4. Add `getUserDevices` method (optional - for listing user's devices):
   ```dart
   Future<List<DeviceRegistration>> getUserDevices(String userId) async {
     try {
       final devicesRef = _database.ref('users/$userId/devices');
       final snapshot = await devicesRef.get();
       
       if (!snapshot.exists) return [];
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return [];
       
       return data.values
           .map((deviceData) => DeviceRegistration.fromMap(
                 Map<String, dynamic>.from(deviceData as Map),
               ))
           .toList();
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get user devices: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Device registration methods exist
- ✅ Methods work correctly with Firebase
- ✅ Error handling is robust

**Test Criteria**:
- Integration test: Test with Firebase
- Test: Verify device records are created/updated/deleted correctly

---

### Task 5: Integrate Device Registration with Login Flow

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate device registration into AuthController login flow.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Add DeviceRegistrationService dependency:
   ```dart
   final DeviceRegistrationService _deviceRegistrationService = DeviceRegistrationService();
   ```

2. Update `_handleUserSignIn` method:
   ```dart
   Future<void> _handleUserSignIn(firebase_auth.User firebaseUser) async {
     try {
       isLoading = true;
       
       // ... existing user creation/login logic ...
       
       // Register device for push notifications
       await _deviceRegistrationService.registerDevice(user.id);
       
       // ... rest of login flow ...
     } catch (e) {
       // Handle error
     }
   }
   ```

3. Ensure registration doesn't block login:
   - Wrap in try-catch
   - Don't throw error if registration fails
   - Log error for debugging

4. Update `signOut` method to revoke device:
   ```dart
   Future<void> signOut() async {
     try {
       final userId = _currentUser.value?.id;
       final deviceId = await _storageService.getString('device_id');
       
       if (userId != null && deviceId != null) {
         await _deviceRegistrationService.revokeDeviceRegistration(userId, deviceId);
       }
       
       // ... rest of sign out logic ...
     } catch (e) {
       // Handle error
     }
   }
   ```

**Expected Results**:
- ✅ Device registration happens on login
- ✅ Device revocation happens on logout
- ✅ Registration doesn't block login
- ✅ Errors are handled gracefully

**Test Criteria**:
- Test: Login, verify device is registered
- Test: Logout, verify device is revoked
- Test: Verify login is not blocked if registration fails

---

### Task 6: Handle FCM Token Refresh

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Handle FCM token refresh and update Firebase.

**Files to Modify**:
- `lib/core/services/notification_service.dart`
- `lib/core/services/device_registration_service.dart`

**Implementation Steps**:
1. Update `NotificationService._initializeFirebaseMessaging`:
   ```dart
   firebaseMessaging.onTokenRefresh.listen((token) async {
     try {
       final userId = Get.find<AuthController>().currentUser?.id;
       final deviceId = await StorageService().getString('device_id');
       
       if (userId != null && deviceId != null) {
         await DeviceRegistrationService().updateDeviceRegistration(
           userId,
           deviceId,
           fcmToken: token,
         );
       }
     } catch (e) {
       debugPrint('Failed to update FCM token on refresh: $e');
     }
   });
   ```

2. Add token refresh listener in DeviceRegistrationService:
   ```dart
   void setupTokenRefreshListener() {
     _notificationService.firebaseMessaging.onTokenRefresh.listen((token) async {
       final userId = Get.find<AuthController>().currentUser?.id;
       final deviceId = await _storageService.getString('device_id');
       
       if (userId != null && deviceId != null) {
         await updateDeviceRegistration(userId, deviceId, fcmToken: token);
       }
     });
   }
   ```

3. Call setup in initialization

**Expected Results**:
- ✅ Token refresh is handled automatically
- ✅ Firebase is updated with new token
- ✅ Local storage is updated
- ✅ No duplicate tokens

**Test Criteria**:
- Test: Simulate token refresh, verify update
- Test: Verify Firebase is updated
- Test: Verify local storage is updated

---

### Task 7: Add Local Storage for FCM Token and DeviceId

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add methods to StorageService for FCM token and deviceId.

**Files to Modify**:
- `lib/core/services/storage_service.dart`

**Implementation Steps**:
1. Add convenience methods:
   ```dart
   Future<void> setFcmToken(String token) async {
     await setString('fcm_token', token);
   }
   
   String? getFcmToken() {
     return getString('fcm_token');
   }
   
   Future<void> setDeviceId(String deviceId) async {
     await setString('device_id', deviceId);
   }
   
   String? getDeviceId() {
     return getString('device_id');
   }
   ```

2. Update `clearAllData` to clear FCM token and deviceId:
   ```dart
   Future<void> clearAllData() async {
     await clear();
     await remove('fcm_token');
     await remove('device_id');
     // ... rest of clear logic ...
   }
   ```

**Expected Results**:
- ✅ FCM token and deviceId can be stored/retrieved
- ✅ Data is cleared on logout

**Test Criteria**:
- Test: Store and retrieve FCM token
- Test: Store and retrieve deviceId
- Test: Verify data is cleared on logout

---

### Task 8: Add Firebase Security Rules for Device Registration

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Firebase security rules to protect device registration data.

**Files to Modify**:
- `firebase_database_rules.json`

**Implementation Steps**:
1. Add security rules for device registration:
   ```json
   {
     "rules": {
       "users": {
         "$userId": {
           "devices": {
             ".read": "auth != null && auth.uid == $userId",
             ".write": "auth != null && auth.uid == $userId",
             "$deviceId": {
               ".validate": "newData.hasChildren(['deviceId', 'fcmToken', 'platform', 'deviceModel', 'osVersion', 'appVersion', 'registeredAt', 'lastActiveAt', 'isActive'])"
             }
           }
         }
       }
     }
   }
   ```

2. Ensure only authenticated users can register their own devices
3. Validate device registration structure

**Expected Results**:
- ✅ Security rules protect device data
- ✅ Only authorized users can register devices
- ✅ Device structure is validated

**Test Criteria**:
- Test: Verify unauthorized access is denied
- Test: Verify structure validation works

---

### Task 9: Add Error Handling and Retry Mechanism

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add robust error handling and retry mechanism for device registration.

**Files to Modify**:
- `lib/core/services/device_registration_service.dart`

**Implementation Steps**:
1. Add retry mechanism:
   ```dart
   Future<void> registerDeviceWithRetry(String userId, {int maxRetries = 3}) async {
     int attempts = 0;
     while (attempts < maxRetries) {
       try {
         await registerDevice(userId);
         return; // Success
       } catch (e) {
         attempts++;
         if (attempts >= maxRetries) {
           debugPrint('Failed to register device after $maxRetries attempts: $e');
           return; // Don't throw, just log
         }
         // Wait before retry (exponential backoff)
         await Future.delayed(Duration(seconds: attempts * 2));
       }
     }
   }
   ```

2. Add network check:
   ```dart
   Future<bool> _isNetworkAvailable() async {
     // Check connectivity
     // Return true if online
   }
   ```

3. Queue registration if offline:
   - Store registration request
   - Retry when network is available

**Expected Results**:
- ✅ Retry mechanism works
- ✅ Offline registration is queued
- ✅ Errors are handled gracefully

**Test Criteria**:
- Test: Simulate network failure, verify retry
- Test: Go offline, verify queue
- Test: Go online, verify retry

---

### Task 10: Add Device Registration Status Check

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add method to check if device is already registered.

**Files to Modify**:
- `lib/core/services/device_registration_service.dart`

**Implementation Steps**:
1. Add `isDeviceRegistered` method:
   ```dart
   Future<bool> isDeviceRegistered(String userId, String deviceId) async {
     try {
       final device = await _databaseService.getDevice(userId, deviceId);
       return device != null && device.isActive;
     } catch (e) {
       return false;
     }
   }
   ```

2. Add `getDevice` method to FirebaseDatabaseService:
   ```dart
   Future<DeviceRegistration?> getDevice(String userId, String deviceId) async {
     try {
       final deviceRef = _database.ref('users/$userId/devices/$deviceId');
       final snapshot = await deviceRef.get();
       
       if (!snapshot.exists) return null;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return null;
       
       return DeviceRegistration.fromMap(Map<String, dynamic>.from(data));
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get device: $e');
     }
   }
   ```

3. Use check to avoid duplicate registrations:
   - Check if device is already registered
   - Update instead of create if exists

**Expected Results**:
- ✅ Device registration status can be checked
- ✅ Duplicate registrations are avoided
- ✅ Existing registrations are updated

**Test Criteria**:
- Test: Check registration status
- Test: Verify no duplicates
- Test: Verify updates work

---

### Task 11: Add AppStrings for Device Registration

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add AppStrings constants for device registration messages (if any user-facing messages are needed).

**Files to Modify**:
- `lib/core/constants/app_strings.dart`

**Implementation Steps**:
1. Add strings (if needed):
   ```dart
   static const String deviceRegistrationFailed = 'Failed to register device for push notifications';
   static const String deviceRegistrationSuccess = 'Device registered for push notifications';
   // ... other strings if needed
   ```

2. Note: Most device registration should be silent (no user-facing messages)

**Expected Results**:
- ✅ All user-facing strings use AppStrings
- ✅ No hardcoded strings

**Test Criteria**:
- Test: Verify all strings use AppStrings

---

### Task 12: Add Unit Tests for Device Registration

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for device registration functionality.

**Files to Create/Modify**:
- `test/core/services/device_info_service_test.dart`
- `test/core/services/device_registration_service_test.dart`
- `test/core/services/firebase_database_service_test.dart` (add device methods)

**Implementation Steps**:
1. Test DeviceInfoService:
   - Test deviceId retrieval
   - Test platform detection
   - Test device model retrieval
   - Test OS version retrieval
   - Test app version retrieval

2. Test DeviceRegistrationService:
   - Test device registration
   - Test device update
   - Test device revocation
   - Test error handling
   - Test retry mechanism

3. Test FirebaseDatabaseService device methods:
   - Test registerDevice
   - Test updateDevice
   - Test deleteDevice
   - Test getUserDevices

4. Test integration with AuthController:
   - Test registration on login
   - Test revocation on logout

**Expected Results**:
- ✅ Unit tests cover device registration
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Device Registration Entity (Critical - Foundation)
2. **Task 2**: Create Device Info Service (Critical - Foundation)
3. **Task 4**: Add Device Registration Methods to FirebaseDatabaseService (Critical - Data Layer)
4. **Task 3**: Create Device Registration Service (High Priority - Core Feature)
5. **Task 5**: Integrate Device Registration with Login Flow (High Priority - Integration)
6. **Task 6**: Handle FCM Token Refresh (High Priority - Feature Completeness)
7. **Task 7**: Add Local Storage for FCM Token and DeviceId (Medium Priority - Offline Support)
8. **Task 8**: Add Firebase Security Rules (High Priority - Security)
9. **Task 9**: Add Error Handling and Retry Mechanism (Medium Priority - Reliability)
10. **Task 10**: Add Device Registration Status Check (Low Priority - Optimization)
11. **Task 11**: Add AppStrings (Low Priority - Code Quality)
12. **Task 12**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ DeviceRegistration entity exists
- ✅ DeviceInfoService can capture device information
- ✅ DeviceRegistrationService can register devices
- ✅ FirebaseDatabaseService can save/update/delete devices
- ✅ Device registration happens on login
- ✅ Device revocation happens on logout
- ✅ FCM token refresh is handled
- ✅ Local storage is used for offline support
- ✅ Security rules protect device data
- ✅ Error handling and retry mechanism work
- ✅ Unit tests have minimum 80% coverage
- ✅ No known bugs or issues

---

## Dependencies

- **firebase_messaging**: Required for FCM token
- **device_info_plus**: Required for deviceId capture
- **package_info_plus**: May be needed for app version (check if already included)
- **Firebase Realtime Database**: Required for storing device records
- **AuthController**: Required for user authentication
- **NotificationService**: Required for FCM token retrieval
- **StorageService**: Required for local storage
- **GetX**: Required for dependency injection (project rule)

---

## Notes

1. **FCM Token vs ID Token**: FCM token is for push notifications. ID token is for authentication. These are different and both may be needed.

2. **DeviceId Uniqueness**: DeviceId should be unique per device. Android ID or iOS identifierForVendor can be used.

3. **Registration Timing**: Device registration should happen after successful login, not on app start.

4. **Error Handling**: Registration failures should not block login. System should retry when possible.

5. **Token Refresh**: FCM tokens can refresh automatically. System must handle refresh and update Firebase.

6. **Multiple Devices**: Users should be able to register multiple devices. Each device should have its own record.

7. **Security**: Only authenticated users can register their own devices. Firebase security rules must enforce this.

8. **Offline Support**: Device registration should be queued if offline and retried when online.

9. **Privacy**: Device information should be stored securely and only used for push notifications.

10. **Token Revocation**: Tokens should be revoked on logout to prevent unauthorized push notifications.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `FCM_TOKEN_DEVICEID_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/notifications/NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Related notifications audit
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements
