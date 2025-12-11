# Notification Subscription Management (Enable/Disable Groups, DND, Quiet Hours) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Notification Subscription Management** feature (enable/disable notification groups: task updates, mentions, workspace changes; DND/quiet hours). Currently, this feature is **MISSING** - Not implemented; no user prefs or UI for categories/DND.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `NotificationSettingsPage` exists with basic toggles
- ✅ Settings are saved to local storage
- ✅ Basic notification toggles (task reminders, report reminders, etc.)
- ✅ Reminder time picker

### What's Missing/Broken:
- ⛔ No `NotificationPreferences` entity
- ⛔ No notification preferences service
- ⛔ No Firebase sync for preferences
- ⛔ No notification group toggles (task updates, mentions, workspace changes)
- ⛔ No DND (Do Not Disturb) mode
- ⛔ No quiet hours configuration
- ⛔ No preference checking in push service
- ⛔ No workspace scoping for preferences

---

## Task List

### Task 1: Create NotificationPreferences Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent notification preferences with groups, DND, and quiet hours.

**Files to Create**:
- `lib/features/notifications/domain/entities/notification_preferences.dart` (new file)

**Implementation Steps**:
1. Create `NotificationPreferences` entity:
   ```dart
   class NotificationPreferences {
     final String userId;
     final String workspaceId;
     
     // Notification groups
     final bool taskUpdatesEnabled;
     final bool mentionsEnabled;
     final bool workspaceChangesEnabled;
     
     // DND and quiet hours
     final bool dndEnabled;
     final String? quietHoursStart; // Format: "HH:mm"
     final String? quietHoursEnd; // Format: "HH:mm"
     
     final DateTime updatedAt;
     
     const NotificationPreferences({
       required this.userId,
       required this.workspaceId,
       this.taskUpdatesEnabled = true,
       this.mentionsEnabled = true,
       this.workspaceChangesEnabled = true,
       this.dndEnabled = false,
       this.quietHoursStart,
       this.quietHoursEnd,
       required this.updatedAt,
     });
     
     factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
       return NotificationPreferences(
         userId: map['userId'] ?? '',
         workspaceId: map['workspaceId'] ?? '',
         taskUpdatesEnabled: map['taskUpdatesEnabled'] ?? true,
         mentionsEnabled: map['mentionsEnabled'] ?? true,
         workspaceChangesEnabled: map['workspaceChangesEnabled'] ?? true,
         dndEnabled: map['dndEnabled'] ?? false,
         quietHoursStart: map['quietHoursStart'],
         quietHoursEnd: map['quietHoursEnd'],
         updatedAt: DateTime.fromMillisecondsSinceEpoch(
           map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
         ),
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'userId': userId,
         'workspaceId': workspaceId,
         'taskUpdatesEnabled': taskUpdatesEnabled,
         'mentionsEnabled': mentionsEnabled,
         'workspaceChangesEnabled': workspaceChangesEnabled,
         'dndEnabled': dndEnabled,
         'quietHoursStart': quietHoursStart,
         'quietHoursEnd': quietHoursEnd,
         'updatedAt': updatedAt.millisecondsSinceEpoch,
       };
     }
     
     NotificationPreferences copyWith({
       String? userId,
       String? workspaceId,
       bool? taskUpdatesEnabled,
       bool? mentionsEnabled,
       bool? workspaceChangesEnabled,
       bool? dndEnabled,
       String? quietHoursStart,
       String? quietHoursEnd,
       DateTime? updatedAt,
     }) {
       return NotificationPreferences(
         userId: userId ?? this.userId,
         workspaceId: workspaceId ?? this.workspaceId,
         taskUpdatesEnabled: taskUpdatesEnabled ?? this.taskUpdatesEnabled,
         mentionsEnabled: mentionsEnabled ?? this.mentionsEnabled,
         workspaceChangesEnabled: workspaceChangesEnabled ?? this.workspaceChangesEnabled,
         dndEnabled: dndEnabled ?? this.dndEnabled,
         quietHoursStart: quietHoursStart ?? this.quietHoursStart,
         quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
         updatedAt: updatedAt ?? this.updatedAt,
       );
     }
     
     /// Check if notification should be sent based on preferences
     bool shouldSendNotification(String notificationType) {
       // Check DND first
       if (dndEnabled) return false;
       
       // Check quiet hours
       if (_isWithinQuietHours()) return false;
       
       // Check group settings
       switch (notificationType) {
         case 'task_update':
         case 'task_created':
         case 'task_updated':
         case 'task_deleted':
         case 'task_assigned':
           return taskUpdatesEnabled;
         case 'mention':
           return mentionsEnabled;
         case 'workspace_member_added':
         case 'workspace_member_removed':
         case 'workspace_role_changed':
         case 'workspace_updated':
           return workspaceChangesEnabled;
         default:
           return true; // Default to enabled for unknown types
       }
     }
     
     bool _isWithinQuietHours() {
       if (quietHoursStart == null || quietHoursEnd == null) return false;
       
       final now = DateTime.now();
       final startTime = _parseTime(quietHoursStart!);
       final endTime = _parseTime(quietHoursEnd!);
       
       final currentTime = TimeOfDay.fromDateTime(now);
       
       if (startTime.hour < endTime.hour) {
         // Same day (e.g., 14:00 to 16:00)
         return currentTime.hour >= startTime.hour &&
                currentTime.hour < endTime.hour;
       } else {
         // Spans midnight (e.g., 22:00 to 08:00)
         return currentTime.hour >= startTime.hour ||
                currentTime.hour < endTime.hour;
       }
     }
     
     TimeOfDay _parseTime(String timeStr) {
       final parts = timeStr.split(':');
       return TimeOfDay(
         hour: int.parse(parts[0]),
         minute: int.parse(parts[1]),
       );
     }
   }
   ```

2. Add validation methods

**Expected Results**:
- ✅ NotificationPreferences entity exists
- ✅ Entity can be serialized/deserialized
- ✅ Entity includes all required fields
- ✅ Entity has logic to check if notification should be sent

**Test Criteria**:
- Unit test: Test entity creation
- Unit test: Test serialization/deserialization
- Unit test: Test `shouldSendNotification` method
- Unit test: Test quiet hours logic

---

### Task 2: Create NotificationPreferencesService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for managing notification preferences (load, save, sync to Firebase).

**Files to Create**:
- `lib/core/services/notification_preferences_service.dart` (new file)

**Implementation Steps**:
1. Create `NotificationPreferencesService`:
   ```dart
   class NotificationPreferencesService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     /// Get notification preferences for user and workspace
     Future<NotificationPreferences> getPreferences({
       required String userId,
       required String workspaceId,
     }) async {
       try {
         // Try to load from Firebase first
         final firebasePrefs = await _databaseService.getNotificationPreferences(
           userId: userId,
           workspaceId: workspaceId,
         );
         
         if (firebasePrefs != null) {
           // Save to local storage for offline access
           await _saveToLocalStorage(firebasePrefs);
           return firebasePrefs;
         }
         
         // Fallback to local storage
         final localPrefs = await _loadFromLocalStorage(userId, workspaceId);
         if (localPrefs != null) {
           return localPrefs;
         }
         
         // Return defaults
         return NotificationPreferences(
           userId: userId,
           workspaceId: workspaceId,
           updatedAt: DateTime.now(),
         );
       } catch (e) {
         Get.log('Failed to get notification preferences: $e');
         // Return defaults on error
         return NotificationPreferences(
           userId: userId,
           workspaceId: workspaceId,
           updatedAt: DateTime.now(),
         );
       }
     }
     
     /// Save notification preferences
     Future<void> savePreferences(NotificationPreferences preferences) async {
       try {
         // Save to Firebase
         await _databaseService.saveNotificationPreferences(preferences);
         
         // Save to local storage
         await _saveToLocalStorage(preferences);
       } catch (e) {
         Get.log('Failed to save notification preferences: $e');
         rethrow;
       }
     }
     
     /// Update notification preferences
     Future<void> updatePreferences({
       required String userId,
       required String workspaceId,
       bool? taskUpdatesEnabled,
       bool? mentionsEnabled,
       bool? workspaceChangesEnabled,
       bool? dndEnabled,
       String? quietHoursStart,
       String? quietHoursEnd,
     }) async {
       try {
         final current = await getPreferences(
           userId: userId,
           workspaceId: workspaceId,
         );
         
         final updated = current.copyWith(
           taskUpdatesEnabled: taskUpdatesEnabled,
           mentionsEnabled: mentionsEnabled,
           workspaceChangesEnabled: workspaceChangesEnabled,
           dndEnabled: dndEnabled,
           quietHoursStart: quietHoursStart,
           quietHoursEnd: quietHoursEnd,
           updatedAt: DateTime.now(),
         );
         
         await savePreferences(updated);
       } catch (e) {
         Get.log('Failed to update notification preferences: $e');
         rethrow;
       }
     }
     
     Future<void> _saveToLocalStorage(NotificationPreferences preferences) async {
       final key = 'notification_preferences_${preferences.userId}_${preferences.workspaceId}';
       await _storageService.setString(key, jsonEncode(preferences.toMap()));
     }
     
     Future<NotificationPreferences?> _loadFromLocalStorage(
       String userId,
       String workspaceId,
     ) async {
       try {
         final key = 'notification_preferences_${userId}_${workspaceId}';
         final jsonStr = _storageService.getString(key);
         if (jsonStr == null) return null;
         
         final map = jsonDecode(jsonStr) as Map<String, dynamic>;
         return NotificationPreferences.fromMap(map);
       } catch (e) {
         return null;
       }
     }
   }
   ```

2. Add imports:
   ```dart
   import 'dart:convert';
   import 'package:get/get.dart';
   ```

**Expected Results**:
- ✅ NotificationPreferencesService exists
- ✅ Service can load preferences from Firebase
- ✅ Service can save preferences to Firebase
- ✅ Service falls back to local storage
- ✅ Service provides defaults

**Test Criteria**:
- Unit test: Test load preferences
- Unit test: Test save preferences
- Unit test: Test update preferences
- Test: Test Firebase sync
- Test: Test local storage fallback

---

### Task 3: Add Notification Preferences Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for notification preferences operations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add notification preferences methods:
   ```dart
   /// Get notification preferences for user and workspace
   Future<NotificationPreferences?> getNotificationPreferences({
     required String userId,
     required String workspaceId,
   }) async {
     try {
       final ref = _database.ref('users/$userId/workspaces/$workspaceId/notificationPreferences');
       final snapshot = await ref.get();
       
       if (!snapshot.exists) return null;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return null;
       
       return NotificationPreferences.fromMap(
         Map<String, dynamic>.from(data),
       );
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get notification preferences: $e');
     }
   }
   
   /// Save notification preferences
   Future<void> saveNotificationPreferences(NotificationPreferences preferences) async {
     try {
       final ref = _database.ref(
         'users/${preferences.userId}/workspaces/${preferences.workspaceId}/notificationPreferences',
       );
       await ref.set(preferences.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to save notification preferences: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Database methods exist
- ✅ Methods work correctly
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 4: Update NotificationSettingsPage with Required Categories

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update NotificationSettingsPage to include task updates, mentions, and workspace changes groups.

**Files to Modify**:
- `lib/app/pages/settings/notification_settings_page.dart`

**Implementation Steps**:
1. Inject `NotificationPreferencesService`:
   ```dart
   final NotificationPreferencesService _preferencesService = Get.find<NotificationPreferencesService>();
   final AuthController _authController = Get.find<AuthController>();
   ```

2. Add observables for new groups:
   ```dart
   final RxBool _taskUpdatesEnabled = true.obs;
   final RxBool _mentionsEnabled = true.obs;
   final RxBool _workspaceChangesEnabled = true.obs;
   ```

3. Update `_loadSettings` method:
   ```dart
   Future<void> _loadSettings() async {
     try {
       _isLoading.value = true;
       
       final userId = _authController.currentUser?.id;
       final workspaceId = _storageService.getWorkspaceId();
       
       if (userId != null && workspaceId != null) {
         final preferences = await _preferencesService.getPreferences(
           userId: userId,
           workspaceId: workspaceId,
         );
         
         _taskUpdatesEnabled.value = preferences.taskUpdatesEnabled;
         _mentionsEnabled.value = preferences.mentionsEnabled;
         _workspaceChangesEnabled.value = preferences.workspaceChangesEnabled;
       }
       
       // ... existing local storage loading ...
     } finally {
       _isLoading.value = false;
     }
   }
   ```

4. Update `_saveSettings` method:
   ```dart
   Future<void> _saveSettings() async {
     try {
       _isLoading.value = true;
       
       final userId = _authController.currentUser?.id;
       final workspaceId = _storageService.getWorkspaceId();
       
       if (userId != null && workspaceId != null) {
         await _preferencesService.updatePreferences(
           userId: userId,
           workspaceId: workspaceId,
           taskUpdatesEnabled: _taskUpdatesEnabled.value,
           mentionsEnabled: _mentionsEnabled.value,
           workspaceChangesEnabled: _workspaceChangesEnabled.value,
         );
       }
       
       // ... existing local storage saving ...
       
       SnackbarService().showSuccess(
         title: AppStrings.success,
         message: AppStrings.notificationSettingsSaved,
       );
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.failedToSaveSettings,
       );
     } finally {
       _isLoading.value = false;
     }
   }
   ```

5. Add UI for new groups:
   ```dart
   // Notification Groups Section
   _buildSectionHeader(AppStrings.notificationGroups),
   const SizedBox(height: 16),
   
   _buildSwitchTile(
     title: AppStrings.taskUpdates,
     subtitle: AppStrings.receiveNotificationsForTaskUpdates,
     value: _taskUpdatesEnabled.value,
     onChanged: (value) => _taskUpdatesEnabled.value = value,
     icon: Icons.update,
   ),
   
   _buildSwitchTile(
     title: AppStrings.mentions,
     subtitle: AppStrings.receiveNotificationsForMentions,
     value: _mentionsEnabled.value,
     onChanged: (value) => _mentionsEnabled.value = value,
     icon: Icons.alternate_email,
   ),
   
   _buildSwitchTile(
     title: AppStrings.workspaceChanges,
     subtitle: AppStrings.receiveNotificationsForWorkspaceChanges,
     value: _workspaceChangesEnabled.value,
     onChanged: (value) => _workspaceChangesEnabled.value = value,
     icon: Icons.business,
   ),
   ```

6. Use AppStrings for all text

**Expected Results**:
- ✅ Notification groups are displayed
- ✅ Groups can be enabled/disabled
- ✅ Settings are saved to Firebase
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: Groups are visible
- Test: Groups can be toggled
- Test: Settings are saved
- Test: Settings persist

---

### Task 5: Add DND (Do Not Disturb) Mode

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add DND mode toggle to NotificationSettingsPage.

**Files to Modify**:
- `lib/app/pages/settings/notification_settings_page.dart`

**Implementation Steps**:
1. Add observable for DND:
   ```dart
   final RxBool _dndEnabled = false.obs;
   ```

2. Update `_loadSettings` to load DND:
   ```dart
   _dndEnabled.value = preferences.dndEnabled;
   ```

3. Update `_saveSettings` to save DND:
   ```dart
   dndEnabled: _dndEnabled.value,
   ```

4. Add UI for DND:
   ```dart
   // DND Section
   _buildSectionHeader(AppStrings.doNotDisturb),
   const SizedBox(height: 16),
   
   _buildSwitchTile(
     title: AppStrings.enableDoNotDisturb,
     subtitle: AppStrings.doNotDisturbDescription,
     value: _dndEnabled.value,
     onChanged: (value) => _dndEnabled.value = value,
     icon: Icons.notifications_off,
   ),
   ```

5. Use AppStrings for all text

**Expected Results**:
- ✅ DND toggle is displayed
- ✅ DND can be enabled/disabled
- ✅ Settings are saved
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: DND toggle is visible
- Test: DND can be toggled
- Test: Settings are saved
- Test: DND suppresses notifications

---

### Task 6: Add Quiet Hours Configuration

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add quiet hours configuration to NotificationSettingsPage.

**Files to Modify**:
- `lib/app/pages/settings/notification_settings_page.dart`

**Implementation Steps**:
1. Add observables for quiet hours:
   ```dart
   final RxBool _quietHoursEnabled = false.obs;
   final RxString _quietHoursStart = '22:00'.obs;
   final RxString _quietHoursEnd = '08:00'.obs;
   ```

2. Update `_loadSettings` to load quiet hours:
   ```dart
   _quietHoursEnabled.value = preferences.quietHoursStart != null;
   if (preferences.quietHoursStart != null) {
     _quietHoursStart.value = preferences.quietHoursStart!;
   }
   if (preferences.quietHoursEnd != null) {
     _quietHoursEnd.value = preferences.quietHoursEnd!;
   }
   ```

3. Update `_saveSettings` to save quiet hours:
   ```dart
   quietHoursStart: _quietHoursEnabled.value ? _quietHoursStart.value : null,
   quietHoursEnd: _quietHoursEnabled.value ? _quietHoursEnd.value : null,
   ```

4. Add UI for quiet hours:
   ```dart
   // Quiet Hours Section
   _buildSectionHeader(AppStrings.quietHours),
   const SizedBox(height: 16),
   
   _buildSwitchTile(
     title: AppStrings.enableQuietHours,
     subtitle: AppStrings.quietHoursDescription,
     value: _quietHoursEnabled.value,
     onChanged: (value) => _quietHoursEnabled.value = value,
     icon: Icons.bedtime,
   ),
   
   if (_quietHoursEnabled.value) ...[
     const SizedBox(height: 16),
     _buildTimePicker(
       title: AppStrings.quietHoursStart,
       value: _quietHoursStart.value,
       onChanged: (time) => _quietHoursStart.value = time,
     ),
     const SizedBox(height: 8),
     _buildTimePicker(
       title: AppStrings.quietHoursEnd,
       value: _quietHoursEnd.value,
       onChanged: (time) => _quietHoursEnd.value = time,
     ),
   ],
   ```

5. Add time picker method:
   ```dart
   Widget _buildTimePicker({
     required String title,
     required String value,
     required ValueChanged<String> onChanged,
   }) {
     return InkWell(
       onTap: () async {
         final time = await showTimePicker(
           context: context,
           initialTime: TimeOfDay.fromDateTime(
             DateTime.parse('2023-01-01 $value:00'),
           ),
         );
         
         if (time != null) {
           final hour = time.hour.toString().padLeft(2, '0');
           final minute = time.minute.toString().padLeft(2, '0');
           onChanged('$hour:$minute');
         }
       },
       child: Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: AppColors.surface,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: AppColors.outline),
         ),
         child: Row(
           children: [
             Text(
               title,
               style: Theme.of(context).textTheme.bodyMedium,
             ),
             const Spacer(),
             Text(
               value,
               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                 fontWeight: FontWeight.bold,
                 color: AppColors.primary,
               ),
             ),
             const SizedBox(width: 8),
             Icon(Icons.access_time, color: AppColors.primary),
           ],
         ),
       ),
     );
   }
   ```

6. Add validation for quiet hours:
   ```dart
   bool _validateQuietHours() {
     if (!_quietHoursEnabled.value) return true;
     
     if (_quietHoursStart.value == _quietHoursEnd.value) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.quietHoursStartEndCannotBeSame,
       );
       return false;
     }
     
     return true;
   }
   ```

7. Use AppStrings for all text

**Expected Results**:
- ✅ Quiet hours toggle is displayed
- ✅ Quiet hours can be configured
- ✅ Time pickers work correctly
- ✅ Validation works
- ✅ Settings are saved
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: Quiet hours toggle is visible
- Test: Time pickers work
- Test: Validation works
- Test: Settings are saved
- Test: Quiet hours suppress notifications

---

### Task 7: Add Preference Checking to Push Notification Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update push notification service to check preferences before sending.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Inject `NotificationPreferencesService`:
   ```dart
   final NotificationPreferencesService _preferencesService = Get.find<NotificationPreferencesService>();
   ```

2. Update `sendToUser` method to check preferences:
   ```dart
   Future<PushNotificationResult> sendToUser({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
     required String notificationType, // e.g., 'task_update', 'mention', 'workspace_change'
   }) async {
     try {
       // Get user's workspace
       final workspaceId = await _getUserWorkspace(userId);
       if (workspaceId == null) {
         return PushNotificationResult(
           success: false,
           error: 'User workspace not found',
         );
       }
       
       // Get notification preferences
       final preferences = await _preferencesService.getPreferences(
         userId: userId,
         workspaceId: workspaceId,
       );
       
       // Check if notification should be sent
       if (!preferences.shouldSendNotification(notificationType)) {
         Get.log('Notification suppressed by preferences: $notificationType');
         return PushNotificationResult(
           success: false,
           error: 'Notification suppressed by preferences',
           suppressed: true,
         );
       }
       
       // Proceed with sending notification
       // ... existing send logic ...
     } catch (e) {
       return PushNotificationResult(
         success: false,
         error: 'Failed to send push notification: $e',
       );
     }
   }
   ```

3. Update all push trigger calls to include notification type:
   ```dart
   await _pushService.sendToUser(
     userId: userId,
     title: title,
     body: body,
     data: data,
     notificationType: 'task_update', // or 'mention', 'workspace_change'
   );
   ```

**Expected Results**:
- ✅ Push service checks preferences
- ✅ Notifications are suppressed if preferences disable them
- ✅ DND and quiet hours are respected
- ✅ Notification type is passed correctly

**Test Criteria**:
- Test: Preferences are checked
- Test: Notifications are suppressed when disabled
- Test: DND suppresses notifications
- Test: Quiet hours suppress notifications

---

### Task 8: Add Workspace Scoping for Preferences

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Ensure notification preferences are scoped to workspace.

**Files to Modify**:
- `lib/core/services/notification_preferences_service.dart`
- `lib/app/pages/settings/notification_settings_page.dart`

**Implementation Steps**:
1. Update `NotificationSettingsPage` to load preferences for current workspace:
   ```dart
   Future<void> _loadSettings() async {
     try {
       _isLoading.value = true;
       
       final userId = _authController.currentUser?.id;
       final workspaceId = _storageService.getWorkspaceId(); // Current workspace
       
       if (userId != null && workspaceId != null) {
         final preferences = await _preferencesService.getPreferences(
           userId: userId,
           workspaceId: workspaceId,
         );
         
         // Load preferences for current workspace
         _taskUpdatesEnabled.value = preferences.taskUpdatesEnabled;
         // ... other preferences ...
       }
     } finally {
       _isLoading.value = false;
     }
   }
   ```

2. Ensure preferences are saved per workspace:
   - Preferences are already saved per workspace in Firebase path
   - Verify workspace switching loads correct preferences

3. Add workspace context to UI:
   ```dart
   Widget _buildWorkspaceContext() {
     final workspaceId = _storageService.getWorkspaceId();
     final workspaceName = _getWorkspaceName(workspaceId);
     
     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: AppColors.surface,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: AppColors.outline),
       ),
       child: Row(
         children: [
           Icon(Icons.business, color: AppColors.primary),
           const SizedBox(width: 12),
           Text(
             '${AppStrings.settingsFor}: $workspaceName',
             style: Theme.of(context).textTheme.bodyMedium,
           ),
         ],
       ),
     );
   }
   ```

**Expected Results**:
- ✅ Preferences are scoped to workspace
- ✅ Each workspace has independent preferences
- ✅ Workspace context is shown in UI

**Test Criteria**:
- Test: Preferences are per workspace
- Test: Switching workspaces loads correct preferences
- Test: Workspace context is shown

---

### Task 9: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for notification subscription management.

**Files to Create**:
- `test/features/notifications/domain/entities/notification_preferences_test.dart`
- `test/core/services/notification_preferences_service_test.dart`

**Expected Results**:
- ✅ Unit tests cover notification preferences
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create NotificationPreferences Entity (Critical - Foundation)
2. **Task 2**: Create NotificationPreferencesService (Critical - Core Logic)
3. **Task 3**: Add Notification Preferences Methods to FirebaseDatabaseService (Critical - Data Layer)
4. **Task 4**: Update NotificationSettingsPage with Required Categories (High Priority - UI)
5. **Task 5**: Add DND Mode (High Priority - Feature)
6. **Task 6**: Add Quiet Hours Configuration (High Priority - Feature)
7. **Task 7**: Add Preference Checking to Push Notification Service (High Priority - Integration)
8. **Task 8**: Add Workspace Scoping for Preferences (Medium Priority - Feature)
9. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ NotificationPreferences entity exists
- ✅ NotificationPreferencesService exists
- ✅ Preferences are synced to Firebase
- ✅ Task updates group toggle works
- ✅ Mentions group toggle works
- ✅ Workspace changes group toggle works
- ✅ DND mode works
- ✅ Quiet hours configuration works
- ✅ Push service checks preferences
- ✅ Preferences are workspace-scoped
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing preferences
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants
- **Push Notification Service**: Required for preference checking (from Notification Main Flow tasks)
- **AuthController**: Required for getting current user
- **StorageService**: Required for local storage fallback

---

## Notes

1. **Existing UI**: `NotificationSettingsPage` exists but needs to be updated with required features.

2. **Workspace Scoping**: Preferences should be per workspace, as users can be in multiple workspaces.

3. **Default Values**: New users should have all groups enabled by default, DND disabled, no quiet hours.

4. **Preference Checking**: Push service must check preferences before sending to respect user choices.

5. **Quiet Hours**: Quiet hours can span midnight (e.g., 22:00 to 08:00) or be within same day (e.g., 14:00 to 16:00).

6. **DND Override**: DND mode should override all group settings - if DND is enabled, no notifications are sent.

7. **Quiet Hours Override**: Quiet hours should override all group settings during quiet hours period.

---

## Related Documentation

- `NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `NOTIFICATION_SUBSCRIPTION_MANAGEMENT_TEST_CASES.md` - Test cases for this feature
- `NOTIFICATION_MAIN_FLOW_TASKS.md` - Related push notification tasks
- `docs/v1/feature_checklists/notifications/notifications.md` - Notification requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

