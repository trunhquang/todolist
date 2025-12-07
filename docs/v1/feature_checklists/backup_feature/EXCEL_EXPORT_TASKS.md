# Excel Export for Tasks/Projects (Hidden if Not Enabled) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Excel Export for Tasks/Projects** feature (export Excel list of tasks/projects, hidden if not enabled). Currently, this feature is **MISSING** - Not implemented; no export pipeline or toggle.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists but `exportDataToOneDrive()` is empty
- ✅ `BackupService.exportReportsToOneDrive()` exists (for reports, JSON format)
- ✅ `OneDriveService` exists for cloud storage
- ✅ `path_provider` package is in pubspec.yaml

### What's Missing/Broken:
- ⛔ No Excel export service
- ⛔ No feature toggle system
- ⛔ No export UI for tasks/projects
- ⛔ No Excel package in pubspec.yaml
- ⛔ No permission checks for export
- ⛔ No filtering/field selection for export

---

## Task List

### Task 1: Add Excel Package to pubspec.yaml

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Excel package required for Excel file generation.

**Files to Modify**:
- `pubspec.yaml`

**Implementation Steps**:
1. Add Excel package:
   ```yaml
   dependencies:
     # ... existing packages ...
     excel: ^2.1.0  # For Excel export
     share_plus: ^7.2.1  # For file sharing
   ```

2. Run `flutter pub get`

3. Verify packages are installed

**Expected Results**:
- ✅ Excel package is added
- ✅ Share plus package is added
- ✅ Packages are installed

**Test Criteria**:
- Run `flutter pub get`
- Verify no errors
- Verify packages are available

---

### Task 2: Create Feature Toggle Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent feature toggles for enabling/disabling features.

**Files to Create**:
- `lib/features/workspace/domain/entities/feature_toggle.dart` (new file)

**Implementation Steps**:
1. Create `FeatureToggle` entity:
   ```dart
   class FeatureToggle {
     final String workspaceId;
     final String featureKey; // e.g., 'excel_export'
     final bool enabled;
     final DateTime updatedAt;
     final String updatedBy;
     
     const FeatureToggle({
       required this.workspaceId,
       required this.featureKey,
       required this.enabled,
       required this.updatedAt,
       required this.updatedBy,
     });
     
     factory FeatureToggle.fromMap(Map<String, dynamic> map) {
       return FeatureToggle(
         workspaceId: map['workspaceId'] ?? '',
         featureKey: map['featureKey'] ?? '',
         enabled: map['enabled'] ?? false,
         updatedAt: DateTime.fromMillisecondsSinceEpoch(
           map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
         ),
         updatedBy: map['updatedBy'] ?? '',
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'workspaceId': workspaceId,
         'featureKey': featureKey,
         'enabled': enabled,
         'updatedAt': updatedAt.millisecondsSinceEpoch,
         'updatedBy': updatedBy,
       };
     }
     
     FeatureToggle copyWith({
       String? workspaceId,
       String? featureKey,
       bool? enabled,
       DateTime? updatedAt,
       String? updatedBy,
     }) {
       return FeatureToggle(
         workspaceId: workspaceId ?? this.workspaceId,
         featureKey: featureKey ?? this.featureKey,
         enabled: enabled ?? this.enabled,
         updatedAt: updatedAt ?? this.updatedAt,
         updatedBy: updatedBy ?? this.updatedBy,
       );
     }
   }
   ```

2. Add feature key constants:
   ```dart
   class FeatureKeys {
     static const String excelExport = 'excel_export';
     // Add other feature keys as needed
   }
   ```

**Expected Results**:
- ✅ FeatureToggle entity exists
- ✅ Entity can be serialized/deserialized
- ✅ Feature keys are defined

**Test Criteria**:
- Unit test: Test entity creation
- Unit test: Test serialization/deserialization

---

### Task 3: Create FeatureToggleService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for managing feature toggles.

**Files to Create**:
- `lib/core/services/feature_toggle_service.dart` (new file)

**Implementation Steps**:
1. Create `FeatureToggleService`:
   ```dart
   class FeatureToggleService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     /// Check if feature is enabled for workspace
     Future<bool> isFeatureEnabled({
       required String workspaceId,
       required String featureKey,
     }) async {
       try {
         final toggle = await _databaseService.getFeatureToggle(
           workspaceId: workspaceId,
           featureKey: featureKey,
         );
         
         // Default to disabled if toggle doesn't exist
         return toggle?.enabled ?? false;
       } catch (e) {
         Get.log('Failed to check feature toggle: $e');
         return false; // Default to disabled on error
       }
     }
     
     /// Enable/disable feature
     Future<void> setFeatureEnabled({
       required String workspaceId,
       required String featureKey,
       required bool enabled,
       required String userId,
     }) async {
       try {
         final toggle = FeatureToggle(
           workspaceId: workspaceId,
           featureKey: featureKey,
           enabled: enabled,
           updatedAt: DateTime.now(),
           updatedBy: userId,
         );
         
         await _databaseService.saveFeatureToggle(toggle);
       } catch (e) {
         Get.log('Failed to set feature toggle: $e');
         rethrow;
       }
     }
     
     /// Get feature toggle
     Future<FeatureToggle?> getFeatureToggle({
       required String workspaceId,
       required String featureKey,
     }) async {
       try {
         return await _databaseService.getFeatureToggle(
           workspaceId: workspaceId,
           featureKey: featureKey,
         );
       } catch (e) {
         Get.log('Failed to get feature toggle: $e');
         return null;
       }
     }
   }
   ```

**Expected Results**:
- ✅ FeatureToggleService exists
- ✅ Service can check feature status
- ✅ Service can enable/disable features

**Test Criteria**:
- Unit test: Test service methods
- Test: Test with Firebase

---

### Task 4: Add Feature Toggle Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for feature toggle operations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add feature toggle methods:
   ```dart
   /// Get feature toggle
   Future<FeatureToggle?> getFeatureToggle({
     required String workspaceId,
     required String featureKey,
   }) async {
     try {
       final ref = _database.ref('workspaces/$workspaceId/feature_toggles/$featureKey');
       final snapshot = await ref.get();
       
       if (!snapshot.exists) return null;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return null;
       
       return FeatureToggle.fromMap(
         Map<String, dynamic>.from(data),
       );
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get feature toggle: $e');
     }
   }
   
   /// Save feature toggle
   Future<void> saveFeatureToggle(FeatureToggle toggle) async {
     try {
       final ref = _database.ref(
         'workspaces/${toggle.workspaceId}/feature_toggles/${toggle.featureKey}',
       );
       await ref.set(toggle.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to save feature toggle: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Database methods exist
- ✅ Methods work correctly

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 5: Create ExcelExportService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for exporting tasks and projects to Excel format.

**Files to Create**:
- `lib/core/services/excel_export_service.dart` (new file)

**Implementation Steps**:
1. Create `ExcelExportService`:
   ```dart
   import 'package:excel/excel.dart';
   import 'package:path_provider/path_provider.dart';
   import 'dart:io';
   
   class ExcelExportService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     
     /// Export tasks to Excel
     Future<String> exportTasksToExcel({
       required String workspaceId,
       List<TaskEntity>? tasks,
       DateTime? fromDate,
       DateTime? toDate,
       List<String>? selectedFields,
       Map<String, dynamic>? metadata,
     }) async {
       try {
         // Get tasks if not provided
         if (tasks == null) {
           tasks = await _databaseService.listTasks(workspaceId: workspaceId);
         }
         
         // Apply filters
         if (fromDate != null || toDate != null) {
           tasks = _filterByDateRange(tasks, fromDate, toDate);
         }
         
         // Create Excel file
         final excel = Excel.createExcel();
         excel.delete('Sheet1'); // Delete default sheet
         final sheet = excel['Tasks'];
         
         // Add metadata sheet
         if (metadata != null) {
           final metadataSheet = excel['Metadata'];
           _addMetadata(metadataSheet, metadata);
         }
         
         // Add headers
         final headers = selectedFields ?? _getDefaultTaskFields();
         _addHeaders(sheet, headers);
         
         // Add data rows
         for (final task in tasks) {
           _addTaskRow(sheet, task, headers);
         }
         
         // Save file
         final filePath = await _saveExcelFile(excel, 'tasks_export');
         return filePath;
       } catch (e) {
         Get.log('Failed to export tasks to Excel: $e');
         rethrow;
       }
     }
     
     /// Export projects to Excel
     Future<String> exportProjectsToExcel({
       required String workspaceId,
       List<ProjectEntity>? projects,
       DateTime? fromDate,
       DateTime? toDate,
       List<String>? selectedFields,
       Map<String, dynamic>? metadata,
     }) async {
       try {
         // Get projects if not provided
         if (projects == null) {
           projects = await _databaseService.listProjects(workspaceId: workspaceId);
         }
         
         // Apply filters
         if (fromDate != null || toDate != null) {
           projects = _filterProjectsByDateRange(projects, fromDate, toDate);
         }
         
         // Create Excel file
         final excel = Excel.createExcel();
         excel.delete('Sheet1');
         final sheet = excel['Projects'];
         
         // Add metadata sheet
         if (metadata != null) {
           final metadataSheet = excel['Metadata'];
           _addMetadata(metadataSheet, metadata);
         }
         
         // Add headers
         final headers = selectedFields ?? _getDefaultProjectFields();
         _addHeaders(sheet, headers);
         
         // Add data rows
         for (final project in projects) {
           _addProjectRow(sheet, project, headers);
         }
         
         // Save file
         final filePath = await _saveExcelFile(excel, 'projects_export');
         return filePath;
       } catch (e) {
         Get.log('Failed to export projects to Excel: $e');
         rethrow;
       }
     }
     
     List<String> _getDefaultTaskFields() {
       return [
         'ID',
         'Title',
         'Description',
         'Status',
         'Priority',
         'Type',
         'Assignee',
         'Created Date',
         'Due Date',
         'Project',
       ];
     }
     
     List<String> _getDefaultProjectFields() {
       return [
         'ID',
         'Name',
         'Description',
         'Status',
         'Start Date',
         'End Date',
         'Progress',
         'Team Members',
         'Created Date',
       ];
     }
     
     void _addHeaders(Sheet sheet, List<String> headers) {
       for (var i = 0; i < headers.length; i++) {
         final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
         cell.value = TextCellValue(headers[i]);
         cell.cellStyle = CellStyle(
           bold: true,
           backgroundColorHex: '#E0E0E0',
         );
       }
     }
     
     void _addTaskRow(Sheet sheet, TaskEntity task, List<String> fields) {
       final rowIndex = sheet.maxRows;
       var colIndex = 0;
       
       for (final field in fields) {
         final cell = sheet.cell(CellIndex.indexByColumnRow(
           columnIndex: colIndex,
           rowIndex: rowIndex,
         ));
         
         switch (field.toLowerCase()) {
           case 'id':
             cell.value = TextCellValue(task.id);
             break;
           case 'title':
             cell.value = TextCellValue(task.title);
             break;
           case 'description':
             cell.value = TextCellValue(task.description ?? '');
             break;
           case 'status':
             cell.value = TextCellValue(task.status.value);
             break;
           case 'priority':
             cell.value = TextCellValue(task.priority.value);
             break;
           case 'type':
             cell.value = TextCellValue(task.type.value);
             break;
           case 'assignee':
             cell.value = TextCellValue(task.assignee ?? '');
             break;
           case 'created date':
             cell.value = TextCellValue(task.createdAt.toIso8601String());
             break;
           case 'due date':
             cell.value = TextCellValue(task.deadline?.toIso8601String() ?? '');
             break;
           case 'project':
             cell.value = TextCellValue(task.projectId ?? '');
             break;
         }
         
         colIndex++;
       }
     }
     
     void _addProjectRow(Sheet sheet, ProjectEntity project, List<String> fields) {
       // Similar implementation for projects
     }
     
     void _addMetadata(Sheet sheet, Map<String, dynamic> metadata) {
       var rowIndex = 0;
       for (final entry in metadata.entries) {
         final keyCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
         keyCell.value = TextCellValue(entry.key);
         keyCell.cellStyle = CellStyle(bold: true);
         
         final valueCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
         valueCell.value = TextCellValue(entry.value.toString());
         
         rowIndex++;
       }
     }
     
     List<TaskEntity> _filterByDateRange(
       List<TaskEntity> tasks,
       DateTime? fromDate,
       DateTime? toDate,
     ) {
       return tasks.where((task) {
         if (fromDate != null && task.createdAt.isBefore(fromDate)) {
           return false;
         }
         if (toDate != null && task.createdAt.isAfter(toDate)) {
           return false;
         }
         return true;
       }).toList();
     }
     
     Future<String> _saveExcelFile(Excel excel, String fileName) async {
       final directory = await getApplicationDocumentsDirectory();
       final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
       final filePath = '${directory.path}/${fileName}_$timestamp.xlsx';
       
       final bytes = excel.save();
       if (bytes == null) {
         throw Exception('Failed to save Excel file');
       }
       
       final file = File(filePath);
       await file.writeAsBytes(bytes);
       
       return filePath;
     }
   }
   ```

**Expected Results**:
- ✅ ExcelExportService exists
- ✅ Service can export tasks to Excel
- ✅ Service can export projects to Excel
- ✅ Service supports filtering and field selection

**Test Criteria**:
- Unit test: Test export service
- Test: Test Excel file generation
- Test: Test file can be opened in Excel

---

### Task 6: Add Excel Export UI to Task List Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Excel export button to task list page (hidden if feature toggle is disabled).

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- Task list controller

**Implementation Steps**:
1. Inject services:
   ```dart
   final FeatureToggleService _featureToggleService = Get.find<FeatureToggleService>();
   final ExcelExportService _excelExportService = Get.find<ExcelExportService>();
   final AccessControlService _accessControlService = Get.find<AccessControlService>();
   ```

2. Add observable for feature toggle:
   ```dart
   final RxBool excelExportEnabled = false.obs;
   
   @override
   void onInit() {
     super.onInit();
     _checkExcelExportFeature();
   }
   
   Future<void> _checkExcelExportFeature() async {
     final workspaceId = _storageService.getWorkspaceId();
     if (workspaceId == null) return;
     
     final enabled = await _featureToggleService.isFeatureEnabled(
       workspaceId: workspaceId,
       featureKey: FeatureKeys.excelExport,
     );
     
     excelExportEnabled.value = enabled;
   }
   ```

3. Add export button (only visible if enabled and user has permission):
   ```dart
   Obx(() {
     if (!excelExportEnabled.value) {
       return const SizedBox.shrink(); // Hidden if toggle is disabled
     }
     
     // Check permission
     final hasPermission = _accessControlService.hasPermission(
       WorkspacePermissions.exportData,
     );
     
     if (!hasPermission) {
       return const SizedBox.shrink(); // Hidden if no permission
     }
     
     return IconButton(
       icon: const Icon(Icons.file_download),
       onPressed: _showExportDialog,
       tooltip: AppStrings.exportToExcel,
     );
   })
   ```

4. Add export dialog:
   ```dart
   Future<void> _showExportDialog() async {
     await Get.dialog(ExportTasksDialog(
       onExport: _exportTasksToExcel,
     ));
   }
   
   Future<void> _exportTasksToExcel({
     DateTime? fromDate,
     DateTime? toDate,
     List<String>? selectedFields,
   }) async {
     try {
       isLoading.value = true;
       
       final workspaceId = _storageService.getWorkspaceId();
       if (workspaceId == null) return;
       
       final metadata = {
         'exportedAt': DateTime.now().toIso8601String(),
         'workspaceId': workspaceId,
         'exportedBy': _authController.currentUser?.id ?? '',
         'totalTasks': tasks.length,
       };
       
       final filePath = await _excelExportService.exportTasksToExcel(
         workspaceId: workspaceId,
         tasks: tasks,
         fromDate: fromDate,
         toDate: toDate,
         selectedFields: selectedFields,
         metadata: metadata,
       );
       
       // Share file
       await _shareFile(filePath);
       
       SnackbarService().showSuccess(
         title: AppStrings.success,
         message: AppStrings.tasksExportedSuccessfully,
       );
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.failedToExportTasks,
       );
     } finally {
       isLoading.value = false;
     }
   }
   ```

5. Use AppStrings for all text

**Expected Results**:
- ✅ Export button is visible when toggle is enabled
- ✅ Export button is hidden when toggle is disabled
- ✅ Permission is checked
- ✅ Export dialog works
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: Button is hidden when toggle is disabled
- Test: Button is visible when toggle is enabled
- Test: Permission check works
- Test: Export works

---

### Task 7: Add Excel Export UI to Project List Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Excel export button to project list page (hidden if feature toggle is disabled).

**Files to Modify**:
- `lib/app/pages/projects/project_list_page.dart`
- Project list controller

**Implementation Steps**:
1. Similar to Task 6, but for projects:
   - Inject services
   - Check feature toggle
   - Add export button (hidden if disabled)
   - Add export dialog
   - Implement export method

2. Use AppStrings for all text

**Expected Results**:
- ✅ Export button is visible when toggle is enabled
- ✅ Export button is hidden when toggle is disabled
- ✅ Permission is checked
- ✅ Export dialog works
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: Button is hidden when toggle is disabled
- Test: Button is visible when toggle is enabled
- Test: Permission check works
- Test: Export works

---

### Task 8: Create Export Dialog Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create reusable dialog widget for export configuration.

**Files to Create**:
- `lib/app/widgets/export_dialog.dart` (new file)

**Implementation Steps**:
1. Create `ExportDialog` widget:
   ```dart
   class ExportDialog extends StatelessWidget {
     final Function({
       DateTime? fromDate,
       DateTime? toDate,
       List<String>? selectedFields,
     }) onExport;
     final List<String> availableFields;
     final String title;
     
     const ExportDialog({
       super.key,
       required this.onExport,
       required this.availableFields,
       required this.title,
     });
     
     @override
     Widget build(BuildContext context) {
       return TDDialog(
         title: title,
         content: _buildContent(),
         actions: [
           TDButton(
             text: AppStrings.cancel,
             onPressed: () => NavigationService().back<void>(),
             variant: TDButtonVariant.outlined,
           ),
           TDButton(
             text: AppStrings.export,
             onPressed: _handleExport,
           ),
         ],
       );
     }
     
     Widget _buildContent() {
       return Column(
         children: [
           // Date range picker
           _buildDateRangePicker(),
           const SizedBox(height: 16),
           // Field selection
           _buildFieldSelection(),
         ],
       );
     }
     
     Widget _buildDateRangePicker() {
       // Date range picker UI
     }
     
     Widget _buildFieldSelection() {
       // Field selection checkboxes
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ ExportDialog widget exists
- ✅ Dialog is reusable
- ✅ UI uses TD widgets and AppStrings

**Test Criteria**:
- Widget test: Test dialog display
- Test: Test dialog functionality

---

### Task 9: Add Feature Toggle UI to Workspace Settings

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add UI for enabling/disabling Excel export feature toggle in workspace settings.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`

**Implementation Steps**:
1. Inject `FeatureToggleService`:
   ```dart
   final FeatureToggleService _featureToggleService = Get.find<FeatureToggleService>();
   ```

2. Add toggle UI:
   ```dart
   // Feature Toggles Section
   _buildSection(
     title: AppStrings.featureToggles,
     children: [
       Obx(() => _buildSwitchSetting(
         title: AppStrings.excelExport,
         subtitle: AppStrings.enableExcelExportDescription,
         value: _excelExportEnabled.value,
         onChanged: (value) async {
           final workspaceId = _storageService.getWorkspaceId();
           final userId = _authController.currentUser?.id;
           
           if (workspaceId != null && userId != null) {
             await _featureToggleService.setFeatureEnabled(
               workspaceId: workspaceId,
               featureKey: FeatureKeys.excelExport,
               enabled: value,
               userId: userId,
             );
             _excelExportEnabled.value = value;
           }
         },
       )),
     ],
   ),
   ```

3. Load toggle state on init

4. Use AppStrings for all text

**Expected Results**:
- ✅ Feature toggle UI exists
- ✅ Toggle can be enabled/disabled
- ✅ Toggle state persists
- ✅ UI uses AppStrings

**Test Criteria**:
- Test: Toggle can be enabled/disabled
- Test: Toggle state persists
- Test: Only Admin/Account Holder can change toggle

---

### Task 10: Add Permission Check for Excel Export

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission check to ensure only Account Holder/Admin can export.

**Files to Modify**:
- `lib/core/services/access_control_service.dart`
- Export UI components

**Implementation Steps**:
1. Add permission constant:
   ```dart
   class WorkspacePermissions {
     // ... existing permissions ...
     static const String exportData = 'export_data';
   }
   ```

2. Add permission check method:
   ```dart
   Future<bool> canExportData() async {
     final userId = _storageService.getUserId();
     final workspaceId = _storageService.getWorkspaceId();
     
     if (userId == null || workspaceId == null) return false;
     
     final userRole = await _getUserRole(workspaceId);
     
     // Only Account Holder and Admin can export
     return userRole == WorkspaceRole.accountHolder ||
            userRole == WorkspaceRole.admin;
   }
   ```

3. Use permission check in export UI

**Expected Results**:
- ✅ Permission check exists
- ✅ Only Account Holder/Admin can export
- ✅ Permission is enforced

**Test Criteria**:
- Test: Permission check works
- Test: Unauthorized users cannot export

---

### Task 11: Add File Sharing Functionality

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add functionality to share exported Excel files.

**Files to Modify**:
- `lib/core/services/excel_export_service.dart`

**Implementation Steps**:
1. Add share method:
   ```dart
   import 'package:share_plus/share_plus.dart';
   
   Future<void> shareFile(String filePath) async {
     try {
       final file = File(filePath);
       if (!await file.exists()) {
         throw Exception('File does not exist');
       }
       
       await Share.shareXFiles(
         [XFile(filePath)],
         text: AppStrings.shareExcelFile,
       );
     } catch (e) {
       Get.log('Failed to share file: $e');
       rethrow;
     }
   }
   ```

2. Integrate with export methods

**Expected Results**:
- ✅ File sharing works
- ✅ Multiple share methods are available

**Test Criteria**:
- Test: File can be shared
- Test: Share methods work

---

### Task 12: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for Excel export feature.

**Files to Create**:
- `test/core/services/excel_export_service_test.dart`
- `test/core/services/feature_toggle_service_test.dart`
- `test/features/workspace/domain/entities/feature_toggle_test.dart`

**Expected Results**:
- ✅ Unit tests cover Excel export
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Excel Package to pubspec.yaml (Critical - Dependency)
2. **Task 2**: Create Feature Toggle Entity (Critical - Foundation)
3. **Task 3**: Create FeatureToggleService (Critical - Core Logic)
4. **Task 4**: Add Feature Toggle Methods to FirebaseDatabaseService (Critical - Data Layer)
5. **Task 5**: Create ExcelExportService (High Priority - Core Logic)
6. **Task 6**: Add Excel Export UI to Task List Page (High Priority - UI)
7. **Task 7**: Add Excel Export UI to Project List Page (High Priority - UI)
8. **Task 8**: Create Export Dialog Widget (High Priority - UI Component)
9. **Task 10**: Add Permission Check for Excel Export (High Priority - Security)
10. **Task 9**: Add Feature Toggle UI to Workspace Settings (Medium Priority - UI)
11. **Task 11**: Add File Sharing Functionality (Medium Priority - Feature)
12. **Task 12**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Excel package is added
- ✅ Feature toggle system exists
- ✅ Excel export service exists
- ✅ Export UI is added to task/project pages
- ✅ Export is hidden when toggle is disabled
- ✅ Export is visible when toggle is enabled
- ✅ Permission checks work
- ✅ Export works correctly
- ✅ File sharing works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing feature toggles
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants
- **Excel Package**: Required for Excel export (`excel` package)
- **Share Plus**: Required for file sharing (`share_plus` package)
- **Path Provider**: Already in pubspec.yaml

---

## Notes

1. **Feature Toggle**: Excel export should be hidden when toggle is disabled. This allows workspace admins to control feature availability.

2. **Permission**: Only Account Holder and Admin should be able to export. This is critical for data security.

3. **Workspace Scoping**: Feature toggle should be per workspace, allowing different workspaces to have different settings.

4. **Default State**: Feature toggle should default to disabled for new workspaces.

5. **Export Formats**: Currently focusing on Excel, but can be extended to support CSV, PDF later.

6. **Large Datasets**: Consider pagination or streaming for large exports to avoid memory issues.

7. **Metadata**: Include metadata in exports for audit/compliance purposes.

---

## Related Documentation

- `BACKUP_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `EXCEL_EXPORT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/backup_feature/backup.md` - Backup requirements (if exists)
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
