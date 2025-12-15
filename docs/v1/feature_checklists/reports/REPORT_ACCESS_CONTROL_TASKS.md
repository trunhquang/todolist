# Report Access Control (Role-Based Access) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Report Access Control** feature (role-based access control for reports). Currently, this feature is **MISSING** - No access control specific to reports; relies on generic roles only.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `WorkspacePermissions` has `generateReports` and `viewAnalytics` constants
- ✅ `DefaultPermissionSets` includes report permissions for Account Holder and Admin
- ✅ `PermissionService` exists with generic permission checking
- ✅ `AccessControlService` exists with `has()` and `ensure()` methods
- ✅ `WorkspaceRole` enum with accountHolder/admin/member
- ✅ `RoleBasedWidget` exists for conditional UI rendering

### What's Missing/Broken:
- ⛔ No permission checks in report controllers
- ⛔ No permission checks in report UI
- ⛔ No report-specific permission methods
- ⛔ No permission assignment UI for reports
- ⛔ No permission error handling for reports
- ⛔ No permission caching for reports
- ⛔ No permission audit log

---

## Task List

### Task 1: Create Report Permission Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for checking report-specific permissions.

**Files to Create**:
- `lib/core/services/report_permission_service.dart` (new file)

**Implementation Steps**:
1. Create `ReportPermissionService`:
   ```dart
   class ReportPermissionService extends GetxService {
     final AccessControlService _accessControl = Get.find<AccessControlService>();
     final PermissionService _permissionService = Get.find<PermissionService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     /// Check if user can view reports
     Future<bool> canViewReports() async {
       final userId = _storageService.getUserId();
       final workspaceId = _storageService.getWorkspaceId();
       if (userId == null || workspaceId == null) return false;
       
       // Account Holder always has access
       final userRole = await _getUserRole(workspaceId);
       if (userRole == WorkspaceRole.accountHolder) return true;
       
       // Check permissions
       return await _accessControl.has(WorkspacePermissions.viewAnalytics) ||
              await _accessControl.has(WorkspacePermissions.generateReports);
     }
     
     /// Check if user can generate reports
     Future<bool> canGenerateReports() async {
       final userId = _storageService.getUserId();
       final workspaceId = _storageService.getWorkspaceId();
       if (userId == null || workspaceId == null) return false;
       
       // Account Holder always has access
       final userRole = await _getUserRole(workspaceId);
       if (userRole == WorkspaceRole.accountHolder) return true;
       
       // Check permission
       return await _accessControl.has(WorkspacePermissions.generateReports);
     }
     
     /// Check if user can view analytics
     Future<bool> canViewAnalytics() async {
       final userId = _storageService.getUserId();
       final workspaceId = _storageService.getWorkspaceId();
       if (userId == null || workspaceId == null) return false;
       
       // Account Holder always has access
       final userRole = await _getUserRole(workspaceId);
       if (userRole == WorkspaceRole.accountHolder) return true;
       
       // Check permission
       return await _accessControl.has(WorkspacePermissions.viewAnalytics);
     }
     
     /// Check if user can export reports
     Future<bool> canExportReports() async {
       final userId = _storageService.getUserId();
       final workspaceId = _storageService.getWorkspaceId();
       if (userId == null || workspaceId == null) return false;
       
       // Account Holder and Admin can export
       final userRole = await _getUserRole(workspaceId);
       if (userRole == WorkspaceRole.accountHolder || userRole == WorkspaceRole.admin) {
         return true;
       }
       
       // Members need explicit permission (if implemented)
       return false;
     }
     
     /// Check if user can import reports
     Future<bool> canImportReports() async {
       final userId = _storageService.getUserId();
       final workspaceId = _storageService.getWorkspaceId();
       if (userId == null || workspaceId == null) return false;
       
       // Account Holder and Admin can import
       final userRole = await _getUserRole(workspaceId);
       if (userRole == WorkspaceRole.accountHolder || userRole == WorkspaceRole.admin) {
         return true;
       }
       
       // Members cannot import
       return false;
     }
     
     /// Ensure user can view reports, throw on denial
     Future<void> ensureCanViewReports() async {
       final canView = await canViewReports();
       if (!canView) {
         throw PermissionFailure(
           message: AppStrings.I.permissionDeniedViewReports,
         );
       }
     }
     
     /// Ensure user can generate reports, throw on denial
     Future<void> ensureCanGenerateReports() async {
       final canGenerate = await canGenerateReports();
       if (!canGenerate) {
         throw PermissionFailure(
           message: AppStrings.I.permissionDeniedGenerateReports,
         );
       }
     }
     
     Future<WorkspaceRole> _getUserRole(String workspaceId) async {
       // Get user role from workspace member
       // Implementation depends on workspace repository
       return WorkspaceRole.member; // Placeholder
     }
   }
   ```

2. Use existing `AccessControlService` and `PermissionService`

3. Add to AppStrings:
   ```dart
   static const String permissionDeniedViewReports = 'You do not have permission to view reports';
   static const String permissionDeniedGenerateReports = 'You do not have permission to generate reports';
   static const String permissionDeniedViewAnalytics = 'You do not have permission to view analytics';
   static const String permissionDeniedExportReports = 'You do not have permission to export reports';
   static const String permissionDeniedImportReports = 'You do not have permission to import reports';
   ```

**Expected Results**:
- ✅ Report permission service exists
- ✅ Permission checks work correctly
- ✅ Account Holder has full access
- ✅ Admin/Member access is permission-based

**Test Criteria**:
- Unit test: Test permission methods
- Test: Test Account Holder access
- Test: Test Admin/Member access

---

### Task 2: Add Permission Checks to Report Controllers

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks to all report controllers.

**Files to Modify**:
- `lib/features/reports/presentation/controllers/report_controller.dart`
- `lib/features/reports/presentation/controllers/report_history_controller.dart`
- `lib/features/reports/presentation/controllers/overview_report_controller.dart`
- `lib/features/reports/presentation/controllers/project_analytics_controller.dart`

**Implementation Steps**:
1. Inject `ReportPermissionService`:
   ```dart
   class ReportController extends GetxController {
     final ReportService _reportService;
     final ReportPermissionService _permissionService = Get.find<ReportPermissionService>();
     
     // ... existing code ...
   }
   ```

2. Add permission checks to methods:
   ```dart
   Future<void> loadTodayReports() async {
     try {
       // Check permission
       await _permissionService.ensureCanViewReports();
       
       _isLoading.value = true;
       _error.value = null;
       // ... rest of method ...
     } on PermissionFailure catch (e) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: e.message,
       );
       return;
     } catch (e) {
       _error.value = 'Failed to load reports: $e';
     } finally {
       _isLoading.value = false;
     }
   }
   ```

3. Add similar checks to all report operations

**Expected Results**:
- ✅ Permission checks are added to controllers
- ✅ Unauthorized access is blocked
- ✅ Error messages are shown

**Test Criteria**:
- Test: Permission checks work
- Test: Unauthorized access is blocked
- Test: Error messages are shown

---

### Task 3: Add Permission Checks to Report UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks and conditional UI rendering to report pages.

**Files to Modify**:
- `lib/app/pages/reports/report_analytics_page.dart`
- `lib/app/pages/reports/report_history_page.dart`
- `lib/app/pages/tasks/task_statistics_page.dart`

**Implementation Steps**:
1. Use `RoleBasedWidget` or create permission-based widgets:
   ```dart
   class ReportAnalyticsPage extends StatefulWidget {
     @override
     Widget build(BuildContext context) {
       final permissionService = Get.find<ReportPermissionService>();
       
       return Scaffold(
         body: FutureBuilder<bool>(
           future: permissionService.canViewAnalytics(),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return TDLoadingIndicator();
             }
             
             if (!snapshot.hasData || !snapshot.data!) {
               return Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.lock, size: 48, color: Colors.red),
                     SizedBox(height: AppSpacing.md),
                     Text(AppStrings.permissionDeniedViewAnalytics),
                     SizedBox(height: AppSpacing.sm),
                     Text(AppStrings.contactAdminForAccess),
                   ],
                 ),
               );
             }
             
             return _buildAnalyticsContent();
           },
         ),
       );
     }
   }
   ```

2. Hide/show UI elements based on permissions:
   ```dart
   // Export button
   if (await permissionService.canExportReports())
     IconButton(
       icon: Icon(Icons.download),
       onPressed: () => _exportReports(),
     ),
   ```

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Permission checks are added to UI
- ✅ UI elements are hidden/shown based on permissions
- ✅ Access denied messages are shown
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test permission-based UI
- Manual test: Test UI visibility
- Test: Test access denied messages

---

### Task 4: Create Report Permission Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create reusable widget for permission-based UI rendering.

**Files to Create**:
- `lib/features/reports/presentation/widgets/report_permission_widget.dart` (new file)

**Implementation Steps**:
1. Create `ReportPermissionWidget`:
   ```dart
   class ReportPermissionWidget extends StatelessWidget {
     final Future<bool> Function() permissionCheck;
     final Widget child;
     final Widget? deniedWidget;
     
     const ReportPermissionWidget({
       super.key,
       required this.permissionCheck,
       required this.child,
       this.deniedWidget,
     });
     
     @override
     Widget build(BuildContext context) {
       return FutureBuilder<bool>(
         future: permissionCheck(),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return TDLoadingIndicator();
           }
           
           if (!snapshot.hasData || !snapshot.data!) {
             return deniedWidget ?? _buildDefaultDeniedWidget();
           }
           
           return child;
         },
       );
     }
     
     Widget _buildDefaultDeniedWidget() {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.lock, size: 48, color: Colors.red),
             SizedBox(height: AppSpacing.md),
             Text(AppStrings.permissionDenied),
             SizedBox(height: AppSpacing.sm),
             Text(AppStrings.contactAdminForAccess),
           ],
         ),
       );
     }
   }
   ```

2. Use in report pages:
   ```dart
   ReportPermissionWidget(
     permissionCheck: () => permissionService.canViewAnalytics(),
     child: _buildAnalyticsContent(),
   ),
   ```

**Expected Results**:
- ✅ Report permission widget exists
- ✅ Widget is reusable
- ✅ Widget follows project rules

**Test Criteria**:
- Widget test: Test permission widget
- Test: Test denied widget display

---

### Task 5: Add Permission Assignment UI for Reports

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add UI for assigning report permissions to users.

**Files to Modify**:
- `lib/app/pages/permissions/permission_management_page.dart`

**Implementation Steps**:
1. Add report permissions section:
   ```dart
   Widget _buildReportPermissionsSection() {
     return ExpansionTile(
       title: Text(AppStrings.reportPermissions),
       children: [
         CheckboxListTile(
           title: Text(AppStrings.generateReports),
           value: _hasPermission(WorkspacePermissions.generateReports),
           onChanged: (value) => _togglePermission(
             WorkspacePermissions.generateReports,
             value ?? false,
           ),
         ),
         CheckboxListTile(
           title: Text(AppStrings.viewAnalytics),
           value: _hasPermission(WorkspacePermissions.viewAnalytics),
           onChanged: (value) => _togglePermission(
             WorkspacePermissions.viewAnalytics,
             value ?? false,
           ),
         ),
       ],
     );
   }
   ```

2. Integrate with existing permission management

**Expected Results**:
- ✅ Report permissions can be assigned
- ✅ UI is clear and usable
- ✅ Permissions are saved correctly

**Test Criteria**:
- Manual test: Assign report permissions
- Test: Permissions are saved
- Test: Permissions take effect

---

### Task 6: Add Permission Caching

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add caching for report permissions to improve performance.

**Files to Modify**:
- `lib/core/services/report_permission_service.dart`

**Implementation Steps**:
1. Add permission cache:
   ```dart
   class ReportPermissionService extends GetxService {
     final Map<String, bool> _permissionCache = {};
     final Map<String, DateTime> _cacheTimestamps = {};
     static const Duration _cacheExpiry = Duration(minutes: 5);
     
     Future<bool> canViewReports() async {
       final cacheKey = 'viewReports';
       if (_isCacheValid(cacheKey)) {
         return _permissionCache[cacheKey]!;
       }
       
       final canView = await _checkViewReportsPermission();
       _permissionCache[cacheKey] = canView;
       _cacheTimestamps[cacheKey] = DateTime.now();
       return canView;
     }
     
     bool _isCacheValid(String key) {
       if (!_permissionCache.containsKey(key)) return false;
       final timestamp = _cacheTimestamps[key];
       if (timestamp == null) return false;
       return DateTime.now().difference(timestamp) < _cacheExpiry;
     }
     
     void clearCache() {
       _permissionCache.clear();
       _cacheTimestamps.clear();
     }
   }
   ```

2. Invalidate cache on permission changes

**Expected Results**:
- ✅ Permission caching works
- ✅ Performance is improved
- ✅ Cache is invalidated correctly

**Test Criteria**:
- Test: Permission caching works
- Test: Cache invalidation works
- Performance test: Performance is improved

---

### Task 7: Add Permission Error Handling

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add comprehensive error handling for permission failures.

**Files to Modify**:
- `lib/core/services/report_permission_service.dart`
- Report controllers

**Implementation Steps**:
1. Create custom permission exceptions:
   ```dart
   class ReportPermissionException implements Exception {
     final String message;
     final String permission;
     
     ReportPermissionException({
       required this.message,
       required this.permission,
     });
   }
   ```

2. Add error handling in controllers:
   ```dart
   try {
     await _permissionService.ensureCanViewReports();
     // ... proceed with operation ...
   } on ReportPermissionException catch (e) {
     SnackbarService().showError(
       title: AppStrings.I.permissionDenied,
       message: e.message,
     );
   } catch (e) {
     SnackbarService().showError(
       title: AppStrings.I.error,
       message: AppStrings.I.unexpectedError,
     );
   }
   ```

3. Use SnackbarService for all error messages

**Expected Results**:
- ✅ Permission error handling works
- ✅ Error messages are clear
- ✅ Errors are handled gracefully

**Test Criteria**:
- Test: Permission errors are handled
- Test: Error messages are clear
- Test: Errors don't crash app

---

### Task 8: Add Permission Audit Log

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add audit logging for permission changes related to reports.

**Files to Create**:
- `lib/features/reports/domain/entities/report_permission_audit_log.dart` (new file)

**Implementation Steps**:
1. Create audit log entity:
   ```dart
   class ReportPermissionAuditLog {
     final String id;
     final String workspaceId;
     final String userId; // User whose permission changed
     final String changedBy; // User who made the change
     final String permission;
     final bool granted; // true if granted, false if revoked
     final DateTime timestamp;
     
     const ReportPermissionAuditLog({
       required this.id,
       required this.workspaceId,
       required this.userId,
       required this.changedBy,
       required this.permission,
       required this.granted,
       required this.timestamp,
     });
     
     // fromMap, toMap methods
   }
   ```

2. Log permission changes:
   ```dart
   Future<void> grantPermission(String userId, String permission) async {
     // Grant permission
     await _grantPermission(userId, permission);
     
     // Log change
     await _logPermissionChange(
       userId: userId,
       permission: permission,
       granted: true,
     );
   }
   ```

**Expected Results**:
- ✅ Permission audit log exists
- ✅ Permission changes are logged
- ✅ Log is accessible for review

**Test Criteria**:
- Test: Permission changes are logged
- Test: Log is accessible
- Test: Log details are accurate

---

### Task 9: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for report access control.

**Files to Create**:
- `test/core/services/report_permission_service_test.dart`
- `test/features/reports/presentation/controllers/report_controller_permission_test.dart`

**Implementation Steps**:
1. Test permission service:
   - Test Account Holder access
   - Test Admin access
   - Test Member access
   - Test permission checks
   - Test caching

2. Test controllers:
   - Test permission checks in controllers
   - Test error handling
   - Test unauthorized access blocking

**Expected Results**:
- ✅ Unit tests cover access control
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Report Permission Service (Critical - Foundation)
2. **Task 2**: Add Permission Checks to Report Controllers (High Priority - Security)
3. **Task 3**: Add Permission Checks to Report UI (High Priority - User Experience)
4. **Task 4**: Create Report Permission Widget (Medium Priority - Reusability)
5. **Task 7**: Add Permission Error Handling (Medium Priority - Quality Assurance)
6. **Task 5**: Add Permission Assignment UI for Reports (Medium Priority - Feature Enhancement)
7. **Task 6**: Add Permission Caching (Medium Priority - Performance)
8. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)
9. **Task 8**: Add Permission Audit Log (Low Priority - Optional Enhancement)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Report permission service exists
- ✅ Permission checks are added to controllers
- ✅ Permission checks are added to UI
- ✅ Account Holder has full access
- ✅ Admin access is permission-based
- ✅ Member access is restricted
- ✅ Permission assignment UI works
- ✅ Permission error handling works
- ✅ Permission caching works (optional)
- ✅ Permission audit log works (optional)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **AccessControlService**: Existing service for permission checks
- **PermissionService**: Existing service for permission management
- **WorkspacePermissions**: Existing permission constants
- **WorkspaceRole**: Existing role enum
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Account Holder**: Should always have full access to all report features. This is the highest authority.

2. **Admin**: Should have permission-based access. Default permissions include `generateReports` and `viewAnalytics`, but can be customized.

3. **Member**: Should have restricted access by default. Members do NOT have `generateReports` or `viewAnalytics` by default, but can be granted these permissions.

4. **Permission Constants**: Use existing `WorkspacePermissions.generateReports` and `WorkspacePermissions.viewAnalytics`.

5. **Workspace Scoping**: All permission checks must be scoped to current workspace for data isolation and security.

6. **Integration**: Integrate with existing permission system (`AccessControlService`, `PermissionService`) rather than creating a separate system.

---

## Related Documentation

- `REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `REPORT_ACCESS_CONTROL_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/user_management/ROLES_PERMISSIONS_TASKS.md` - General roles and permissions
- `docs/v1/feature_checklists/reports/reports.md` - Report requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

