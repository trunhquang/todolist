# Security & Audit (Audit Log, Notifications, Confirmations) - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **Security & Audit** feature (audit log for role/avatar/email changes, notifications when adding/removing from workspace/team, confirmation when demoting/removing user). Currently, this feature is **MISSING** - no audit log system, no notification hooks for add/remove/role changes, and no confirmation flows for demotion/removal.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `WorkspaceAnalytics` - analytics tracking (different from audit log)
- ✅ Some confirmation dialogs for removing users (may be partial)
- ✅ `SnackbarService` - for in-app notifications (but not for user management events)

### What's Missing/Broken:
- ⛔ No audit log system for role/avatar/email changes
- ⛔ No notification hooks for add/remove/role changes
- ⛔ No confirmation flows for demotion (role downgrade)
- ⛔ No audit log viewing/export functionality
- ⛔ No notification preferences management

---

## Task List

### Task 1: Create Audit Log Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent audit log entries for tracking all security-relevant changes.

**Files to Create**:
- `lib/features/audit/domain/entities/audit_log_entry.dart` (new file)

**Implementation Steps**:
1. Create `AuditLogEntry` entity:
   ```dart
   class AuditLogEntry {
     final String id;
     final String action; // 'role_changed', 'avatar_changed', 'email_changed', 'user_added', 'user_removed', etc.
     final String userId; // User who was affected
     final String changedBy; // User who made the change
     final String workspaceId; // Workspace context (if applicable)
     final String? teamId; // Team context (if applicable)
     final Map<String, dynamic>? oldValues; // Old values (e.g., old role)
     final Map<String, dynamic>? newValues; // New values (e.g., new role)
     final String? reason; // Reason for change (if provided)
     final String? ipAddress; // IP address (if available)
     final String? deviceInfo; // Device information (if available)
     final DateTime timestamp;
     final Map<String, dynamic>? metadata; // Additional metadata
     
     const AuditLogEntry({
       required this.id,
       required this.action,
       required this.userId,
       required this.changedBy,
       required this.workspaceId,
       this.teamId,
       this.oldValues,
       this.newValues,
       this.reason,
       this.ipAddress,
       this.deviceInfo,
       required this.timestamp,
       this.metadata,
     });
     
     factory AuditLogEntry.fromMap(Map<String, dynamic> map) {
       return AuditLogEntry(
         id: map['id'] as String,
         action: map['action'] as String,
         userId: map['userId'] as String,
         changedBy: map['changedBy'] as String,
         workspaceId: map['workspaceId'] as String,
         teamId: map['teamId'] as String?,
         oldValues: map['oldValues'] != null
             ? Map<String, dynamic>.from(map['oldValues'] as Map)
             : null,
         newValues: map['newValues'] != null
             ? Map<String, dynamic>.from(map['newValues'] as Map)
             : null,
         reason: map['reason'] as String?,
         ipAddress: map['ipAddress'] as String?,
         deviceInfo: map['deviceInfo'] as String?,
         timestamp: DateTime.fromMillisecondsSinceEpoch(
           map['timestamp'] as int,
         ),
         metadata: map['metadata'] != null
             ? Map<String, dynamic>.from(map['metadata'] as Map)
             : null,
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'id': id,
         'action': action,
         'userId': userId,
         'changedBy': changedBy,
         'workspaceId': workspaceId,
         'teamId': teamId,
         'oldValues': oldValues,
         'newValues': newValues,
         'reason': reason,
         'ipAddress': ipAddress,
         'deviceInfo': deviceInfo,
         'timestamp': timestamp.millisecondsSinceEpoch,
         'metadata': metadata,
       };
     }
   }
   ```

2. Add action constants:
   ```dart
   class AuditLogActions {
     static const String roleChanged = 'role_changed';
     static const String avatarChanged = 'avatar_changed';
     static const String emailChanged = 'email_changed';
     static const String userAdded = 'user_added';
     static const String userRemoved = 'user_removed';
     static const String userAddedToTeam = 'user_added_to_team';
     static const String userRemovedFromTeam = 'user_removed_from_team';
     static const String accountLocked = 'account_locked';
     static const String accountUnlocked = 'account_unlocked';
   }
   ```

3. Add helper methods:
   - `copyWith` method
   - `isValid` method
   - `getDisplayName` method

**Expected Results**:
- ✅ AuditLogEntry entity exists
- ✅ Entity supports all required fields
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation and serialization
- Test: Verify all fields are included

---

### Task 2: Create Audit Log Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to log audit events for all security-relevant operations.

**Files to Create**:
- `lib/core/services/audit_log_service.dart` (new file)

**Implementation Steps**:
1. Create `AuditLogService`:
   ```dart
   class AuditLogService {
     final AuditLogRepository _repository;
     final DeviceInfoService _deviceInfoService;
     
     factory AuditLogService() => _instance ??= AuditLogService._();
     AuditLogService._();
     static AuditLogService? _instance;
     
     /// Log role change
     Future<void> logRoleChange({
       required String userId,
       required String changedBy,
       required String workspaceId,
       required String oldRole,
       required String newRole,
       String? reason,
     }) async {
       await _log(
         action: AuditLogActions.roleChanged,
         userId: userId,
         changedBy: changedBy,
         workspaceId: workspaceId,
         oldValues: {'role': oldRole},
         newValues: {'role': newRole},
         reason: reason,
       );
     }
     
     /// Log avatar change
     Future<void> logAvatarChange({
       required String userId,
       required String changedBy,
       required String workspaceId,
       String? oldAvatarUrl,
       String? newAvatarUrl,
     }) async {
       await _log(
         action: AuditLogActions.avatarChanged,
         userId: userId,
         changedBy: changedBy,
         workspaceId: workspaceId,
         oldValues: oldAvatarUrl != null ? {'avatarUrl': oldAvatarUrl} : null,
         newValues: newAvatarUrl != null ? {'avatarUrl': newAvatarUrl} : null,
       );
     }
     
     /// Log email change
     Future<void> logEmailChange({
       required String userId,
       required String changedBy,
       required String workspaceId,
       required String oldEmail,
       required String newEmail,
     }) async {
       await _log(
         action: AuditLogActions.emailChanged,
         userId: userId,
         changedBy: changedBy,
         workspaceId: workspaceId,
         oldValues: {'email': oldEmail},
         newValues: {'email': newEmail},
       );
     }
     
     /// Log user added to workspace
     Future<void> logUserAdded({
       required String userId,
       required String addedBy,
       required String workspaceId,
       required String role,
     }) async {
       await _log(
         action: AuditLogActions.userAdded,
         userId: userId,
         changedBy: addedBy,
         workspaceId: workspaceId,
         newValues: {'role': role},
       );
     }
     
     /// Log user removed from workspace
     Future<void> logUserRemoved({
       required String userId,
       required String removedBy,
       required String workspaceId,
       String? reason,
     }) async {
       await _log(
         action: AuditLogActions.userRemoved,
         userId: userId,
         changedBy: removedBy,
         workspaceId: workspaceId,
         reason: reason,
       );
     }
     
     /// Log user added to team
     Future<void> logUserAddedToTeam({
       required String userId,
       required String addedBy,
       required String workspaceId,
       required String teamId,
     }) async {
       await _log(
         action: AuditLogActions.userAddedToTeam,
         userId: userId,
         changedBy: addedBy,
         workspaceId: workspaceId,
         teamId: teamId,
       );
     }
     
     /// Log user removed from team
     Future<void> logUserRemovedFromTeam({
       required String userId,
       required String removedBy,
       required String workspaceId,
       required String teamId,
       String? reason,
     }) async {
       await _log(
         action: AuditLogActions.userRemovedFromTeam,
         userId: userId,
         changedBy: removedBy,
         workspaceId: workspaceId,
         teamId: teamId,
         reason: reason,
       );
     }
     
     /// Internal log method
     Future<void> _log({
       required String action,
       required String userId,
       required String changedBy,
       required String workspaceId,
       String? teamId,
       Map<String, dynamic>? oldValues,
       Map<String, dynamic>? newValues,
       String? reason,
     }) async {
       try {
         // Get device info
         final deviceInfo = await _deviceInfoService.getDeviceInfo();
         
         // Create audit log entry
         final entry = AuditLogEntry(
           id: _generateId(),
           action: action,
           userId: userId,
           changedBy: changedBy,
           workspaceId: workspaceId,
           teamId: teamId,
           oldValues: oldValues,
           newValues: newValues,
           reason: reason,
           ipAddress: await _getIpAddress(), // If available
           deviceInfo: deviceInfo,
           timestamp: DateTime.now(),
         );
         
         // Save to repository
         await _repository.createAuditLogEntry(entry);
       } catch (e) {
         // Log error but don't fail the operation
         print('Failed to log audit entry: $e');
       }
     }
     
     String _generateId() {
       return DateTime.now().millisecondsSinceEpoch.toString();
     }
     
     Future<String?> _getIpAddress() async {
       // Get IP address if available
       // This may require additional package
       return null;
     }
   }
   ```

2. Add error handling:
   - Don't fail operations if audit logging fails
   - Log audit logging errors separately

**Expected Results**:
- ✅ AuditLogService exists
- ✅ All security-relevant operations are logged
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test logging different actions
- Test: Verify logs are created in Firebase
- Test: Verify errors don't fail operations

---

### Task 3: Create Audit Log Repository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository for managing audit log entries.

**Files to Create**:
- `lib/features/audit/domain/repositories/audit_log_repository.dart` (new file)
- `lib/features/audit/data/repositories/audit_log_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create repository interface:
   ```dart
   abstract class AuditLogRepository {
     Future<Either<Failure, AuditLogEntry>> createAuditLogEntry(
       AuditLogEntry entry,
     );
     
     Future<Either<Failure, List<AuditLogEntry>>> getAuditLogs({
       required String workspaceId,
       String? userId,
       String? action,
       DateTime? startDate,
       DateTime? endDate,
       int? limit,
     });
     
     Future<Either<Failure, AuditLogEntry?>> getAuditLogEntry(String id);
   }
   ```

2. Implement repository:
   - Use FirebaseDatabaseService for data operations
   - Store audit logs in `audit_logs/{workspaceId}/{entryId}`
   - Implement filtering and pagination
   - Handle errors appropriately

**Expected Results**:
- ✅ Repository exists
- ✅ All CRUD operations work
- ✅ Filtering and pagination work

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 4: Integrate Audit Logging with Role Changes

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate audit logging with role change operations.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Update `updateUserRole` method:
   ```dart
   Future<void> updateUserRole(String userId, String newRoleDisplay) async {
     // Get current role
     final existing = _workspaceMembers.firstWhereOrNull((m) => m.userId == userId);
     final oldRole = existing?.role.value ?? 'member';
     
     // ... existing role update code ...
     
     // Log audit entry
     await AuditLogService().logRoleChange(
       userId: userId,
       changedBy: _userId,
       workspaceId: workspaceId,
       oldRole: oldRole,
       newRole: role.value,
     );
   }
   ```

2. Add audit logging to all role change operations

**Expected Results**:
- ✅ Role changes are logged
- ✅ Audit logs include old and new roles

**Test Criteria**:
- Test: Change role, verify audit log is created
- Test: Verify audit log contains correct information

---

### Task 5: Integrate Audit Logging with Profile Changes

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate audit logging with avatar and email changes.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Update `updateUserProfile` method:
   ```dart
   Future<void> updateUserProfile({
     String? name,
     String? profileImageUrl,
     // ... other fields ...
   }) async {
     // Get current values
     final currentUser = _currentUser.value;
     final oldAvatarUrl = currentUser?.profileImageUrl;
     
     // ... existing update code ...
     
     // Log avatar change if changed
     if (profileImageUrl != null && profileImageUrl != oldAvatarUrl) {
       await AuditLogService().logAvatarChange(
         userId: currentUser!.id,
         changedBy: currentUser.id, // Self-change
         workspaceId: _getCurrentWorkspaceId(),
         oldAvatarUrl: oldAvatarUrl,
         newAvatarUrl: profileImageUrl,
       );
     }
   }
   ```

2. Add email change logging (when email change is implemented)

**Expected Results**:
- ✅ Avatar changes are logged
- ✅ Email changes are logged (when implemented)

**Test Criteria**:
- Test: Change avatar, verify audit log is created
- Test: Verify audit log contains correct information

---

### Task 6: Integrate Audit Logging with User Add/Remove

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate audit logging with user add/remove operations.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Update `inviteUserToWorkspace` method:
   ```dart
   Future<void> inviteUserToWorkspace() async {
     // ... existing invitation code ...
     
     // Log audit entry when user accepts invitation
     // (or log invitation sent)
   }
   ```

2. Update `removeUserFromWorkspace` method:
   ```dart
   Future<void> removeUserFromWorkspace(String userId) async {
     // ... existing removal code ...
     
     // Log audit entry
     await AuditLogService().logUserRemoved(
       userId: userId,
       removedBy: _userId,
       workspaceId: _workspaceId,
       reason: _removalReason, // If provided
     );
   }
   ```

3. Add audit logging to team add/remove operations (when implemented)

**Expected Results**:
- ✅ User additions are logged
- ✅ User removals are logged
- ✅ Team additions/removals are logged (when implemented)

**Test Criteria**:
- Test: Add user, verify audit log is created
- Test: Remove user, verify audit log is created

---

### Task 7: Create Notification Service Hooks

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create notification service hooks to send notifications for user management events.

**Files to Create**:
- `lib/core/services/user_management_notification_service.dart` (new file)

**Implementation Steps**:
1. Create `UserManagementNotificationService`:
   ```dart
   class UserManagementNotificationService {
     final NotificationService _notificationService;
     final EmailService _emailService; // If email service exists
     
     /// Send notification when user is added to workspace
     Future<void> notifyUserAdded({
       required String userId,
       required String workspaceId,
       required String role,
       required String addedBy,
     }) async {
       // Get user preferences
       final preferences = await _getNotificationPreferences(userId);
       
       if (preferences.userAddedToWorkspace) {
         // Send push notification
         await _notificationService.sendPushNotification(
           userId: userId,
           title: AppStrings.I.addedToWorkspace,
           body: AppStrings.I.addedToWorkspaceMessage(workspaceName, role),
           data: {
             'type': 'user_added',
             'workspaceId': workspaceId,
             'role': role,
           },
         );
         
         // Send email notification (if enabled)
         if (preferences.emailNotifications) {
           await _emailService.sendEmail(
             to: userEmail,
             subject: AppStrings.I.addedToWorkspace,
             body: AppStrings.I.addedToWorkspaceEmailBody(workspaceName, role),
           );
         }
       }
     }
     
     /// Send notification when user is removed from workspace
     Future<void> notifyUserRemoved({
       required String userId,
       required String workspaceId,
       required String removedBy,
       String? reason,
     }) async {
       // Similar implementation
     }
     
     /// Send notification when role is changed
     Future<void> notifyRoleChanged({
       required String userId,
       required String workspaceId,
       required String oldRole,
       required String newRole,
       required String changedBy,
     }) async {
       // Similar implementation
     }
     
     /// Send notification when user is added to team
     Future<void> notifyUserAddedToTeam({
       required String userId,
       required String teamId,
       required String workspaceId,
       required String addedBy,
     }) async {
       // Similar implementation
     }
     
     /// Send notification when user is removed from team
     Future<void> notifyUserRemovedFromTeam({
       required String userId,
       required String teamId,
       required String workspaceId,
       required String removedBy,
       String? reason,
     }) async {
       // Similar implementation
     }
   }
   ```

2. Integrate with existing notification services

**Expected Results**:
- ✅ Notification service hooks exist
- ✅ Notifications are sent for all user management events
- ✅ Notification preferences are respected

**Test Criteria**:
- Test: Add user, verify notification is sent
- Test: Change role, verify notification is sent
- Test: Verify preferences are respected

---

### Task 8: Integrate Notifications with User Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate notification service with user add/remove/role change operations.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Update `updateUserRole` method:
   ```dart
   Future<void> updateUserRole(String userId, String newRoleDisplay) async {
     // ... existing code ...
     
     // Send notification
     await UserManagementNotificationService().notifyRoleChanged(
       userId: userId,
       workspaceId: workspaceId,
       oldRole: oldRole,
       newRole: role.value,
       changedBy: _userId,
     );
   }
   ```

2. Update `removeUserFromWorkspace` method:
   ```dart
   Future<void> removeUserFromWorkspace(String userId) async {
     // ... existing code ...
     
     // Send notification
     await UserManagementNotificationService().notifyUserRemoved(
       userId: userId,
       workspaceId: workspaceId,
       removedBy: _userId,
       reason: _removalReason,
     );
   }
   ```

3. Add notifications to all user management operations

**Expected Results**:
- ✅ Notifications are sent for all operations
- ✅ Notifications are sent immediately

**Test Criteria**:
- Test: Perform operations, verify notifications are sent
- Test: Verify notification content is correct

---

### Task 9: Create Confirmation Dialog for Demotion

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create confirmation dialog for role demotion with warning about permission loss.

**Files to Create**:
- `lib/app/pages/users/widgets/demote_user_dialog.dart` (new file)

**Implementation Steps**:
1. Create `DemoteUserDialog`:
   ```dart
   class DemoteUserDialog extends StatelessWidget {
     final WorkspaceMember member;
     final WorkspaceRole newRole;
     
     @override
     Widget build(BuildContext context) {
       return AlertDialog(
         title: Text(AppStrings.demoteUser),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(AppStrings.demoteUserConfirmation(member.displayName)),
             SizedBox(height: 16),
             Text(AppStrings.currentRole(member.role.displayName)),
             Text(AppStrings.newRole(newRole.displayName)),
             SizedBox(height: 16),
             TDCard(
               type: TDCardType.warning,
               child: Text(AppStrings.demoteUserWarning),
             ),
             SizedBox(height: 16),
             Text(AppStrings.demoteUserPermissionLoss),
           ],
         ),
         actions: [
           TDButton(
             label: AppStrings.I.cancel,
             onPressed: () => NavigationService().back<void>(),
           ),
           TDButton(
             label: AppStrings.I.confirm,
             type: TDButtonType.danger,
             onPressed: _handleDemote,
           ),
         ],
       );
     }
   }
   ```

2. Add AppStrings for demotion messages

3. Integrate with role change flow

**Expected Results**:
- ✅ Demotion confirmation dialog exists
- ✅ Dialog warns about permission loss
- ✅ Dialog is clear and informative

**Test Criteria**:
- Manual test: Demote user, verify dialog appears
- Test: Verify dialog content is correct

---

### Task 10: Enhance Confirmation Dialog for User Removal

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Enhance existing confirmation dialog for user removal with more details and reason field.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`

**Implementation Steps**:
1. Update `_showRemoveUserDialog`:
   ```dart
   Future<void> _showRemoveUserDialog(...) async {
     final reasonController = TextEditingController();
     
     final confirmed = await showDialog<bool>(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(AppStrings.removeUser),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(AppStrings.removeUserConfirmation(member.displayName)),
             SizedBox(height: 16),
             TDTextField(
               controller: reasonController,
               label: AppStrings.I.reasonForRemoval,
               hint: AppStrings.I.reasonForRemovalHint,
               maxLines: 3,
             ),
           ],
         ),
         actions: [
           TDButton(
             label: AppStrings.I.cancel,
             onPressed: () => Navigator.of(context).pop(false),
           ),
           TDButton(
             label: AppStrings.I.remove,
             type: TDButtonType.danger,
             onPressed: () => Navigator.of(context).pop(true),
           ),
         ],
       ),
     );
     
     if (confirmed ?? false) {
       await controller.removeUserFromWorkspace(
         member.userId,
         reason: reasonController.text,
       );
     }
   }
   ```

2. Update `removeUserFromWorkspace` to accept reason parameter

**Expected Results**:
- ✅ Enhanced confirmation dialog exists
- ✅ Reason field is included
- ✅ Dialog is more informative

**Test Criteria**:
- Manual test: Remove user, verify enhanced dialog appears
- Test: Verify reason is saved

---

### Task 11: Create Audit Log Viewing UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to view audit logs with filtering and search.

**Files to Create**:
- `lib/app/pages/audit/audit_log_page.dart` (new file)
- `lib/app/pages/audit/controllers/audit_log_controller.dart` (new file)

**Implementation Steps**:
1. Create `AuditLogController`:
   ```dart
   class AuditLogController extends GetxController {
     final AuditLogRepository _repository;
     
     final RxList<AuditLogEntry> _auditLogs = <AuditLogEntry>[].obs;
     final RxBool _isLoading = false.obs;
     final RxString _errorMessage = ''.obs;
     
     // Filters
     final Rx<String?> _selectedAction = Rx<String?>(null);
     final Rx<String?> _selectedUser = Rx<String?>(null);
     final Rx<DateTime?> _startDate = Rx<DateTime?>(null);
     final Rx<DateTime?> _endDate = Rx<DateTime?>(null);
     
     List<AuditLogEntry> get auditLogs => _auditLogs;
     bool get isLoading => _isLoading.value;
     
     Future<void> loadAuditLogs() async {
       _isLoading.value = true;
       try {
         final result = await _repository.getAuditLogs(
           workspaceId: _workspaceId,
           action: _selectedAction.value,
           userId: _selectedUser.value,
           startDate: _startDate.value,
           endDate: _endDate.value,
         );
         result.fold(
           (failure) => _errorMessage.value = failure.message,
           (logs) => _auditLogs.value = logs,
         );
       } finally {
         _isLoading.value = false;
       }
     }
   }
   ```

2. Create `AuditLogPage`:
   - Display audit log list
   - Add filters (action, user, date range)
   - Add search functionality
   - Add pagination
   - Use TD widgets and AppStrings

**Expected Results**:
- ✅ Audit log viewing UI exists
- ✅ Filters and search work
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View audit logs
- Test: Verify filters work
- Test: Verify search works

---

### Task 12: Create Audit Log Export Functionality

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create functionality to export audit logs for compliance purposes.

**Files to Create**:
- `lib/core/services/audit_log_export_service.dart` (new file)

**Implementation Steps**:
1. Create `AuditLogExportService`:
   ```dart
   class AuditLogExportService {
     /// Export audit logs to CSV
     Future<String> exportToCSV({
       required List<AuditLogEntry> entries,
     }) async {
       // Generate CSV content
       // Return file path
     }
     
     /// Export audit logs to PDF
     Future<String> exportToPDF({
       required List<AuditLogEntry> entries,
     }) async {
       // Generate PDF content
       // Return file path
     }
     
     /// Export audit logs to JSON
     Future<String> exportToJSON({
       required List<AuditLogEntry> entries,
     }) async {
       // Generate JSON content
       // Return file path
     }
   }
   ```

2. Add export button to Audit Log page

3. Use packages like `csv`, `pdf`, `path_provider`

**Expected Results**:
- ✅ Audit logs can be exported
- ✅ Multiple formats are supported
- ✅ Exported data is accurate

**Test Criteria**:
- Test: Export to CSV, verify file is generated
- Test: Export to PDF, verify file is generated
- Test: Verify exported data is correct

---

### Task 13: Create Notification Preferences UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for users to manage notification preferences.

**Files to Create**:
- `lib/app/pages/settings/notification_preferences_page.dart` (new file)
- `lib/app/pages/settings/controllers/notification_preferences_controller.dart` (new file)

**Implementation Steps**:
1. Create `NotificationPreferences` entity:
   ```dart
   class NotificationPreferences {
     final bool emailNotifications;
     final bool pushNotifications;
     final bool inAppNotifications;
     final bool userAddedToWorkspace;
     final bool userRemovedFromWorkspace;
     final bool roleChanged;
     final bool userAddedToTeam;
     final bool userRemovedFromTeam;
     // ... other preferences
   }
   ```

2. Create `NotificationPreferencesController`:
   - Load preferences
   - Save preferences
   - Update preferences

3. Create `NotificationPreferencesPage`:
   - Display preference toggles
   - Save preferences
   - Use TD widgets and AppStrings

**Expected Results**:
- ✅ Notification preferences UI exists
- ✅ Preferences can be saved
- ✅ Preferences are respected

**Test Criteria**:
- Manual test: Change preferences, verify they are saved
- Test: Verify preferences are respected

---

### Task 14: Add Unit Tests for Security & Audit

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for security and audit functionality.

**Files to Create**:
- `test/core/services/audit_log_service_test.dart`
- `test/core/services/user_management_notification_service_test.dart`
- `test/features/audit/domain/entities/audit_log_entry_test.dart`

**Implementation Steps**:
1. Test `AuditLogService`:
   - Test logging different actions
   - Test error handling
   - Test device info capture

2. Test `UserManagementNotificationService`:
   - Test sending notifications
   - Test preference handling
   - Test different notification types

3. Test `AuditLogEntry`:
   - Test entity creation
   - Test serialization
   - Test validation

**Expected Results**:
- ✅ Unit tests cover security and audit functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Audit Log Entity (Critical - Foundation)
2. **Task 2**: Create Audit Log Service (Critical - Core Feature)
3. **Task 3**: Create Audit Log Repository (Critical - Data Layer)
4. **Task 4**: Integrate Audit Logging with Role Changes (High Priority - Integration)
5. **Task 5**: Integrate Audit Logging with Profile Changes (High Priority - Integration)
6. **Task 6**: Integrate Audit Logging with User Add/Remove (High Priority - Integration)
7. **Task 7**: Create Notification Service Hooks (High Priority - Core Feature)
8. **Task 8**: Integrate Notifications with User Operations (High Priority - Integration)
9. **Task 9**: Create Confirmation Dialog for Demotion (High Priority - UX)
10. **Task 10**: Enhance Confirmation Dialog for User Removal (Medium Priority - UX)
11. **Task 11**: Create Audit Log Viewing UI (Medium Priority - UI)
12. **Task 12**: Create Audit Log Export Functionality (Low Priority - Feature Enhancement)
13. **Task 13**: Create Notification Preferences UI (Medium Priority - UX)
14. **Task 14**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Audit log system exists and logs all security-relevant changes
- ✅ Notifications are sent for all user management events
- ✅ Confirmation dialogs appear for demotion and removal
- ✅ Audit logs can be viewed and filtered
- ✅ Audit logs can be exported for compliance
- ✅ Notification preferences can be managed
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **AuditLogRepository**: Required for storing audit logs
- **NotificationService**: Required for sending notifications
- **EmailService**: Required for email notifications (if implemented)
- **DeviceInfoService**: Required for capturing device information
- **Firebase Realtime Database**: Required for storing audit logs
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Audit Log vs Analytics**: `WorkspaceAnalytics` exists for analytics tracking, but audit logs are for compliance and security. They should be separate systems.

2. **Immutability**: Audit logs should be immutable (cannot be edited or deleted) for compliance purposes.

3. **Performance**: Audit logging should not block operations. If audit logging fails, the operation should still succeed.

4. **Privacy**: Audit logs may contain sensitive information. Need to ensure proper access control.

5. **Compliance**: Audit logs are important for compliance (GDPR, SOC 2, etc.). Need to ensure all sensitive operations are logged.

6. **Notification Preferences**: Users should be able to control which notifications they receive. Default should be to send all notifications.

7. **Confirmation Dialogs**: Should be clear and informative, especially for destructive operations like demotion and removal.

8. **Export Formats**: CSV and PDF are most common for compliance. JSON may be useful for programmatic access.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `SECURITY_AUDIT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/GOVERNANCE_SAFETY_TASKS.md` - Related governance tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

