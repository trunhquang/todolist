# Task Export/Import Subset (Backup Linkage) - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **Task Export/Import Subset (Backup Linkage)** feature. Currently, this feature is **MISSING** - Not implemented; no export/import flow.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists (but `exportDataToOneDrive()` is empty)
- ✅ `BackupService.exportReportsToOneDrive()` works for reports
- ✅ `OneDriveService` has `backupAppData()` and `restoreAppData()` methods
- ✅ `BackupController` exists
- ✅ `path_provider` package is in pubspec.yaml

### What's Missing:
- ⛔ No task export service
- ⛔ No task import service
- ⛔ No export formats (JSON, Excel, CSV)
- ⛔ No export UI
- ⛔ No import UI
- ⛔ No export/import use cases
- ⛔ No validation for import
- ⛔ No conflict resolution
- ⛔ No permission checks
- ⛔ Excel/CSV packages not in pubspec.yaml

---

## Task List

### Task 1: Add Required Packages to pubspec.yaml

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add packages required for Excel, CSV export and file sharing.

**Files to Modify**:
- `pubspec.yaml`

**Implementation Steps**:
1. Add packages:
   ```yaml
   dependencies:
     # ... existing packages ...
     excel: ^2.1.0  # For Excel export
     csv: ^6.0.0    # For CSV export
     share_plus: ^7.2.1  # For file sharing
     # pdf: ^3.10.0  # Optional: For PDF export
   ```

2. Run `flutter pub get`

3. Verify packages are installed

**Expected Results**:
- ✅ Excel package is added
- ✅ CSV package is added
- ✅ Share plus package is added
- ✅ Packages are installed

**Test Criteria**:
- Run `flutter pub get`
- Verify no errors
- Verify packages are available

---

### Task 2: Create Task Export Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for exporting tasks to different formats.

**Files to Create**:
- `lib/core/services/task_export_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskExportService`:
   ```dart
   class TaskExportService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     /// Export tasks to JSON
     Future<String> exportToJSON({
       required String workspaceId,
       TaskFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       final tasks = await _getFilteredTasks(
         workspaceId: workspaceId,
         filter: filter,
         fromDate: fromDate,
         toDate: toDate,
       );
       
       final exportData = {
         'workspaceId': workspaceId,
         'exportedAt': DateTime.now().toIso8601String(),
         'exportedBy': _getCurrentUserId(),
         'type': 'tasks',
         'version': '1.0',
         'taskCount': tasks.length,
         'tasks': tasks.map((task) => task.toMap()).toList(),
       };
       
       return jsonEncode(exportData);
     }
     
     /// Export tasks to Excel
     Future<Uint8List> exportToExcel({
       required String workspaceId,
       TaskFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       final tasks = await _getFilteredTasks(
         workspaceId: workspaceId,
         filter: filter,
         fromDate: fromDate,
         toDate: toDate,
       );
       
       final excel = Excel.createExcel();
       final sheet = excel['Tasks'];
       
       // Add headers
       sheet.appendRow([
         'ID', 'Title', 'Description', 'Status', 'Priority', 'Type',
         'Assignee', 'Assigner', 'Project ID', 'Deadline', 'Created At', 'Updated At'
       ]);
       
       // Add data rows
       for (final task in tasks) {
         sheet.appendRow([
           task.id,
           task.title,
           task.description ?? '',
           task.status,
           task.priority,
           task.taskType,
           task.assignee ?? '',
           task.assigner,
           task.projectId ?? '',
           task.deadline?.toIso8601String() ?? '',
           task.createdAt.toIso8601String(),
           task.updatedAt?.toIso8601String() ?? '',
         ]);
       }
       
       return excel.encode()!;
     }
     
     /// Export tasks to CSV
     Future<String> exportToCSV({
       required String workspaceId,
       TaskFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       final tasks = await _getFilteredTasks(
         workspaceId: workspaceId,
         filter: filter,
         fromDate: fromDate,
         toDate: toDate,
       );
       
       final buffer = StringBuffer();
       
       // Add metadata
       buffer.writeln('Export Date,${DateTime.now().toIso8601String()}');
       buffer.writeln('Exported By,${_getCurrentUserId()}');
       buffer.writeln('Workspace,$workspaceId');
       buffer.writeln('Task Count,${tasks.length}');
       buffer.writeln('');
       
       // Add headers
       buffer.writeln('ID,Title,Description,Status,Priority,Type,Assignee,Assigner,Project ID,Deadline,Created At,Updated At');
       
       // Add data rows
       for (final task in tasks) {
         final row = [
           task.id,
           _escapeCsvField(task.title),
           _escapeCsvField(task.description ?? ''),
           task.status,
           task.priority,
           task.taskType,
           task.assignee ?? '',
           task.assigner,
           task.projectId ?? '',
           task.deadline?.toIso8601String() ?? '',
           task.createdAt.toIso8601String(),
           task.updatedAt?.toIso8601String() ?? '',
         ];
         buffer.writeln(row.join(','));
       }
       
       return buffer.toString();
     }
     
     /// Get filtered tasks
     Future<List<TaskEntity>> _getFilteredTasks({
       required String workspaceId,
       TaskFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Get all tasks for workspace
       final allTasks = await _databaseService.listTasks(workspaceId: workspaceId);
       
       // Apply filters
       var filteredTasks = allTasks;
       
       if (filter != null) {
         // Apply status filter
         if (filter.status != null) {
           filteredTasks = filteredTasks.where((t) => t.status == filter.status!.value).toList();
         }
         // Apply priority filter
         if (filter.priority != null) {
           filteredTasks = filteredTasks.where((t) => t.priority == filter.priority!.value).toList();
         }
         // Apply project filter
         if (filter.projectId != null) {
           filteredTasks = filteredTasks.where((t) => t.projectId == filter.projectId).toList();
         }
         // Apply assignee filter
         if (filter.assigneeId != null) {
           filteredTasks = filteredTasks.where((t) => t.assignee == filter.assigneeId).toList();
         }
       }
       
       // Apply date range filter
       if (fromDate != null || toDate != null) {
         filteredTasks = filteredTasks.where((task) {
           if (fromDate != null && task.createdAt.isBefore(fromDate)) return false;
           if (toDate != null && task.createdAt.isAfter(toDate)) return false;
           return true;
         }).toList();
       }
       
       return filteredTasks;
     }
     
     String _escapeCsvField(String field) {
       // Escape quotes and wrap in quotes if contains comma
       if (field.contains(',') || field.contains('"')) {
         return '"${field.replaceAll('"', '""')}"';
       }
       return field;
     }
   }
   ```

**Expected Results**:
- ✅ Task export service exists
- ✅ JSON export works
- ✅ Excel export works
- ✅ CSV export works
- ✅ Filtering works

**Test Criteria**:
- Unit test: Test export to different formats
- Test: Verify exported files are generated correctly
- Test: Verify filtering works

---

### Task 3: Create Task Import Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for importing tasks from different formats.

**Files to Create**:
- `lib/core/services/task_import_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskImportService`:
   ```dart
   class TaskImportService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final OfflineQueueService _offlineQueueService = Get.find<OfflineQueueService>();
     
     /// Import tasks from JSON
     Future<TaskImportResult> importFromJSON({
       required String workspaceId,
       required String jsonString,
       required ConflictResolutionStrategy strategy,
     }) async {
       try {
         final data = jsonDecode(jsonString) as Map<String, dynamic>;
         
         // Validate export format
         if (data['type'] != 'tasks') {
           return TaskImportResult(
             isSuccess: false,
             error: 'Invalid export format',
             importedCount: 0,
             skippedCount: 0,
             errorCount: 0,
           );
         }
         
         final tasksData = data['tasks'] as List<dynamic>;
         final tasks = tasksData.map((t) => TaskEntity.fromMap(t as Map<dynamic, dynamic>)).toList();
         
         return await _importTasks(
           workspaceId: workspaceId,
           tasks: tasks,
           strategy: strategy,
         );
       } catch (e) {
         return TaskImportResult(
           isSuccess: false,
           error: 'Failed to parse JSON: $e',
           importedCount: 0,
           skippedCount: 0,
           errorCount: 0,
         );
       }
     }
     
     /// Import tasks from Excel
     Future<TaskImportResult> importFromExcel({
       required String workspaceId,
       required Uint8List excelData,
       required ConflictResolutionStrategy strategy,
     }) async {
       try {
         final excel = Excel.decodeBytes(excelData);
         final sheet = excel['Tasks'] ?? excel.tables.keys.first;
         
         final tasks = <TaskEntity>[];
         
         // Skip header row
         for (var i = 1; i < sheet.rows.length; i++) {
           final row = sheet.rows[i];
           try {
             final task = _parseTaskFromExcelRow(row);
             if (task != null) {
               tasks.add(task);
             }
           } catch (e) {
             // Skip invalid rows
             continue;
           }
         }
         
         return await _importTasks(
           workspaceId: workspaceId,
           tasks: tasks,
           strategy: strategy,
         );
       } catch (e) {
         return TaskImportResult(
           isSuccess: false,
           error: 'Failed to parse Excel: $e',
           importedCount: 0,
           skippedCount: 0,
           errorCount: 0,
         );
       }
     }
     
     /// Import tasks from CSV
     Future<TaskImportResult> importFromCSV({
       required String workspaceId,
       required String csvString,
       required ConflictResolutionStrategy strategy,
     }) async {
       try {
         final lines = csvString.split('\n');
         final tasks = <TaskEntity>[];
         
         // Find header row
         int headerIndex = -1;
         for (var i = 0; i < lines.length; i++) {
           if (lines[i].startsWith('ID,Title')) {
             headerIndex = i;
             break;
           }
         }
         
         if (headerIndex == -1) {
           return TaskImportResult(
             isSuccess: false,
             error: 'Invalid CSV format: header not found',
             importedCount: 0,
             skippedCount: 0,
             errorCount: 0,
           );
         }
         
         // Parse data rows
         for (var i = headerIndex + 1; i < lines.length; i++) {
           if (lines[i].trim().isEmpty) continue;
           try {
             final task = _parseTaskFromCSVRow(lines[i]);
             if (task != null) {
               tasks.add(task);
             }
           } catch (e) {
             // Skip invalid rows
             continue;
           }
         }
         
         return await _importTasks(
           workspaceId: workspaceId,
           tasks: tasks,
           strategy: strategy,
         );
       } catch (e) {
         return TaskImportResult(
           isSuccess: false,
           error: 'Failed to parse CSV: $e',
           importedCount: 0,
           skippedCount: 0,
           errorCount: 0,
         );
       }
     }
     
     /// Import tasks with conflict resolution
     Future<TaskImportResult> _importTasks({
       required String workspaceId,
       required List<TaskEntity> tasks,
       required ConflictResolutionStrategy strategy,
     }) async {
       var importedCount = 0;
       var skippedCount = 0;
       var errorCount = 0;
       
       for (final task in tasks) {
         try {
           // Update workspace ID
           final taskToImport = task.copyWith(workspaceId: workspaceId);
           
           // Check if task exists
           final existingTask = await _databaseService.getTask(
             workspaceId: workspaceId,
             taskId: taskToImport.id,
           );
           
           if (existingTask != null) {
             // Handle conflict
             switch (strategy) {
               case ConflictResolutionStrategy.skip:
                 skippedCount++;
                 continue;
               case ConflictResolutionStrategy.overwrite:
                 await _offlineQueueService.updateTask(
                   workspaceId: workspaceId,
                   task: taskToImport,
                 );
                 importedCount++;
                 break;
               case ConflictResolutionStrategy.createNew:
                 final newTask = taskToImport.copyWith(
                   id: _generateNewId(),
                 );
                 await _offlineQueueService.createTask(
                   workspaceId: workspaceId,
                   task: newTask,
                 );
                 importedCount++;
                 break;
             }
           } else {
             // No conflict, create new task
             await _offlineQueueService.createTask(
               workspaceId: workspaceId,
               task: taskToImport,
             );
             importedCount++;
           }
         } catch (e) {
           errorCount++;
           // Continue with next task
         }
       }
       
       return TaskImportResult(
         isSuccess: errorCount < tasks.length,
         importedCount: importedCount,
         skippedCount: skippedCount,
         errorCount: errorCount,
       );
     }
     
     TaskEntity? _parseTaskFromExcelRow(List<Data?> row) {
       // Parse row data into TaskEntity
       // Handle missing/optional fields
     }
     
     TaskEntity? _parseTaskFromCSVRow(String row) {
       // Parse CSV row into TaskEntity
       // Handle quoted fields
     }
   }
   
   enum ConflictResolutionStrategy {
     skip,
     overwrite,
     createNew,
   }
   
   class TaskImportResult {
     final bool isSuccess;
     final String? error;
     final int importedCount;
     final int skippedCount;
     final int errorCount;
     
     TaskImportResult({
       required this.isSuccess,
       this.error,
       required this.importedCount,
       required this.skippedCount,
       required this.errorCount,
     });
   }
   ```

**Expected Results**:
- ✅ Task import service exists
- ✅ JSON import works
- ✅ Excel import works
- ✅ CSV import works
- ✅ Conflict resolution works

**Test Criteria**:
- Unit test: Test import from different formats
- Test: Verify tasks are imported correctly
- Test: Verify conflict resolution works

---

### Task 4: Create Export/Import Use Cases

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use cases for export/import following Clean Architecture.

**Files to Create**:
- `lib/features/tasks/domain/usecases/export_tasks.dart`
- `lib/features/tasks/domain/usecases/import_tasks.dart`

**Implementation Steps**:
1. Create `ExportTasks` use case:
   ```dart
   class ExportTasks {
     final TaskExportService _exportService;
     final PermissionService _permissionService;
     
     ExportTasks({
       TaskExportService? exportService,
       PermissionService? permissionService,
     }) : _exportService = exportService ?? Get.find<TaskExportService>(),
          _permissionService = permissionService ?? Get.find<PermissionService>();
     
     Future<Either<Failure, ExportResult>> call({
       required String workspaceId,
       required String userId,
       required ExportFormat format,
       TaskFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Check permission
       final canExport = await _permissionService.canExportData(userId, workspaceId);
       if (!canExport) {
         return Left(PermissionFailure('User does not have export permission'));
       }
       
       try {
         Uint8List? fileData;
         String? filePath;
         
         switch (format) {
           case ExportFormat.json:
             final jsonString = await _exportService.exportToJSON(
               workspaceId: workspaceId,
               filter: filter,
               fromDate: fromDate,
               toDate: toDate,
             );
             fileData = utf8.encode(jsonString);
             break;
           case ExportFormat.excel:
             fileData = await _exportService.exportToExcel(
               workspaceId: workspaceId,
               filter: filter,
               fromDate: fromDate,
               toDate: toDate,
             );
             break;
           case ExportFormat.csv:
             final csvString = await _exportService.exportToCSV(
               workspaceId: workspaceId,
               filter: filter,
               fromDate: fromDate,
               toDate: toDate,
             );
             fileData = utf8.encode(csvString);
             break;
         }
         
         return Right(ExportResult(
           fileData: fileData!,
           format: format,
           fileName: _generateFileName(workspaceId, format),
         ));
       } catch (e) {
         return Left(ExportFailure('Failed to export tasks: $e'));
       }
     }
   }
   ```

2. Create `ImportTasks` use case similarly

3. Use `Either<Failure, T>` pattern

**Expected Results**:
- ✅ Export use case exists
- ✅ Import use case exists
- ✅ Permission checks work
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test use cases
- Test: Test permission checks
- Test: Test error handling

---

### Task 5: Update BackupService to Export Tasks

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement `exportDataToOneDrive()` in `BackupService` to export tasks.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Implement `exportDataToOneDrive()`:
   ```dart
   Future<void> exportDataToOneDrive() async {
     final workspaceId = _storage.getWorkspaceId();
     if (workspaceId == null || workspaceId.isEmpty) {
       throw const UnknownFailure(message: 'No workspace selected');
     }
     
     // Get all tasks for workspace
     final tasks = await _db.listTasks(workspaceId: workspaceId);
     
     // Get projects for workspace
     final projects = await _db.listProjects(workspaceId: workspaceId);
     
     // Get workspace members
     final members = await _db.listUsersByCompany(workspaceId);
     
     // Create backup payload
     final payload = <String, dynamic>{
       'workspaceId': workspaceId,
       'exportedAt': DateTime.now().toIso8601String(),
       'type': 'full_backup',
       'version': '1.0',
       'tasks': tasks.map((t) => t.toMap()).toList(),
       'projects': projects.map((p) => p.toMap()).toList(),
       'members': members.map((m) => m.toMap()).toList()),
     };
     
     await _oneDrive.backupAppData(payload);
   }
   ```

2. Add method to export only tasks:
   ```dart
   Future<void> exportTasksToOneDrive({
     TaskFilter? filter,
     DateTime? fromDate,
     DateTime? toDate,
   }) async {
     final workspaceId = _storage.getWorkspaceId();
     if (workspaceId == null || workspaceId.isEmpty) {
       throw const UnknownFailure(message: 'No workspace selected');
     }
     
     final taskExportService = Get.find<TaskExportService>();
     final jsonString = await taskExportService.exportToJSON(
       workspaceId: workspaceId,
       filter: filter,
       fromDate: fromDate,
       toDate: toDate,
     );
     
     final payload = jsonDecode(jsonString) as Map<String, dynamic>;
     await _oneDrive.backupAppData(payload);
   }
   ```

**Expected Results**:
- ✅ `exportDataToOneDrive()` is implemented
- ✅ Tasks are exported to OneDrive
- ✅ Backup linkage works

**Test Criteria**:
- Test: Export to OneDrive works
- Test: Backup file is created
- Test: File contains task data

---

### Task 6: Create Export Dialog UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI dialog for configuring and starting task export.

**Files to Create**:
- `lib/features/tasks/presentation/widgets/export_tasks_dialog.dart` (new file)

**Implementation Steps**:
1. Create export dialog:
   ```dart
   class ExportTasksDialog extends StatelessWidget {
     final TaskFilter? currentFilter;
     
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<TaskExportController>();
       
       return Dialog(
         child: Container(
           padding: EdgeInsets.all(AppSpacing.md),
           child: GetBuilder<TaskExportController>(
             builder: (ctrl) {
               return Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(AppStrings.exportTasks, style: AppTextStyles.heading),
                   SizedBox(height: AppSpacing.md),
                   
                   // Format selection
                   DropdownButtonFormField<ExportFormat>(
                     decoration: InputDecoration(
                       labelText: AppStrings.I.exportFormat,
                     ),
                     value: ctrl.selectedFormat,
                     items: ExportFormat.values.map((format) {
                       return DropdownMenuItem(
                         value: format,
                         child: Text(format.displayText),
                       );
                     }).toList(),
                     onChanged: (value) => ctrl.setFormat(value!),
                   ),
                   
                   SizedBox(height: AppSpacing.sm),
                   
                   // Date range
                   Row(
                     children: [
                       Expanded(
                         child: OutlinedButton(
                           onPressed: () => ctrl.selectFromDate(),
                           child: Text(ctrl.fromDate != null 
                               ? _formatDate(ctrl.fromDate!)
                               : AppStrings.I.fromDate),
                         ),
                       ),
                       SizedBox(width: AppSpacing.sm),
                       Expanded(
                         child: OutlinedButton(
                           onPressed: () => ctrl.selectToDate(),
                           child: Text(ctrl.toDate != null 
                               ? _formatDate(ctrl.toDate!)
                               : AppStrings.I.toDate),
                         ),
                       ),
                     ],
                   ),
                   
                   SizedBox(height: AppSpacing.sm),
                   
                   // Use current filters checkbox
                   CheckboxListTile(
                     title: Text(AppStrings.useCurrentFilters),
                     value: ctrl.useCurrentFilters,
                     onChanged: (value) => ctrl.setUseCurrentFilters(value!),
                   ),
                   
                   SizedBox(height: AppSpacing.md),
                   
                   // Export button
                   TDButton(
                     onPressed: () => ctrl.exportTasks(),
                     text: AppStrings.I.export,
                     isLoading: ctrl.isExporting,
                   ),
                 ],
               );
             },
           ),
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

3. Add export format enum:
   ```dart
   enum ExportFormat {
     json('json', 'JSON'),
     excel('excel', 'Excel'),
     csv('csv', 'CSV');
     
     const ExportFormat(this.value, this.displayText);
     final String value;
     final String displayText;
   }
   ```

**Expected Results**:
- ✅ Export dialog exists
- ✅ Format selection works
- ✅ Date range selection works
- ✅ Filter options work
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test export dialog
- Manual test: Test export via UI

---

### Task 7: Create Task Export Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing task export operations.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/task_export_controller.dart` (new file)

**Implementation Steps**:
1. Create export controller:
   ```dart
   class TaskExportController extends GetxController {
     final ExportTasks _exportUseCase;
     final TaskExportService _exportService;
     final StorageService _storageService = Get.find<StorageService>();
     
     final Rx<ExportFormat> _selectedFormat = ExportFormat.json.obs;
     final Rx<DateTime?> _fromDate = Rx<DateTime?>(null);
     final Rx<DateTime?> _toDate = Rx<DateTime?>(null);
     final RxBool _useCurrentFilters = false.obs;
     final RxBool _isExporting = false.obs;
     final RxDouble _exportProgress = 0.0.obs;
     
     ExportFormat get selectedFormat => _selectedFormat.value;
     DateTime? get fromDate => _fromDate.value;
     DateTime? get toDate => _toDate.value;
     bool get useCurrentFilters => _useCurrentFilters.value;
     bool get isExporting => _isExporting.value;
     double get exportProgress => _exportProgress.value;
     
     Future<void> exportTasks() async {
       if (_isExporting.value) return;
       
       try {
         _isExporting.value = true;
         _exportProgress.value = 0.0;
         
         final workspaceId = _storageService.getWorkspaceId();
         final userId = _storageService.getUserId();
         
         if (workspaceId == null || userId == null) {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: AppStrings.I.workspaceNotSelected,
           );
           return;
         }
         
         // Get current filter if using current filters
         TaskFilter? filter;
         if (_useCurrentFilters.value) {
           final taskController = Get.find<PaginatedTaskController>();
           filter = taskController.currentFilter;
         }
         
         final result = await _exportUseCase(
           workspaceId: workspaceId,
           userId: userId,
           format: _selectedFormat.value,
           filter: filter,
           fromDate: _fromDate.value,
           toDate: _toDate.value,
         );
         
         result.fold(
           (failure) {
             SnackbarService().showError(
               title: AppStrings.I.exportFailed,
               message: failure.message,
             );
           },
           (exportResult) async {
             // Save file and share
             await _saveAndShareFile(exportResult);
             
             SnackbarService().showSuccess(
               title: AppStrings.I.exportComplete,
               message: AppStrings.I.tasksExportedSuccessfully,
             );
             
             NavigationService().back<void>();
           },
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToExportTasks,
         );
       } finally {
         _isExporting.value = false;
         _exportProgress.value = 0.0;
       }
     }
     
     Future<void> _saveAndShareFile(ExportResult result) async {
       final directory = await getApplicationDocumentsDirectory();
       final file = File('${directory.path}/${result.fileName}');
       await file.writeAsBytes(result.fileData);
       
       // Share file
       await Share.shareXFiles(
         [XFile(file.path)],
         text: AppStrings.I.taskExport,
       );
     }
   }
   ```

2. Use SnackbarService and NavigationService

**Expected Results**:
- ✅ Export controller exists
- ✅ Export works correctly
- ✅ Progress tracking works
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test export flow

---

### Task 8: Create Import Dialog UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI dialog for importing tasks.

**Files to Create**:
- `lib/features/tasks/presentation/widgets/import_tasks_dialog.dart` (new file)

**Implementation Steps**:
1. Create import dialog:
   ```dart
   class ImportTasksDialog extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<TaskImportController>();
       
       return Dialog(
         child: Container(
           padding: EdgeInsets.all(AppSpacing.md),
           child: GetBuilder<TaskImportController>(
             builder: (ctrl) {
               return Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(AppStrings.importTasks, style: AppTextStyles.heading),
                   SizedBox(height: AppSpacing.md),
                   
                   // Import source selection
                   DropdownButtonFormField<ImportSource>(
                     decoration: InputDecoration(
                       labelText: AppStrings.I.importSource,
                     ),
                     value: ctrl.selectedSource,
                     items: ImportSource.values.map((source) {
                       return DropdownMenuItem(
                         value: source,
                         child: Text(source.displayText),
                       );
                     }).toList(),
                     onChanged: (value) => ctrl.setSource(value!),
                   ),
                   
                   SizedBox(height: AppSpacing.sm),
                   
                   // File picker or OneDrive browser
                   if (ctrl.selectedSource == ImportSource.file)
                     TDButton(
                       onPressed: () => ctrl.pickFile(),
                       text: AppStrings.I.selectFile,
                     ),
                   
                   if (ctrl.selectedSource == ImportSource.oneDrive)
                     TDButton(
                       onPressed: () => ctrl.browseOneDrive(),
                       text: AppStrings.I.browseOneDrive,
                     ),
                   
                   SizedBox(height: AppSpacing.sm),
                   
                   // Conflict resolution
                   DropdownButtonFormField<ConflictResolutionStrategy>(
                     decoration: InputDecoration(
                       labelText: AppStrings.I.conflictResolution,
                     ),
                     value: ctrl.conflictStrategy,
                     items: ConflictResolutionStrategy.values.map((strategy) {
                       return DropdownMenuItem(
                         value: strategy,
                         child: Text(strategy.displayText),
                       );
                     }).toList(),
                     onChanged: (value) => ctrl.setConflictStrategy(value!),
                   ),
                   
                   SizedBox(height: AppSpacing.md),
                   
                   // Import button
                   TDButton(
                     onPressed: () => ctrl.importTasks(),
                     text: AppStrings.I.import,
                     isLoading: ctrl.isImporting,
                   ),
                 ],
               );
             },
           ),
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Import dialog exists
- ✅ Source selection works
- ✅ File picker works
- ✅ OneDrive browser works
- ✅ Conflict resolution selection works
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test import dialog
- Manual test: Test import via UI

---

### Task 9: Create Task Import Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing task import operations.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/task_import_controller.dart` (new file)

**Implementation Steps**:
1. Create import controller:
   ```dart
   class TaskImportController extends GetxController {
     final ImportTasks _importUseCase;
     final TaskImportService _importService;
     final StorageService _storageService = Get.find<StorageService>();
     final OneDriveService _oneDriveService = Get.find<OneDriveService>();
     
     final Rx<ImportSource> _selectedSource = ImportSource.file.obs;
     final Rx<ConflictResolutionStrategy> _conflictStrategy = ConflictResolutionStrategy.skip.obs;
     final RxBool _isImporting = false.obs;
     final RxDouble _importProgress = 0.0.obs;
     final RxString? _selectedFilePath = RxString(null);
     final RxString? _selectedOneDriveFileId = RxString(null);
     
     ImportSource get selectedSource => _selectedSource.value;
     ConflictResolutionStrategy get conflictStrategy => _conflictStrategy.value;
     bool get isImporting => _isImporting.value;
     double get importProgress => _importProgress.value;
     
     Future<void> importTasks() async {
       if (_isImporting.value) return;
       
       try {
         _isImporting.value = true;
         _importProgress.value = 0.0;
         
         final workspaceId = _storageService.getWorkspaceId();
         final userId = _storageService.getUserId();
         
         if (workspaceId == null || userId == null) {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: AppStrings.I.workspaceNotSelected,
           );
           return;
         }
         
         TaskImportResult result;
         
         if (_selectedSource.value == ImportSource.file) {
           if (_selectedFilePath.value == null) {
             SnackbarService().showError(
               title: AppStrings.I.error,
               message: AppStrings.I.pleaseSelectFile,
             );
             return;
           }
           
           final file = File(_selectedFilePath.value!);
           final fileExtension = file.path.split('.').last.toLowerCase();
           
           if (fileExtension == 'json') {
             final jsonString = await file.readAsString();
             result = await _importService.importFromJSON(
               workspaceId: workspaceId,
               jsonString: jsonString,
               strategy: _conflictStrategy.value,
             );
           } else if (fileExtension == 'xlsx' || fileExtension == 'xls') {
             final excelData = await file.readAsBytes();
             result = await _importService.importFromExcel(
               workspaceId: workspaceId,
               excelData: excelData,
               strategy: _conflictStrategy.value,
             );
           } else if (fileExtension == 'csv') {
             final csvString = await file.readAsString();
             result = await _importService.importFromCSV(
               workspaceId: workspaceId,
               csvString: csvString,
               strategy: _conflictStrategy.value,
             );
           } else {
             SnackbarService().showError(
               title: AppStrings.I.error,
               message: AppStrings.I.unsupportedFileFormat,
             );
             return;
           }
         } else {
           // Import from OneDrive
           if (_selectedOneDriveFileId.value == null) {
             SnackbarService().showError(
               title: AppStrings.I.error,
               message: AppStrings.I.pleaseSelectBackupFile,
             );
             return;
           }
           
           final backupData = await _oneDriveService.restoreAppData(_selectedOneDriveFileId.value!);
           final jsonString = jsonEncode(backupData);
           result = await _importService.importFromJSON(
             workspaceId: workspaceId,
             jsonString: jsonString,
             strategy: _conflictStrategy.value,
           );
         }
         
         if (result.isSuccess) {
           SnackbarService().showSuccess(
             title: AppStrings.I.importComplete,
             message: AppStrings.I.tasksImportedSuccessfully(
               result.importedCount,
               result.skippedCount,
               result.errorCount,
             ),
           );
           
           // Refresh task list
           final taskController = Get.find<PaginatedTaskController>();
           await taskController.refreshTasks();
           
           NavigationService().back<void>();
         } else {
           SnackbarService().showError(
             title: AppStrings.I.importFailed,
             message: result.error ?? AppStrings.I.failedToImportTasks,
           );
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToImportTasks,
         );
       } finally {
         _isImporting.value = false;
         _importProgress.value = 0.0;
       }
     }
     
     Future<void> pickFile() async {
       // Use file_picker package or similar
       // Set _selectedFilePath
     }
     
     Future<void> browseOneDrive() async {
       // Show OneDrive file browser
       // Set _selectedOneDriveFileId
     }
   }
   
   enum ImportSource {
     file('file', 'File'),
     oneDrive('onedrive', 'OneDrive');
     
     const ImportSource(this.value, this.displayText);
     final String value;
     final String displayText;
   }
   ```

2. Use SnackbarService and NavigationService

**Expected Results**:
- ✅ Import controller exists
- ✅ Import works correctly
- ✅ Progress tracking works
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test import flow

---

### Task 10: Add Export Button to Task List Page

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add export button to task list page.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`

**Implementation Steps**:
1. Add export button to app bar:
   ```dart
   AppBar(
     actions: [
       // Check permission
       if (_hasExportPermission())
         IconButton(
           icon: Icon(Icons.download),
           onPressed: () => _showExportDialog(),
           tooltip: AppStrings.I.exportTasks,
         ),
     ],
   )
   ```

2. Add export dialog:
   ```dart
   Future<void> _showExportDialog() async {
     await Get.dialog(ExportTasksDialog());
   }
   ```

3. Check permission:
   ```dart
   bool _hasExportPermission() {
     // Check if user is Account Holder or Admin
     // Use PermissionService
   }
   ```

**Expected Results**:
- ✅ Export button exists
- ✅ Button is only visible to authorized users
- ✅ Export dialog opens

**Test Criteria**:
- Test: Export button is visible to authorized users
- Test: Export button opens dialog

---

### Task 11: Add Import Button to Task List Page

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add import button to task list page or settings page.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart` (OR settings page)

**Implementation Steps**:
1. Add import button:
   ```dart
   if (_hasImportPermission())
     IconButton(
       icon: Icon(Icons.upload),
       onPressed: () => _showImportDialog(),
       tooltip: AppStrings.I.importTasks,
     ),
   ```

2. Add import dialog:
   ```dart
   Future<void> _showImportDialog() async {
     await Get.dialog(ImportTasksDialog());
   }
   ```

**Expected Results**:
- ✅ Import button exists
- ✅ Button is only visible to authorized users
- ✅ Import dialog opens

**Test Criteria**:
- Test: Import button is visible to authorized users
- Test: Import button opens dialog

---

### Task 12: Add Export/Import Permission Checks

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks to ensure only Account Holder/Admin can export/import.

**Files to Modify**:
- `lib/core/services/permission_service.dart`

**Implementation Steps**:
1. Add permission methods:
   ```dart
   /// Check if user can export data
   Future<bool> canExportData(String userId, String workspaceId) async {
     final permissions = await _getUserPermissions(userId, workspaceId);
     return permissions.contains('export_data') ||
            permissions.contains('manage_workspace');
   }
   
   /// Check if user can import data
   Future<bool> canImportData(String userId, String workspaceId) async {
     final permissions = await _getUserPermissions(userId, workspaceId);
     return permissions.contains('import_data') ||
            permissions.contains('manage_workspace');
   }
   ```

2. Add permissions to `WorkspacePermissions` enum if needed

3. Integrate with export/import controllers

**Expected Results**:
- ✅ Permission checks exist
- ✅ Only authorized users can export/import
- ✅ Error messages are clear

**Test Criteria**:
- Test: Permission checks work
- Test: Unauthorized users are blocked

---

### Task 13: Add Export/Import Validation

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add validation for imported task data.

**Files to Modify**:
- `lib/core/services/task_import_service.dart`

**Implementation Steps**:
1. Add validation method:
   ```dart
   bool _validateTaskData(Map<String, dynamic> taskData) {
     // Required fields
     if (taskData['id'] == null || taskData['id'].toString().isEmpty) return false;
     if (taskData['title'] == null || taskData['title'].toString().isEmpty) return false;
     if (taskData['workspaceId'] == null || taskData['workspaceId'].toString().isEmpty) return false;
     
     // Validate enum values
     if (taskData['status'] != null) {
       final status = taskData['status'].toString();
       if (!TaskStatus.values.any((s) => s.value == status)) return false;
     }
     
     if (taskData['priority'] != null) {
       final priority = taskData['priority'].toString();
       if (!TaskPriority.values.any((p) => p.value == priority)) return false;
     }
     
     if (taskData['taskType'] != null) {
       final type = taskData['taskType'].toString();
       if (!TaskType.values.any((t) => t.value == type)) return false;
     }
     
     return true;
   }
   ```

2. Validate before importing:
   ```dart
   if (!_validateTaskData(taskMap)) {
     // Skip invalid task or add to error list
     continue;
   }
   ```

**Expected Results**:
- ✅ Validation exists
- ✅ Invalid data is rejected
- ✅ Error messages are helpful

**Test Criteria**:
- Test: Validation works
- Test: Invalid data is handled correctly

---

### Task 14: Add File Picker Integration

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add file picker for selecting files to import.

**Files to Modify**:
- `pubspec.yaml` (add file_picker package)
- `lib/features/tasks/presentation/controllers/task_import_controller.dart`

**Implementation Steps**:
1. Add `file_picker` package to pubspec.yaml:
   ```yaml
   dependencies:
     file_picker: ^6.1.1
   ```

2. Update import controller:
   ```dart
   Future<void> pickFile() async {
     try {
       final result = await FilePicker.platform.pickFiles(
         type: FileType.custom,
         allowedExtensions: ['json', 'csv', 'xlsx', 'xls'],
       );
       
       if (result != null && result.files.single.path != null) {
         _selectedFilePath.value = result.files.single.path!;
       }
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.failedToPickFile,
       );
     }
   }
   ```

**Expected Results**:
- ✅ File picker works
- ✅ Only allowed file types can be selected
- ✅ File path is stored

**Test Criteria**:
- Test: File picker opens
- Test: File selection works
- Test: File validation works

---

### Task 15: Add OneDrive File Browser

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add UI to browse and select OneDrive backup files.

**Files to Create**:
- `lib/features/tasks/presentation/widgets/onedrive_backup_browser.dart` (new file)

**Implementation Steps**:
1. Create OneDrive browser widget:
   ```dart
   class OneDriveBackupBrowser extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<TaskImportController>();
       final backupService = Get.find<BackupService>();
       
       return FutureBuilder<List<Map<String, dynamic>>>(
         future: backupService.listBackups(),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return TDLoadingIndicator();
           }
           
           if (snapshot.hasError) {
             return Text(AppStrings.failedToLoadBackups);
           }
           
           final backups = snapshot.data ?? [];
           
           return ListView.builder(
             itemCount: backups.length,
             itemBuilder: (context, index) {
               final backup = backups[index];
               return ListTile(
                 title: Text(backup['name'] ?? 'Unknown'),
                 subtitle: Text(_formatBackupDate(backup)),
                 trailing: Icon(Icons.chevron_right),
                 onTap: () {
                   controller.selectOneDriveFile(backup['id']);
                   NavigationService().back<void>();
                 },
               );
             },
           );
         },
       );
     }
   }
   ```

2. Show browser in import dialog

**Expected Results**:
- ✅ OneDrive browser exists
- ✅ Backup files are listed
- ✅ File selection works

**Test Criteria**:
- Test: Browser shows backup files
- Test: File selection works

---

### Task 16: Add Export Progress Indicator

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add progress indicator for export operations.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/export_tasks_dialog.dart`

**Implementation Steps**:
1. Add progress indicator:
   ```dart
   if (ctrl.isExporting)
     Column(
       children: [
         LinearProgressIndicator(value: ctrl.exportProgress),
         SizedBox(height: AppSpacing.sm),
         Text('${(ctrl.exportProgress * 100).toInt()}%'),
       ],
     ),
   ```

2. Update progress in controller during export

**Expected Results**:
- ✅ Progress indicator exists
- ✅ Progress updates during export
- ✅ Progress is accurate

**Test Criteria**:
- Test: Progress indicator is shown
- Test: Progress updates correctly

---

### Task 17: Add Import Progress Indicator

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add progress indicator for import operations.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/import_tasks_dialog.dart`

**Implementation Steps**:
1. Add progress indicator similar to export

2. Update progress during import

**Expected Results**:
- ✅ Progress indicator exists
- ✅ Progress updates during import
- ✅ Progress is accurate

**Test Criteria**:
- Test: Progress indicator is shown
- Test: Progress updates correctly

---

### Task 18: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for export/import functionality.

**Files to Create**:
- `test/core/services/task_export_service_test.dart`
- `test/core/services/task_import_service_test.dart`
- `test/features/tasks/domain/usecases/export_tasks_test.dart`
- `test/features/tasks/domain/usecases/import_tasks_test.dart`

**Implementation Steps**:
1. Test export service:
   - Test JSON export
   - Test Excel export
   - Test CSV export
   - Test filtering

2. Test import service:
   - Test JSON import
   - Test Excel import
   - Test CSV import
   - Test conflict resolution
   - Test validation

3. Test use cases:
   - Test permission checks
   - Test error handling

**Expected Results**:
- ✅ Unit tests cover export/import
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Required Packages to pubspec.yaml (Critical - Dependencies)
2. **Task 2**: Create Task Export Service (Critical - Core Logic)
3. **Task 3**: Create Task Import Service (Critical - Core Logic)
4. **Task 4**: Create Export/Import Use Cases (High Priority - Business Logic)
5. **Task 12**: Add Export/Import Permission Checks (High Priority - Security)
6. **Task 13**: Add Export/Import Validation (High Priority - Data Integrity)
7. **Task 5**: Update BackupService to Export Tasks (High Priority - Backup Linkage)
8. **Task 7**: Create Task Export Controller (High Priority - Integration)
9. **Task 9**: Create Task Import Controller (High Priority - Integration)
10. **Task 6**: Create Export Dialog UI (High Priority - User Experience)
11. **Task 8**: Create Import Dialog UI (High Priority - User Experience)
12. **Task 10**: Add Export Button to Task List Page (Medium Priority - UI)
13. **Task 11**: Add Import Button to Task List Page (Medium Priority - UI)
14. **Task 14**: Add File Picker Integration (Medium Priority - User Experience)
15. **Task 15**: Add OneDrive File Browser (Medium Priority - User Experience)
16. **Task 16**: Add Export Progress Indicator (Low Priority - UX Enhancement)
17. **Task 17**: Add Import Progress Indicator (Low Priority - UX Enhancement)
18. **Task 18**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Tasks can be exported to JSON, Excel, and CSV formats
- ✅ Tasks can be imported from JSON, Excel, and CSV formats
- ✅ Export supports filtering and date range
- ✅ Import supports conflict resolution
- ✅ Export/import is linked with OneDrive backup
- ✅ Permission checks work (only Account Holder/Admin)
- ✅ Validation works for imported data
- ✅ Progress indicators work
- ✅ File picker works
- ✅ OneDrive browser works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for fetching tasks
- **OneDrive Service**: Required for backup linkage
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **Excel Package**: Required for Excel export (`excel` package)
- **CSV Package**: Required for CSV export (`csv` package)
- **Share Plus**: Required for file sharing (`share_plus` package)
- **File Picker**: Required for file selection (`file_picker` package)
- **Path Provider**: Already in pubspec.yaml

---

## Notes

1. **Export Formats**: Support JSON (for backup), Excel (for analysis), and CSV (for compatibility).

2. **Backup Linkage**: Export to OneDrive should integrate with existing backup system. Import from OneDrive should allow restoring tasks from backups.

3. **Permission**: Only Account Holder and Admin should be able to export/import. This is critical for data security.

4. **Validation**: Imported data must be validated to ensure data integrity. Invalid data should be rejected or skipped.

5. **Conflict Resolution**: When importing, tasks with same ID may exist. Provide options: Skip, Overwrite, or Create New.

6. **Workspace Scoping**: All export/import operations must be scoped to current workspace for data isolation.

7. **Large Datasets**: Consider pagination or streaming for large exports to avoid memory issues.

8. **Existing Components**: `BackupService.exportDataToOneDrive()` is empty - need to implement. `OneDriveService` has backup methods that can be used.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_EXPORT_IMPORT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/feature_checklists/backup_feature/BACKUP_IMPLEMENTATION_AUDIT_REPORT.md` - Backup feature status
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

