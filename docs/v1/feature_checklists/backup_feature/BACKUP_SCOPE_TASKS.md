# Backup Scope: Tasks, Projects, Workspace Settings, Members - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Backup Scope** feature. Currently, this feature is **MISSING** - Not implemented; no data selection or packaging logic for tasks, projects, workspace settings, and members.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists with `exportDataToOneDrive()` method (but empty)
- ✅ `OneDriveService` exists with `backupAppData()` method
- ✅ `BackupController` exists with UI state management
- ✅ Data models exist: `TaskEntity`, `Project`, `Workspace`, `WorkspaceMember`, `WorkspaceSettings`
- ✅ Data services exist: `FirebaseDatabaseService`, `WorkspaceRepository`
- ✅ `exportReportsToOneDrive()` method exists as reference implementation

### What's Missing/Broken:
- ⛔ `exportDataToOneDrive()` method is empty (not implemented)
- ⛔ No data selection logic for tasks, projects, workspace settings, members
- ⛔ No data packaging logic to create backup JSON structure
- ⛔ No sensitive data exclusion (tokens, deviceId)
- ⛔ No backup scope selection UI (checkboxes/toggles)
- ⛔ No backup file format validation
- ⛔ No progress tracking for large backups

---

## Task List

### Task 1: Implement Data Selection Logic for Tasks

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Implement logic to fetch and select tasks from the current workspace for backup, excluding sensitive data.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- `FirebaseDatabaseService.listTasks()`
- `StorageService.getWorkspaceId()`

**Implementation Steps**:

1. **Add method to fetch tasks for backup**:
   ```dart
   /// Get tasks for backup (excluding sensitive data)
   Future<List<Map<String, dynamic>>> _getTasksForBackup(String workspaceId) async {
     try {
       // Get all tasks for the workspace
       final tasks = await _db.listTasks(workspaceId: workspaceId);
       
       // Convert to backup format (exclude sensitive data)
       return tasks.map((task) => _taskToBackupMap(task)).toList();
     } catch (e) {
       Get.log('Failed to get tasks for backup: $e');
       return [];
     }
   }
   ```

2. **Add method to convert task to backup map (exclude sensitive data)**:
   ```dart
   /// Convert task entity to backup map (exclude sensitive data)
   Map<String, dynamic> _taskToBackupMap(TaskEntity task) {
     return {
       'id': task.id,
       'title': task.title,
       'description': task.description,
       'workspaceId': task.workspaceId,
       'taskType': task.taskType,
       'priority': task.priority,
       'status': task.status,
       'assignee': task.assignee,
       'assigner': task.assigner,
       'projectId': task.projectId,
       'hasDeadline': task.hasDeadline,
       'deadline': task.deadline?.toIso8601String(),
       'parentTaskId': task.parentTaskId,
       'stoppedByProjectClose': task.stoppedByProjectClose,
       'recurring': {
         'isRecurring': task.recurring.isRecurring,
         'frequency': task.recurring.frequency,
         'interval': task.recurring.interval,
         'endDate': task.recurring.endDate?.toIso8601String(),
         'daysOfWeek': task.recurring.daysOfWeek,
         'dayOfMonth': task.recurring.dayOfMonth,
       },
       'createdAt': task.createdAt.toIso8601String(),
       'updatedAt': task.updatedAt?.toIso8601String(),
       // Explicitly exclude: tokens, deviceId, and any sensitive fields
     };
   }
   ```

3. **Add error handling**:
   - Handle cases where workspace has no tasks
   - Handle cases where task data is corrupted
   - Log errors but don't fail entire backup

**Expected Results**:
- ✅ Tasks are fetched from Firebase for current workspace
- ✅ Tasks are converted to backup format
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Method returns list of task maps ready for backup

**Testing**:
- Test with workspace containing 0 tasks
- Test with workspace containing multiple tasks
- Test with tasks having different properties (deadline, recurring, projectId)
- Verify sensitive data is excluded

---

### Task 2: Implement Data Selection Logic for Projects

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Implement logic to fetch and select projects from the current workspace for backup, excluding sensitive data.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- `FirebaseDatabaseService.listProjects()`
- `StorageService.getWorkspaceId()`

**Implementation Steps**:

1. **Add method to fetch projects for backup**:
   ```dart
   /// Get projects for backup (excluding sensitive data)
   Future<List<Map<String, dynamic>>> _getProjectsForBackup(String workspaceId) async {
     try {
       // Get all projects for the workspace
       final projects = await _db.listProjects(workspaceId: workspaceId);
       
       // Convert to backup format (exclude sensitive data)
       return projects.map((project) => _projectToBackupMap(project)).toList();
     } catch (e) {
       Get.log('Failed to get projects for backup: $e');
       return [];
     }
   }
   ```

2. **Add method to convert project to backup map (exclude sensitive data)**:
   ```dart
   /// Convert project entity to backup map (exclude sensitive data)
   Map<String, dynamic> _projectToBackupMap(Project project) {
     return {
       'id': project.id,
       'title': project.title,
       'description': project.description,
       'workspaceId': project.workspaceId,
       'status': project.status,
       'deadline': project.deadline?.toIso8601String(),
       'createdBy': project.createdBy,
       'createdAt': project.createdAt.toIso8601String(),
       // Explicitly exclude: tokens, deviceId, and any sensitive fields
       // Note: deletedAt is excluded as we only backup active projects
     };
   }
   ```

3. **Add error handling**:
   - Handle cases where workspace has no projects
   - Handle cases where project data is corrupted
   - Log errors but don't fail entire backup

**Expected Results**:
- ✅ Projects are fetched from Firebase for current workspace
- ✅ Projects are converted to backup format
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Method returns list of project maps ready for backup

**Testing**:
- Test with workspace containing 0 projects
- Test with workspace containing multiple projects
- Test with projects having different properties (deadline, description)
- Verify sensitive data is excluded

---

### Task 3: Implement Data Selection Logic for Workspace Settings

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Implement logic to fetch and select workspace settings from the current workspace for backup, excluding sensitive data.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- `WorkspaceRepository.getWorkspace()`
- `StorageService.getWorkspaceId()`

**Implementation Steps**:

1. **Add method to fetch workspace and settings for backup**:
   ```dart
   /// Get workspace and settings for backup (excluding sensitive data)
   Future<Map<String, dynamic>> _getWorkspaceForBackup(String workspaceId) async {
     try {
       // Get workspace repository
       final workspaceRepo = Get.find<WorkspaceRepository>();
       
       // Get workspace
       final result = await workspaceRepo.getWorkspace(workspaceId);
       
       return result.fold(
         (failure) {
           Get.log('Failed to get workspace for backup: ${failure.message}');
           return {};
         },
         (workspace) => _workspaceToBackupMap(workspace),
       );
     } catch (e) {
       Get.log('Failed to get workspace for backup: $e');
       return {};
     }
   }
   ```

2. **Add method to convert workspace to backup map (exclude sensitive data)**:
   ```dart
   /// Convert workspace entity to backup map (exclude sensitive data)
   Map<String, dynamic> _workspaceToBackupMap(Workspace workspace) {
     return {
       'id': workspace.id,
       'name': workspace.name,
       'type': workspace.type.toString(),
       'description': workspace.description,
       'logoUrl': workspace.logoUrl,
       'createdBy': workspace.createdBy,
       'createdAt': workspace.createdAt.toIso8601String(),
       'updatedAt': workspace.updatedAt?.toIso8601String(),
       'isActive': workspace.isActive,
       'settings': workspace.settings != null
           ? _workspaceSettingsToBackupMap(workspace.settings!)
           : null,
       // Explicitly exclude: tokens, deviceId, and any sensitive fields
     };
   }
   ```

3. **Add method to convert workspace settings to backup map**:
   ```dart
   /// Convert workspace settings to backup map (exclude sensitive data)
   Map<String, dynamic> _workspaceSettingsToBackupMap(Map<String, dynamic> settings) {
     // Create WorkspaceSettings from map to ensure proper structure
     final workspaceSettings = WorkspaceSettings.fromMap(settings);
     
     return {
       'description': workspaceSettings.description,
       'logoUrl': workspaceSettings.logoUrl,
       'timezone': workspaceSettings.timezone,
       'language': workspaceSettings.language,
       'dateFormat': workspaceSettings.dateFormat,
       'timeFormat': workspaceSettings.timeFormat,
       'currency': workspaceSettings.currency,
       'notifications': workspaceSettings.notifications,
       'autoSave': workspaceSettings.autoSave,
       'theme': workspaceSettings.theme,
       'customFields': workspaceSettings.customFields,
       // Explicitly exclude: tokens, deviceId, and any sensitive fields
     };
   }
   ```

4. **Add error handling**:
   - Handle cases where workspace doesn't exist
   - Handle cases where workspace settings are null
   - Log errors but don't fail entire backup

**Expected Results**:
- ✅ Workspace is fetched from repository
- ✅ Workspace and settings are converted to backup format
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Method returns workspace map ready for backup

**Testing**:
- Test with workspace having no settings
- Test with workspace having all settings configured
- Test with workspace having custom fields
- Verify sensitive data is excluded

---

### Task 4: Implement Data Selection Logic for Members (Optional)

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Implement logic to fetch and select workspace members from the current workspace for backup, excluding sensitive data. This should be optional (user can choose to include or exclude members).

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- `WorkspaceRepository.getWorkspaceMembers()`
- `StorageService.getWorkspaceId()`

**Implementation Steps**:

1. **Add method to fetch members for backup**:
   ```dart
   /// Get workspace members for backup (excluding sensitive data)
   Future<List<Map<String, dynamic>>> _getMembersForBackup(String workspaceId) async {
     try {
       // Get workspace repository
       final workspaceRepo = Get.find<WorkspaceRepository>();
       
       // Get workspace members
       final result = await workspaceRepo.getWorkspaceMembers(workspaceId);
       
       return result.fold(
         (failure) {
           Get.log('Failed to get members for backup: ${failure.message}');
           return [];
         },
         (members) => members.map((member) => _memberToBackupMap(member)).toList(),
       );
     } catch (e) {
       Get.log('Failed to get members for backup: $e');
       return [];
     }
   }
   ```

2. **Add method to convert member to backup map (exclude sensitive data)**:
   ```dart
   /// Convert workspace member entity to backup map (exclude sensitive data)
   Map<String, dynamic> _memberToBackupMap(WorkspaceMember member) {
     return {
       'userId': member.userId,
       'workspaceId': member.workspaceId,
       'role': member.role.toString(),
       'name': member.name,
       'email': member.email,
       'permissions': member.permissions.map((p) => p.toString()).toList(),
       'joinedAt': member.joinedAt.toIso8601String(),
       'managerUserId': member.managerUserId,
       // Explicitly exclude: passwords, tokens, deviceId, authentication tokens
       // Only include metadata: name, email, role, permissions
     };
   }
   ```

3. **Add error handling**:
   - Handle cases where workspace has no members
   - Handle cases where member data is corrupted
   - Log errors but don't fail entire backup

**Expected Results**:
- ✅ Members are fetched from repository
- ✅ Members are converted to backup format
- ✅ Sensitive data (passwords, tokens, deviceId) is excluded
- ✅ Only metadata (name, email, role, permissions) is included
- ✅ Method returns list of member maps ready for backup

**Testing**:
- Test with workspace containing 0 members
- Test with workspace containing multiple members
- Test with members having different roles (Account Holder, Admin, Member)
- Verify sensitive data is excluded
- Verify only metadata is included

---

### Task 5: Implement Data Packaging Logic

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Implement logic to package all selected data (tasks, projects, workspace settings, members) into a structured backup JSON format.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Tasks from Task 1
- Projects from Task 2
- Workspace from Task 3
- Members from Task 4 (optional)

**Implementation Steps**:

1. **Add backup scope configuration class**:
   ```dart
   /// Backup scope configuration
   class BackupScope {
     final bool includeTasks;
     final bool includeProjects;
     final bool includeWorkspaceSettings;
     final bool includeMembers;
     
     const BackupScope({
       this.includeTasks = true,
       this.includeProjects = true,
       this.includeWorkspaceSettings = true,
       this.includeMembers = false, // Optional by default
     });
   }
   ```

2. **Update `exportDataToOneDrive()` method**:
   ```dart
   /// Export current user data include workspaces, task, project, assign user ..
   /// to OneDrive as a JSON backup file.
   Future<void> exportDataToOneDrive({
     BackupScope? scope,
   }) async {
     try {
       final userId = _storage.getUserId();
       final workspaceId = _storage.getWorkspaceId();
       
       if (userId == null || workspaceId == null || workspaceId.isEmpty) {
         throw const UnknownFailure(message: 'User or workspace not found');
       }
       
       // Use default scope if not provided
       final backupScope = scope ?? const BackupScope();
       
       // Build backup payload
       final payload = await _buildBackupPayload(
         workspaceId: workspaceId,
         scope: backupScope,
       );
       
       // Upload to OneDrive
       await _oneDrive.backupAppData(payload);
       
       Get.log('Backup completed successfully');
     } catch (e) {
       Get.log('Backup failed: $e');
       rethrow;
     }
   }
   ```

3. **Add method to build backup payload**:
   ```dart
   /// Build backup payload with selected data
   Future<Map<String, dynamic>> _buildBackupPayload({
     required String workspaceId,
     required BackupScope scope,
   }) async {
     final payload = <String, dynamic>{
       'workspaceId': workspaceId,
       'exportedAt': DateTime.now().toIso8601String(),
       'type': 'complete',
       'version': '1.0',
     };
     
     // Add workspace and settings
     if (scope.includeWorkspaceSettings) {
       final workspace = await _getWorkspaceForBackup(workspaceId);
       if (workspace.isNotEmpty) {
         payload['workspace'] = workspace;
       }
     }
     
     // Add tasks
     if (scope.includeTasks) {
       final tasks = await _getTasksForBackup(workspaceId);
       payload['tasks'] = tasks;
     }
     
     // Add projects
     if (scope.includeProjects) {
       final projects = await _getProjectsForBackup(workspaceId);
       payload['projects'] = projects;
     }
     
     // Add members (optional)
     if (scope.includeMembers) {
       final members = await _getMembersForBackup(workspaceId);
       payload['members'] = members;
     }
     
     return payload;
   }
   ```

4. **Add progress tracking (optional)**:
   ```dart
   /// Build backup payload with progress tracking
   Future<Map<String, dynamic>> _buildBackupPayloadWithProgress({
     required String workspaceId,
     required BackupScope scope,
     Function(double)? onProgress,
   }) async {
     double progress = 0.0;
     final totalSteps = [
       scope.includeWorkspaceSettings,
       scope.includeTasks,
       scope.includeProjects,
       scope.includeMembers,
     ].where((e) => e).length;
     
     final stepProgress = 1.0 / (totalSteps + 1); // +1 for final packaging
     
     final payload = <String, dynamic>{
       'workspaceId': workspaceId,
       'exportedAt': DateTime.now().toIso8601String(),
       'type': 'complete',
       'version': '1.0',
     };
     
     // Add workspace and settings
     if (scope.includeWorkspaceSettings) {
       final workspace = await _getWorkspaceForBackup(workspaceId);
       if (workspace.isNotEmpty) {
         payload['workspace'] = workspace;
       }
       progress += stepProgress;
       onProgress?.call(progress);
     }
     
     // Add tasks
     if (scope.includeTasks) {
       final tasks = await _getTasksForBackup(workspaceId);
       payload['tasks'] = tasks;
       progress += stepProgress;
       onProgress?.call(progress);
     }
     
     // Add projects
     if (scope.includeProjects) {
       final projects = await _getProjectsForBackup(workspaceId);
       payload['projects'] = projects;
       progress += stepProgress;
       onProgress?.call(progress);
     }
     
     // Add members (optional)
     if (scope.includeMembers) {
       final members = await _getMembersForBackup(workspaceId);
       payload['members'] = members;
       progress += stepProgress;
       onProgress?.call(progress);
     }
     
     // Final packaging
     progress = 1.0;
     onProgress?.call(progress);
     
     return payload;
   }
   ```

5. **Add error handling**:
   - Handle cases where data fetching fails for one section (continue with other sections)
   - Log errors for each section
   - Ensure backup file is still created even if some sections fail

**Expected Results**:
- ✅ Backup payload is built with selected data
- ✅ Backup file structure follows expected format
- ✅ All selected data is included
- ✅ Unselected data is excluded
- ✅ Progress tracking works (if implemented)

**Testing**:
- Test with all scope options enabled
- Test with partial scope options enabled
- Test with empty workspace
- Test with large workspace
- Verify backup file structure is valid JSON
- Verify progress tracking updates correctly

---

### Task 6: Add Backup Scope Selection UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Add UI components (checkboxes/toggles) to allow users to select which data to include in backup (tasks, projects, workspace settings, members).

**Files to Modify**:
- `lib/core/controllers/backup_controller.dart`
- `lib/app/pages/backup/backup_page.dart` (or wherever backup UI is located)

**Dependencies**:
- `BackupScope` class from Task 5
- `BackupService.exportDataToOneDrive()` with scope parameter

**Implementation Steps**:

1. **Update BackupController to include scope state**:
   ```dart
   // Add scope observables
   final RxBool _includeTasks = true.obs;
   final RxBool _includeProjects = true.obs;
   final RxBool _includeWorkspaceSettings = true.obs;
   final RxBool _includeMembers = false.obs; // Optional by default
   
   // Public getters
   bool get includeTasks => _includeTasks.value;
   bool get includeProjects => _includeProjects.value;
   bool get includeWorkspaceSettings => _includeWorkspaceSettings.value;
   bool get includeMembers => _includeMembers.value;
   
   // Setters
   void setIncludeTasks(bool value) => _includeTasks.value = value;
   void setIncludeProjects(bool value) => _includeProjects.value = value;
   void setIncludeWorkspaceSettings(bool value) => _includeWorkspaceSettings.value = value;
   void setIncludeMembers(bool value) => _includeMembers.value = value;
   ```

2. **Update createBackup method to use scope**:
   ```dart
   /// Create backup to OneDrive
   Future<void> createBackup() async {
     _isBackingUp.value = true;
     _backupProgress.value = 0.0;
     
     try {
       await executeAsync(
         () async {
           // Create backup scope
           final scope = BackupScope(
             includeTasks: _includeTasks.value,
             includeProjects: _includeProjects.value,
             includeWorkspaceSettings: _includeWorkspaceSettings.value,
             includeMembers: _includeMembers.value,
           );
           
           // Update progress callback
           void onProgress(double progress) {
             _backupProgress.value = progress;
           }
           
           // Perform backup with scope
           await _backupService.exportDataToOneDrive(scope: scope);
           
           // Update backup info
           _lastBackupDate.value = DateTime.now();
           await _storageService.setInt('__last_onedrive_backup_ms', DateTime.now().millisecondsSinceEpoch);
           
           // Reload available backups
           await _loadAvailableBackups();
         },
         showLoading: false,
         successMessage: AppStrings.backupComplete,
       );
     } finally {
       _isBackingUp.value = false;
       _backupProgress.value = 0.0;
     }
   }
   ```

3. **Add UI components for scope selection**:
   ```dart
   // In backup_page.dart or backup widget
   Widget _buildBackupScopeSelection() {
     return GetBuilder<BackupController>(
       builder: (controller) => Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             AppStrings.backupScope,
             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 8),
           TDCheckbox(
             title: AppStrings.includeTasks,
             value: controller.includeTasks,
             onChanged: controller.setIncludeTasks,
           ),
           TDCheckbox(
             title: AppStrings.includeProjects,
             value: controller.includeProjects,
             onChanged: controller.setIncludeProjects,
           ),
           TDCheckbox(
             title: AppStrings.includeWorkspaceSettings,
             value: controller.includeWorkspaceSettings,
             onChanged: controller.setIncludeWorkspaceSettings,
           ),
           TDCheckbox(
             title: AppStrings.includeMembers,
             subtitle: AppStrings.includeMembersOptional,
             value: controller.includeMembers,
             onChanged: controller.setIncludeMembers,
           ),
         ],
       ),
     );
   }
   ```

4. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String backupScope = 'Backup Scope';
   static const String includeTasks = 'Include Tasks';
   static const String includeProjects = 'Include Projects';
   static const String includeWorkspaceSettings = 'Include Workspace Settings';
   static const String includeMembers = 'Include Members';
   static const String includeMembersOptional = 'Optional: Include workspace members in backup';
   ```

**Expected Results**:
- ✅ UI displays checkboxes/toggles for backup scope selection
- ✅ Users can select which data to include in backup
- ✅ Default values are set correctly (tasks, projects, settings = true, members = false)
- ✅ Backup uses selected scope when creating backup

**Testing**:
- Test UI displays all scope options
- Test checkboxes/toggles work correctly
- Test backup uses selected scope
- Test default values are correct

---

### Task 7: Add Sensitive Data Exclusion Validation

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add validation to ensure sensitive data (tokens, deviceId, passwords) is excluded from backup data.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- All data conversion methods from Tasks 1-4

**Implementation Steps**:

1. **Add sensitive data exclusion list**:
   ```dart
   /// List of sensitive field names to exclude from backup
   static const List<String> _sensitiveFields = [
     'token',
     'deviceId',
     'device_id',
     'password',
     'authToken',
     'accessToken',
     'refreshToken',
     'apiKey',
     'secret',
     'privateKey',
   ];
   ```

2. **Add method to filter sensitive data from map**:
   ```dart
   /// Filter sensitive data from map recursively
   Map<String, dynamic> _filterSensitiveData(Map<String, dynamic> data) {
     final filtered = <String, dynamic>{};
     
     data.forEach((key, value) {
       // Check if key contains sensitive field name (case-insensitive)
       final isSensitive = _sensitiveFields.any(
         (field) => key.toLowerCase().contains(field.toLowerCase()),
       );
       
       if (isSensitive) {
         // Skip sensitive fields
         return;
       }
       
       // Recursively filter nested maps
       if (value is Map<String, dynamic>) {
         filtered[key] = _filterSensitiveData(value);
       } else if (value is List) {
         // Filter list items if they are maps
         filtered[key] = value.map((item) {
           if (item is Map<String, dynamic>) {
             return _filterSensitiveData(item);
           }
           return item;
         }).toList();
       } else {
         filtered[key] = value;
       }
     });
     
     return filtered;
   }
   ```

3. **Apply filtering to all data conversion methods**:
   ```dart
   /// Convert task entity to backup map (exclude sensitive data)
   Map<String, dynamic> _taskToBackupMap(TaskEntity task) {
     final map = {
       'id': task.id,
       'title': task.title,
       // ... other fields
     };
     
     // Apply sensitive data filtering
     return _filterSensitiveData(map);
   }
   ```

4. **Add validation method**:
   ```dart
   /// Validate backup payload doesn't contain sensitive data
   bool _validateBackupPayload(Map<String, dynamic> payload) {
     final jsonString = jsonEncode(payload);
     
     // Check for sensitive field names in JSON string (case-insensitive)
     for (final field in _sensitiveFields) {
       if (jsonString.toLowerCase().contains(field.toLowerCase())) {
         Get.log('WARNING: Backup payload may contain sensitive data: $field');
         return false;
       }
     }
     
     return true;
   }
   ```

5. **Add validation to backup process**:
   ```dart
   Future<Map<String, dynamic>> _buildBackupPayload({
     required String workspaceId,
     required BackupScope scope,
   }) async {
     // ... build payload as before
     
     // Validate payload before returning
     if (!_validateBackupPayload(payload)) {
       Get.log('WARNING: Backup payload validation failed - sensitive data may be present');
       // Continue anyway, but log warning
     }
     
     return payload;
   }
   ```

**Expected Results**:
- ✅ Sensitive data is excluded from backup
- ✅ Validation detects if sensitive data is present
- ✅ Warnings are logged if sensitive data is detected
- ✅ Backup payload is safe to share or store

**Testing**:
- Test with data containing sensitive field names
- Test validation detects sensitive data
- Test filtering removes sensitive data
- Verify backup file doesn't contain sensitive data

---

### Task 8: Add Backup File Format Validation

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add validation to ensure backup file format is correct and follows expected structure.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Backup payload building from Task 5

**Implementation Steps**:

1. **Add backup format version constant**:
   ```dart
   /// Current backup format version
   static const String _backupFormatVersion = '1.0';
   ```

2. **Add backup format validation**:
   ```dart
   /// Validate backup payload format
   bool _validateBackupFormat(Map<String, dynamic> payload) {
     // Check required top-level fields
     if (!payload.containsKey('workspaceId')) {
       Get.log('ERROR: Backup payload missing workspaceId');
       return false;
     }
     
     if (!payload.containsKey('exportedAt')) {
       Get.log('ERROR: Backup payload missing exportedAt');
       return false;
     }
     
     if (!payload.containsKey('type')) {
       Get.log('ERROR: Backup payload missing type');
       return false;
     }
     
     if (!payload.containsKey('version')) {
       Get.log('ERROR: Backup payload missing version');
       return false;
     }
     
     // Validate exportedAt is valid ISO 8601 string
     try {
       DateTime.parse(payload['exportedAt'] as String);
     } catch (e) {
       Get.log('ERROR: Backup payload exportedAt is invalid: $e');
       return false;
     }
     
     // Validate version matches current version
     if (payload['version'] != _backupFormatVersion) {
       Get.log('WARNING: Backup payload version mismatch: ${payload['version']} vs $_backupFormatVersion');
     }
     
     return true;
   }
   ```

3. **Add JSON validation**:
   ```dart
   /// Validate backup payload is valid JSON
   bool _validateBackupJson(Map<String, dynamic> payload) {
     try {
       // Try to encode to JSON
       final jsonString = jsonEncode(payload);
       
       // Try to decode back
       final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
       
       // Verify structure is preserved
       return decoded.containsKey('workspaceId') &&
              decoded.containsKey('exportedAt') &&
              decoded.containsKey('type') &&
              decoded.containsKey('version');
     } catch (e) {
       Get.log('ERROR: Backup payload is not valid JSON: $e');
       return false;
     }
   }
   ```

4. **Add validation to backup process**:
   ```dart
   Future<Map<String, dynamic>> _buildBackupPayload({
     required String workspaceId,
     required BackupScope scope,
   }) async {
     // ... build payload as before
     
     // Validate format
     if (!_validateBackupFormat(payload)) {
       throw const UnknownFailure(message: 'Backup payload format validation failed');
     }
     
     // Validate JSON
     if (!_validateBackupJson(payload)) {
       throw const UnknownFailure(message: 'Backup payload JSON validation failed');
     }
     
     return payload;
   }
   ```

**Expected Results**:
- ✅ Backup payload format is validated
- ✅ Backup payload is valid JSON
- ✅ Errors are thrown if validation fails
- ✅ Backup file structure is correct

**Testing**:
- Test with valid backup payload
- Test with invalid backup payload (missing fields)
- Test with invalid JSON
- Verify validation catches errors

---

### Task 9: Update BackupController to Support Scope

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1 hour

**Description**:
Update BackupController to support backup scope configuration and pass it to BackupService.

**Files to Modify**:
- `lib/core/controllers/backup_controller.dart`

**Dependencies**:
- `BackupScope` class from Task 5
- `BackupService.exportDataToOneDrive()` with scope parameter

**Implementation Steps**:

1. **Add BackupScope import**:
   ```dart
   import 'package:todolist/core/services/backup_service.dart';
   ```

2. **Add scope observables** (already done in Task 6, but verify):
   ```dart
   // Add scope observables
   final RxBool _includeTasks = true.obs;
   final RxBool _includeProjects = true.obs;
   final RxBool _includeWorkspaceSettings = true.obs;
   final RxBool _includeMembers = false.obs;
   ```

3. **Update createBackup method** (already done in Task 6, but verify):
   ```dart
   /// Create backup to OneDrive
   Future<void> createBackup() async {
     // ... implementation from Task 6
   }
   ```

4. **Add method to get current scope**:
   ```dart
   /// Get current backup scope configuration
   BackupScope getCurrentBackupScope() {
     return BackupScope(
       includeTasks: _includeTasks.value,
       includeProjects: _includeProjects.value,
       includeWorkspaceSettings: _includeWorkspaceSettings.value,
       includeMembers: _includeMembers.value,
     );
   }
   ```

**Expected Results**:
- ✅ BackupController supports backup scope configuration
- ✅ Scope is passed to BackupService
- ✅ Default scope values are correct

**Testing**:
- Test scope configuration is saved
- Test scope is passed to BackupService
- Test default values are correct

---

### Task 10: Add Error Handling and Logging

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add comprehensive error handling and logging for backup scope operations.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/core/controllers/backup_controller.dart`

**Dependencies**:
- All previous tasks

**Implementation Steps**:

1. **Add error handling to data fetching methods**:
   ```dart
   Future<List<Map<String, dynamic>>> _getTasksForBackup(String workspaceId) async {
     try {
       final tasks = await _db.listTasks(workspaceId: workspaceId);
       return tasks.map((task) => _taskToBackupMap(task)).toList();
     } on DatabaseFailure catch (e) {
       Get.log('ERROR: Failed to get tasks for backup: ${e.message}');
       return [];
     } catch (e) {
       Get.log('ERROR: Unexpected error getting tasks for backup: $e');
       return [];
     }
   }
   ```

2. **Add error handling to backup process**:
   ```dart
   Future<void> exportDataToOneDrive({
     BackupScope? scope,
   }) async {
     try {
       // ... existing code
     } on UnknownFailure catch (e) {
       Get.log('ERROR: Backup failed: ${e.message}');
       rethrow;
     } on OneDriveException catch (e) {
       Get.log('ERROR: OneDrive upload failed: ${e.message}');
       rethrow;
     } catch (e) {
       Get.log('ERROR: Unexpected backup error: $e');
       throw UnknownFailure(message: 'Backup failed: $e');
     }
   }
   ```

3. **Add logging for backup progress**:
   ```dart
   Future<Map<String, dynamic>> _buildBackupPayload({
     required String workspaceId,
     required BackupScope scope,
   }) async {
     Get.log('INFO: Starting backup for workspace: $workspaceId');
     Get.log('INFO: Backup scope - Tasks: ${scope.includeTasks}, Projects: ${scope.includeProjects}, Settings: ${scope.includeWorkspaceSettings}, Members: ${scope.includeMembers}');
     
     // ... build payload
     
     Get.log('INFO: Backup payload built successfully');
     return payload;
   }
   ```

4. **Add error handling to BackupController**:
   ```dart
   Future<void> createBackup() async {
     _isBackingUp.value = true;
     _backupProgress.value = 0.0;
     
     try {
       await executeAsync(
         () async {
           // ... backup logic
         },
         showLoading: false,
         successMessage: AppStrings.backupComplete,
       );
     } on UnknownFailure catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: e.message,
       );
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.backupFailed,
       );
     } finally {
       _isBackingUp.value = false;
       _backupProgress.value = 0.0;
     }
   }
   ```

**Expected Results**:
- ✅ Errors are handled gracefully
- ✅ Logging provides useful information
- ✅ Users see appropriate error messages
- ✅ Backup process doesn't crash on errors

**Testing**:
- Test with network errors
- Test with invalid data
- Test with missing permissions
- Verify error messages are displayed
- Verify logging works correctly

---

## Summary

### Implementation Order:
1. **Task 1**: Implement data selection for tasks
2. **Task 2**: Implement data selection for projects
3. **Task 3**: Implement data selection for workspace settings
4. **Task 4**: Implement data selection for members (optional)
5. **Task 5**: Implement data packaging logic
6. **Task 7**: Add sensitive data exclusion validation
7. **Task 8**: Add backup file format validation
8. **Task 6**: Add backup scope selection UI
9. **Task 9**: Update BackupController to support scope
10. **Task 10**: Add error handling and logging

### Estimated Total Time: 15-20 hours

### Dependencies:
- All tasks depend on existing services and repositories
- Task 5 depends on Tasks 1-4
- Task 6 depends on Task 5
- Task 9 depends on Tasks 5 and 6
- Task 10 can be done in parallel with other tasks

### Testing Requirements:
- Unit tests for each data conversion method
- Unit tests for backup payload building
- Unit tests for sensitive data exclusion
- Unit tests for format validation
- Integration tests for complete backup flow
- Manual testing with various workspace sizes

### Success Criteria:
- ✅ All data types (tasks, projects, workspace settings, members) can be backed up
- ✅ Sensitive data is excluded from backup
- ✅ Backup file format is valid JSON
- ✅ Users can select which data to include
- ✅ Backup works for empty and large workspaces
- ✅ Error handling is comprehensive
- ✅ Logging provides useful information

