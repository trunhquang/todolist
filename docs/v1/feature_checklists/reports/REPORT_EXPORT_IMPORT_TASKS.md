# Report Export/Import (Excel/PDF) & Saved Filter Configurations - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Report Export/Import (Excel/PDF) & Saved Filter Configurations** feature. Currently, this feature is **MISSING** - No export/import or saved-filter implementation found.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService.exportReportsToOneDrive()` exists (exports to JSON format)
- ✅ `BackupController` exists with `exportReports()` method
- ✅ `OneDriveService` has `backupAppData()` and `restoreAppData()` methods
- ✅ `path_provider` package is in pubspec.yaml

### What's Missing/Broken:
- ⛔ No Excel export for reports
- ⛔ No PDF export for reports
- ⛔ No import functionality for reports
- ⛔ No saved filter configurations
- ⛔ No export/import UI
- ⛔ No export/import use cases
- ⛔ No validation for import
- ⛔ No permission checks
- ⛔ Excel/PDF/CSV packages not in pubspec.yaml
- ⛔ File picker package not in pubspec.yaml

---

## Task List

### Task 1: Add Required Packages to pubspec.yaml

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add packages required for Excel, PDF export and file operations.

**Files to Modify**:
- `pubspec.yaml`

**Implementation Steps**:
1. Add packages:
   ```yaml
   dependencies:
     # ... existing packages ...
     excel: ^2.1.0  # For Excel export
     pdf: ^3.10.0   # For PDF export
     share_plus: ^7.2.1  # For file sharing
     file_picker: ^6.1.1  # For file selection
   ```

2. Run `flutter pub get`

3. Verify packages are installed

**Expected Results**:
- ✅ Excel package is added
- ✅ PDF package is added
- ✅ Share plus package is added
- ✅ File picker package is added
- ✅ Packages are installed

**Test Criteria**:
- Run `flutter pub get`
- Verify no errors
- Verify packages are available

---

### Task 2: Create Report Export Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for exporting reports to different formats.

**Files to Create**:
- `lib/core/services/report_export_service.dart` (new file)

**Implementation Steps**:
1. Create `ReportExportService`:
   ```dart
   class ReportExportService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     final OneDriveService _oneDriveService = Get.find<OneDriveService>();
     
     /// Export reports to Excel
     Future<String> exportToExcel({
       required String workspaceId,
       List<ReportEntity>? reports,
       ReportFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Get reports if not provided
       if (reports == null) {
         reports = await _getFilteredReports(
           workspaceId: workspaceId,
           filter: filter,
           fromDate: fromDate,
           toDate: toDate,
         );
       }
       
       // Create Excel workbook
       final excel = Excel.createExcel();
       final sheet = excel['Reports'];
       
       // Add headers
       sheet.appendRow([
         'ID',
         'User ID',
         'Date',
         'Summary',
         'Status',
         'Completed Tasks',
         'Created At',
         'Submitted At',
       ]);
       
       // Add data rows
       for (final report in reports) {
         sheet.appendRow([
           report.id,
           report.userId,
           report.date.toIso8601String(),
           report.summary,
           report.status.name,
           report.completedTaskIds.length,
           report.createdAt?.toIso8601String() ?? '',
           report.submittedAt?.toIso8601String() ?? '',
         ]);
       }
       
       // Save to file
       final fileName = 'reports_${DateTime.now().millisecondsSinceEpoch}.xlsx';
       final filePath = await _getExportPath(fileName);
       final bytes = excel.save();
       await File(filePath).writeAsBytes(bytes!);
       
       return filePath;
     }
     
     /// Export reports to PDF
     Future<String> exportToPDF({
       required String workspaceId,
       List<ReportEntity>? reports,
       ReportFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Get reports if not provided
       if (reports == null) {
         reports = await _getFilteredReports(
           workspaceId: workspaceId,
           filter: filter,
           fromDate: fromDate,
           toDate: toDate,
         );
       }
       
       // Create PDF document
       final pdf = pw.Document();
       
       // Add content
       pdf.addPage(
         pw.Page(
           build: (pw.Context context) {
             return pw.Column(
               crossAxisAlignment: pw.CrossAxisAlignment.start,
               children: [
                 pw.Text('Reports Export', style: pw.TextStyle(fontSize: 24)),
                 pw.SizedBox(height: 20),
                 ...reports.map((report) {
                   return pw.Column(
                     crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                       pw.Text('Report ID: ${report.id}'),
                       pw.Text('Date: ${report.date.toIso8601String()}'),
                       pw.Text('Summary: ${report.summary}'),
                       pw.Text('Status: ${report.status.name}'),
                       pw.Divider(),
                     ],
                   );
                 }),
               ],
             );
           },
         ),
       );
       
       // Save to file
       final fileName = 'reports_${DateTime.now().millisecondsSinceEpoch}.pdf';
       final filePath = await _getExportPath(fileName);
       final file = File(filePath);
       await file.writeAsBytes(await pdf.save());
       
       return filePath;
     }
     
     /// Export reports to JSON (enhance existing)
     Future<String> exportToJSON({
       required String workspaceId,
       List<ReportEntity>? reports,
       ReportFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Get reports if not provided
       if (reports == null) {
         reports = await _getFilteredReports(
           workspaceId: workspaceId,
           filter: filter,
           fromDate: fromDate,
           toDate: toDate,
         );
       }
       
       final exportData = {
         'workspaceId': workspaceId,
         'exportedAt': DateTime.now().toIso8601String(),
         'exportedBy': _storageService.getUserId(),
         'type': 'reports',
         'version': '1.0',
         'reportCount': reports.length,
         'reports': reports.map((r) => r.toMap()).toList(),
       };
       
       final jsonString = jsonEncode(exportData);
       final fileName = 'reports_${DateTime.now().millisecondsSinceEpoch}.json';
       final filePath = await _getExportPath(fileName);
       await File(filePath).writeAsString(jsonString);
       
       return filePath;
     }
     
     Future<List<ReportEntity>> _getFilteredReports({
       required String workspaceId,
       ReportFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       // Use ReportFilterService to get filtered reports
       final filterService = Get.find<ReportFilterService>();
       return await filterService.getFilteredReports(
         filter: filter ?? ReportFilter(workspaceId: workspaceId),
       );
     }
     
     Future<String> _getExportPath(String fileName) async {
       final directory = await getApplicationDocumentsDirectory();
       return '${directory.path}/$fileName';
     }
   }
   ```

2. Import required packages

3. Use existing services

**Expected Results**:
- ✅ Report export service exists
- ✅ Excel export works
- ✅ PDF export works
- ✅ JSON export works
- ✅ Filtered export works

**Test Criteria**:
- Unit test: Test export methods
- Test: Export to Excel
- Test: Export to PDF
- Test: Export to JSON

---

### Task 3: Create Report Import Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for importing reports from different formats.

**Files to Create**:
- `lib/core/services/report_import_service.dart` (new file)

**Implementation Steps**:
1. Create `ReportImportService`:
   ```dart
   class ReportImportService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     final OneDriveService _oneDriveService = Get.find<OneDriveService>();
     
     /// Import reports from Excel
     Future<ImportResult> importFromExcel(String filePath) async {
       try {
         final excel = Excel.decodeBytes(await File(filePath).readAsBytes());
         final sheet = excel.tables['Reports'];
         
         if (sheet == null) {
           return ImportResult(
             isSuccess: false,
             error: 'Invalid Excel file format',
           );
         }
         
         final reports = <ReportEntity>[];
         final errors = <String>[];
         
         // Skip header row
         for (var i = 1; i < sheet.rows.length; i++) {
           try {
             final row = sheet.rows[i];
             final report = _parseReportFromExcelRow(row);
             if (report != null) {
               reports.add(report);
             }
           } catch (e) {
             errors.add('Row ${i + 1}: $e');
           }
         }
         
         return ImportResult(
           isSuccess: true,
           importedCount: reports.length,
           errors: errors,
           reports: reports,
         );
       } catch (e) {
         return ImportResult(
           isSuccess: false,
           error: 'Failed to import Excel file: $e',
         );
       }
     }
     
     /// Import reports from JSON
     Future<ImportResult> importFromJSON(String filePath) async {
       try {
         final jsonString = await File(filePath).readAsString();
         final data = jsonDecode(jsonString) as Map<String, dynamic>;
         
         if (data['type'] != 'reports') {
           return ImportResult(
             isSuccess: false,
             error: 'Invalid file type',
           );
         }
         
         final reportsData = data['reports'] as List<dynamic>;
         final reports = reportsData.map((r) {
           return ReportEntity.fromMap(Map<String, dynamic>.from(r));
         }).toList();
         
         return ImportResult(
           isSuccess: true,
           importedCount: reports.length,
           reports: reports,
         );
       } catch (e) {
         return ImportResult(
           isSuccess: false,
           error: 'Failed to import JSON file: $e',
         );
       }
     }
     
     ReportEntity? _parseReportFromExcelRow(List<Data?> row) {
       // Parse Excel row to ReportEntity
       // Implementation depends on Excel structure
       return null; // Placeholder
     }
   }
   
   class ImportResult {
     final bool isSuccess;
     final String? error;
     final int importedCount;
     final List<String> errors;
     final List<ReportEntity> reports;
     
     const ImportResult({
       required this.isSuccess,
       this.error,
       this.importedCount = 0,
       this.errors = const [],
       this.reports = const [],
     });
   }
   ```

2. Add validation logic

3. Add conflict resolution

**Expected Results**:
- ✅ Report import service exists
- ✅ Excel import works
- ✅ JSON import works
- ✅ Validation works

**Test Criteria**:
- Unit test: Test import methods
- Test: Import from Excel
- Test: Import from JSON
- Test: Validation

---

### Task 4: Create Export/Import Use Cases

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use cases for export/import following Clean Architecture.

**Files to Create**:
- `lib/features/reports/domain/usecases/export_reports.dart` (new file)
- `lib/features/reports/domain/usecases/import_reports.dart` (new file)

**Implementation Steps**:
1. Create `ExportReports` use case:
   ```dart
   class ExportReports {
     final ReportExportService _exportService;
     
     ExportReports({
       ReportExportService? exportService,
     }) : _exportService = exportService ?? Get.find<ReportExportService>();
     
     Future<Either<Failure, String>> call({
       required String workspaceId,
       required ExportFormat format,
       ReportFilter? filter,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       try {
         final filePath = await _exportService.exportToFormat(
           workspaceId: workspaceId,
           format: format,
           filter: filter,
           fromDate: fromDate,
           toDate: toDate,
         );
         
         return Right(filePath);
       } catch (e) {
         return Left(ExportFailure('Failed to export reports: $e'));
       }
     }
   }
   
   enum ExportFormat { excel, pdf, json }
   ```

2. Create `ImportReports` use case similarly

3. Use `Either<Failure, T>` pattern

**Expected Results**:
- ✅ Export use case exists
- ✅ Import use case exists
- ✅ Error handling works

**Test Criteria**:
- Unit test: Test use cases
- Test: Test error handling

---

### Task 5: Create Export/Import Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing export/import operations.

**Files to Create**:
- `lib/features/reports/presentation/controllers/report_export_import_controller.dart` (new file)

**Implementation Steps**:
1. Create `ReportExportImportController`:
   ```dart
   class ReportExportImportController extends GetxController {
     final ExportReports _exportReports;
     final ImportReports _importReports;
     final StorageService _storageService = Get.find<StorageService>();
     
     final RxBool _isExporting = false.obs;
     final RxBool _isImporting = false.obs;
     final RxDouble _exportProgress = 0.0.obs;
     final RxDouble _importProgress = 0.0.obs;
     
     bool get isExporting => _isExporting.value;
     bool get isImporting => _isImporting.value;
     double get exportProgress => _exportProgress.value;
     double get importProgress => _importProgress.value;
     
     Future<void> exportReports({
       required ExportFormat format,
       ReportFilter? filter,
     }) async {
       try {
         _isExporting.value = true;
         _exportProgress.value = 0.0;
         
         final workspaceId = _storageService.getWorkspaceId();
         if (workspaceId == null) {
           SnackbarService().showError(
             title: AppStrings.error,
             message: AppStrings.workspaceNotSelected,
           );
           return;
         }
         
         final result = await _exportReports(
           workspaceId: workspaceId,
           format: format,
           filter: filter,
         );
         
         result.fold(
           (failure) {
             SnackbarService().showError(
               title: AppStrings.error,
               message: failure.message,
             );
           },
           (filePath) {
             _shareFile(filePath, format);
             SnackbarService().showSuccess(
               title: AppStrings.success,
               message: AppStrings.exportComplete,
             );
           },
         );
       } finally {
         _isExporting.value = false;
         _exportProgress.value = 0.0;
       }
     }
     
     Future<void> importReports({
       required ImportFormat format,
       required String filePath,
     }) async {
       try {
         _isImporting.value = true;
         _importProgress.value = 0.0;
         
         final result = await _importReports(
           format: format,
           filePath: filePath,
         );
         
         result.fold(
           (failure) {
             SnackbarService().showError(
               title: AppStrings.error,
               message: failure.message,
             );
           },
           (importResult) {
             SnackbarService().showSuccess(
               title: AppStrings.success,
               message: '${AppStrings.importComplete}: ${importResult.importedCount} reports',
             );
           },
         );
       } finally {
         _isImporting.value = false;
         _importProgress.value = 0.0;
       }
     }
     
     Future<void> _shareFile(String filePath, ExportFormat format) async {
       final share = Share();
       await share.shareXFiles(
         [XFile(filePath)],
         text: 'Reports export',
       );
     }
   }
   ```

2. Use SnackbarService and AppStrings

**Expected Results**:
- ✅ Export/import controller exists
- ✅ Export/import operations work
- ✅ Progress tracking works

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test export/import operations

---

### Task 6: Create Export/Import UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for export/import operations.

**Files to Create**:
- `lib/features/reports/presentation/widgets/report_export_dialog.dart` (new file)
- `lib/features/reports/presentation/widgets/report_import_dialog.dart` (new file)

**Implementation Steps**:
1. Create export dialog:
   ```dart
   class ReportExportDialog extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<ReportExportImportController>();
       final filterController = Get.find<ReportFilterController>();
       
       return AlertDialog(
         title: Text(AppStrings.exportReports),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             // Format selection
             DropdownButtonFormField<ExportFormat>(
               decoration: InputDecoration(labelText: AppStrings.format),
               items: [
                 DropdownMenuItem(value: ExportFormat.excel, child: Text('Excel')),
                 DropdownMenuItem(value: ExportFormat.pdf, child: Text('PDF')),
                 DropdownMenuItem(value: ExportFormat.json, child: Text('JSON')),
               ],
               onChanged: (value) {
                 // Handle format selection
               },
             ),
             
             SizedBox(height: AppSpacing.md),
             
             // Filter options
             Text(AppStrings.exportOptions),
             CheckboxListTile(
               title: Text(AppStrings.includeCurrentFilters),
               value: true,
               onChanged: (value) {},
             ),
           ],
         ),
         actions: [
           TDButton(
             text: AppStrings.cancel,
             onPressed: () => NavigationService().back<void>(),
             variant: TDButtonVariant.outlined,
           ),
           TDButton(
             text: AppStrings.export,
             onPressed: () {
               controller.exportReports(
                 format: ExportFormat.excel,
                 filter: filterController.currentFilter,
               );
               NavigationService().back<void>();
             },
           ),
         ],
       );
     }
   }
   ```

2. Create import dialog similarly

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Export dialog exists
- ✅ Import dialog exists
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test dialogs
- Manual test: Test export/import UI

---

### Task 7: Create Saved Filter Entity and Repository

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create entity and repository for saved filter configurations.

**Files to Create**:
- `lib/features/reports/domain/entities/saved_report_filter.dart` (new file)
- `lib/features/reports/data/repositories/saved_filter_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `SavedReportFilter` entity (see Task 7 in REPORT_FILTERING_TASKS.md)

2. Create repository:
   ```dart
   class SavedFilterRepositoryImpl implements SavedFilterRepository {
     final FirebaseDatabaseService _databaseService;
     
     @override
     Future<String> save(SavedReportFilter filter) async {
       return await _databaseService.createSavedFilter(filter);
     }
     
     @override
     Future<List<SavedReportFilter>> list(String workspaceId, String userId) async {
       return await _databaseService.listSavedFilters(workspaceId, userId);
     }
     
     @override
     Future<void> delete(String workspaceId, String filterId) async {
       await _databaseService.deleteSavedFilter(workspaceId, filterId);
     }
   }
   ```

**Expected Results**:
- ✅ Saved filter entity exists
- ✅ Repository exists
- ✅ CRUD operations work

**Test Criteria**:
- Unit test: Test repository
- Test: Test CRUD operations

---

### Task 8: Add Permission Checks

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks for export/import operations.

**Files to Modify**:
- `lib/features/reports/presentation/controllers/report_export_import_controller.dart`

**Implementation Steps**:
1. Add permission check:
   ```dart
   Future<bool> _checkExportPermission() async {
     final userRole = await _getCurrentUserRole();
     return userRole == UserRole.accountHolder || userRole == UserRole.admin;
   }
   
   Future<void> exportReports(...) async {
     if (!await _checkExportPermission()) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.permissionDenied,
       );
       return;
     }
     // ... rest of export logic
   }
   ```

2. Add similar check for import

**Expected Results**:
- ✅ Permission checks work
- ✅ Only authorized users can export/import
- ✅ Error messages are clear

**Test Criteria**:
- Test: Permission check works
- Test: Unauthorized users are blocked

---

### Task 9: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests.

**Files to Create**:
- `test/core/services/report_export_service_test.dart`
- `test/core/services/report_import_service_test.dart`
- `test/features/reports/presentation/controllers/report_export_import_controller_test.dart`

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

1. **Task 1**: Add Required Packages (Critical - Foundation)
2. **Task 2**: Create Report Export Service (Critical - Core Logic)
3. **Task 3**: Create Report Import Service (Critical - Core Logic)
4. **Task 4**: Create Export/Import Use Cases (High Priority - Business Logic)
5. **Task 5**: Create Export/Import Controller (High Priority - Integration)
6. **Task 6**: Create Export/Import UI (High Priority - User Experience)
7. **Task 7**: Create Saved Filter Entity and Repository (Medium Priority - Feature Enhancement)
8. **Task 8**: Add Permission Checks (Medium Priority - Security)
9. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Excel export works
- ✅ PDF export works
- ✅ JSON export works (enhanced)
- ✅ Excel import works
- ✅ JSON import works
- ✅ Saved filter configurations work
- ✅ Permission checks work
- ✅ Validation works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules
- ✅ Workspace scoping works
- ✅ No known bugs or issues

---

## Dependencies

- **Excel Package**: `excel` package for Excel export
- **PDF Package**: `pdf` package for PDF export
- **Share Plus**: `share_plus` package for file sharing
- **File Picker**: `file_picker` package for file selection
- **OneDrive Service**: Existing service for backup linkage
- **GetX**: Required for state management
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Export Formats**: Support Excel (for analysis), PDF (for presentation), and JSON (for backup).

2. **Permission**: Only Account Holder and Admin should be able to export/import. This is critical for data security.

3. **Validation**: Imported data must be validated to ensure data integrity.

4. **Workspace Scoping**: All export/import operations must be scoped to current workspace.

5. **Existing Components**: `BackupService.exportReportsToOneDrive()` exists and can be enhanced.

---

## Related Documentation

- `REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `REPORT_EXPORT_IMPORT_TEST_CASES.md` - Test cases for this feature
- `REPORT_FILTERING_TASKS.md` - Saved filter configurations (Task 7)
- `docs/v1/feature_checklists/reports/reports.md` - Report requirements
