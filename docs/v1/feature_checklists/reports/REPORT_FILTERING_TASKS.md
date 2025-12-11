# Report Filtering (By Workspace/Project/Team/Group/Assignee & Date Range) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Report Filtering** feature (filtering by workspace/project/team/group/assignee and date range). Currently, this feature is **PARTIAL** - `ReportEntity` carries `workspaceId` and `completedTaskIds`; no filtering/query layer shown for project/team/assignee or date range. No UI for scoped filtering.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `ReportEntity` has `workspaceId` field
- ✅ Basic period selector exists in `report_analytics_page.dart` (week/month/quarter dropdown)
- ✅ `firebase_database_service.dart` has some date filtering for reports (`startDate`, `endDate`, `userId`)
- ✅ `getTasksOptimized` has `projectId` and `assigneeId` filters (for tasks, not reports)

### What's Missing/Broken:
- ⛔ No comprehensive filtering UI
- ⛔ No project filtering for reports
- ⛔ No team/group filtering for reports
- ⛔ No assignee filtering for reports
- ⛔ No custom date range picker (only predefined periods)
- ⛔ No filter query layer for reports
- ⛔ No combined filters support
- ⛔ No saved filter configurations
- ⛔ No filter state persistence
- ⛔ No filter validation

---

## Task List

### Task 1: Create Report Filter Model

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create model for report filter configuration.

**Files to Create**:
- `lib/features/reports/domain/entities/report_filter.dart` (new file)

**Implementation Steps**:
1. Create `ReportFilter` model:
   ```dart
   class ReportFilter {
     final String workspaceId; // MANDATORY: Always required
     final String? projectId;
     final String? teamId;
     final String? groupId;
     final String? assigneeId;
     final DateTime? fromDate;
     final DateTime? toDate;
     final String? userId; // For filtering reports by user
     
     const ReportFilter({
       required this.workspaceId,
       this.projectId,
       this.teamId,
       this.groupId,
       this.assigneeId,
       this.fromDate,
       this.toDate,
       this.userId,
     });
     
     factory ReportFilter.fromMap(Map<String, dynamic> map) {
       return ReportFilter(
         workspaceId: map['workspaceId'] ?? '',
         projectId: map['projectId'],
         teamId: map['teamId'],
         groupId: map['groupId'],
         assigneeId: map['assigneeId'],
         fromDate: map['fromDate'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['fromDate'])
             : null,
         toDate: map['toDate'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['toDate'])
             : null,
         userId: map['userId'],
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'workspaceId': workspaceId,
         'projectId': projectId,
         'teamId': teamId,
         'groupId': groupId,
         'assigneeId': assigneeId,
         'fromDate': fromDate?.millisecondsSinceEpoch,
         'toDate': toDate?.millisecondsSinceEpoch,
         'userId': userId,
       };
     }
     
     ReportFilter copyWith({
       String? workspaceId,
       String? projectId,
       String? teamId,
       String? groupId,
       String? assigneeId,
       DateTime? fromDate,
       DateTime? toDate,
       String? userId,
     }) {
       return ReportFilter(
         workspaceId: workspaceId ?? this.workspaceId,
         projectId: projectId ?? this.projectId,
         teamId: teamId ?? this.teamId,
         groupId: groupId ?? this.groupId,
         assigneeId: assigneeId ?? this.assigneeId,
         fromDate: fromDate ?? this.fromDate,
         toDate: toDate ?? this.toDate,
         userId: userId ?? this.userId,
       );
     }
     
     bool get hasFilters => 
         projectId != null ||
         teamId != null ||
         groupId != null ||
         assigneeId != null ||
         fromDate != null ||
         toDate != null ||
         userId != null;
     
     void clearFilters() {
       // Return filter with only workspaceId
       return ReportFilter(workspaceId: workspaceId);
     }
   }
   ```

2. Add validation methods:
   ```dart
   bool isValid() {
     if (workspaceId.isEmpty) return false;
     if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) {
       return false;
     }
     return true;
   }
   
   String? validate() {
     if (workspaceId.isEmpty) return 'Workspace ID is required';
     if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) {
       return 'Start date must be before end date';
     }
     return null;
   }
   ```

**Expected Results**:
- ✅ Report filter model exists
- ✅ Model supports all filter types
- ✅ Validation works
- ✅ Model can be serialized/deserialized

**Test Criteria**:
- Unit test: Test model creation
- Unit test: Test validation
- Unit test: Test serialization/deserialization

---

### Task 2: Create Report Filter Query Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for building and executing filtered queries for reports.

**Files to Create**:
- `lib/core/services/report_filter_service.dart` (new file)

**Implementation Steps**:
1. Create `ReportFilterService`:
   ```dart
   class ReportFilterService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     
     /// Get filtered reports
     Future<List<ReportEntity>> getFilteredReports({
       required ReportFilter filter,
       int? limit,
       String? orderBy = 'createdAt',
       bool ascending = false,
     }) async {
       try {
         // Build query with filters
         final reportsRef = _databaseService._reportsRef(filter.workspaceId);
         Query query = reportsRef;
         
         // Apply workspace filter (always required)
         // Workspace is already scoped by ref path
         
         // Apply date range filter
         if (filter.fromDate != null || filter.toDate != null) {
           query = query.orderByChild('createdAt');
           if (filter.fromDate != null) {
             query = query.startAt(filter.fromDate!.millisecondsSinceEpoch);
           }
           if (filter.toDate != null) {
             query = query.endAt(filter.toDate!.millisecondsSinceEpoch);
           }
         }
         
         // Apply user filter
         if (filter.userId != null) {
           query = query.orderByChild('userId').equalTo(filter.userId);
         }
         
         // Apply ordering
         if (orderBy != null) {
           query = query.orderByChild(orderBy);
         }
         
         // Apply limit
         if (limit != null) {
           query = query.limitToFirst(limit);
         }
         
         final snapshot = await query.get();
         final reports = <ReportEntity>[];
         
         if (snapshot.exists) {
           final data = snapshot.value! as Map<dynamic, dynamic>;
           for (final entry in data.entries) {
             try {
               final report = ReportEntity.fromMap(
                 Map<String, dynamic>.from(entry.value as Map),
               );
               
               // Apply client-side filters (project, team, assignee)
               // Note: These may need to be filtered from task data, not report data
               if (_matchesFilter(report, filter)) {
                 reports.add(report);
               }
             } catch (e) {
               continue;
             }
           }
         }
         
         return reports;
       } catch (e) {
         throw DatabaseFailure(message: 'Failed to get filtered reports: $e');
       }
     }
     
     /// Get filtered tasks (for task-based reports)
     Future<List<TaskEntity>> getFilteredTasks({
       required ReportFilter filter,
       int? limit,
       String? orderBy = 'createdAt',
       bool ascending = false,
     }) async {
       try {
         // Use existing getTasksOptimized with filters
         return await _databaseService.getTasksOptimized(
           workspaceId: filter.workspaceId,
           projectId: filter.projectId,
           assigneeId: filter.assigneeId,
           limit: limit,
           orderBy: orderBy,
           ascending: ascending,
         );
       } catch (e) {
         throw DatabaseFailure(message: 'Failed to get filtered tasks: $e');
       }
     }
     
     bool _matchesFilter(ReportEntity report, ReportFilter filter) {
       // Client-side filtering for fields not in ReportEntity
       // This may need to check task data associated with report
       return true; // Placeholder
     }
   }
   ```

2. Ensure workspace scoping is always enforced

3. Use server-side filtering where possible

**Expected Results**:
- ✅ Report filter service exists
- ✅ Filter queries are built correctly
- ✅ Workspace scoping is enforced
- ✅ Server-side filtering is used where possible

**Test Criteria**:
- Unit test: Test query building
- Unit test: Test filtering logic
- Unit test: Test workspace scoping

---

### Task 3: Create Report Filter Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing report filter state and operations.

**Files to Create**:
- `lib/features/reports/presentation/controllers/report_filter_controller.dart` (new file)

**Implementation Steps**:
1. Create `ReportFilterController`:
   ```dart
   class ReportFilterController extends GetxController {
     final ReportFilterService _filterService = Get.find<ReportFilterService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     final Rx<ReportFilter> _currentFilter = Rx<ReportFilter>(
       ReportFilter(workspaceId: ''), // Will be set on init
     );
     final RxList<Project> _projects = <Project>[].obs;
     final RxList<Team> _teams = <Team>[].obs;
     final RxList<User> _assignees = <User>[].obs;
     final RxBool _isLoading = false.obs;
     
     ReportFilter get currentFilter => _currentFilter.value;
     List<Project> get projects => _projects;
     List<Team> get teams => _teams;
     List<User> get assignees => _assignees;
     bool get isLoading => _isLoading.value;
     
     @override
     void onInit() {
       super.onInit();
       _initializeFilter();
       _loadFilterOptions();
     }
     
     void _initializeFilter() {
       final workspaceId = _storageService.getWorkspaceId();
       if (workspaceId != null) {
         _currentFilter.value = ReportFilter(workspaceId: workspaceId);
       }
     }
     
     Future<void> _loadFilterOptions() async {
       try {
         _isLoading.value = true;
         final workspaceId = _storageService.getWorkspaceId();
         if (workspaceId == null) return;
         
         // Load projects, teams, assignees for current workspace
         // Use existing services/repositories
         // _projects.value = await _projectRepository.listProjects(workspaceId);
         // _teams.value = await _teamRepository.listTeams(workspaceId);
         // _assignees.value = await _userRepository.listUsers(workspaceId);
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.failedToLoadFilters,
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> setProjectFilter(String? projectId) async {
       _currentFilter.value = _currentFilter.value.copyWith(projectId: projectId);
       await _applyFilter();
     }
     
     Future<void> setTeamFilter(String? teamId) async {
       _currentFilter.value = _currentFilter.value.copyWith(teamId: teamId);
       await _applyFilter();
     }
     
     Future<void> setAssigneeFilter(String? assigneeId) async {
       _currentFilter.value = _currentFilter.value.copyWith(assigneeId: assigneeId);
       await _applyFilter();
     }
     
     Future<void> setDateRange(DateTime? fromDate, DateTime? toDate) async {
       _currentFilter.value = _currentFilter.value.copyWith(
         fromDate: fromDate,
         toDate: toDate,
       );
       await _applyFilter();
     }
     
     Future<void> clearFilters() async {
       final workspaceId = _storageService.getWorkspaceId();
       if (workspaceId != null) {
         _currentFilter.value = ReportFilter(workspaceId: workspaceId);
         await _applyFilter();
       }
     }
     
     Future<void> _applyFilter() async {
       // Notify listeners that filter changed
       update();
       // Trigger report reload in other controllers
       Get.find<OverviewReportController>().loadOverviewReport();
     }
     
     bool validateFilter() {
       final error = _currentFilter.value.validate();
       if (error != null) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: error,
         );
         return false;
       }
       return true;
     }
   }
   ```

2. Use GetX for state management

3. Use SnackbarService and AppStrings

**Expected Results**:
- ✅ Report filter controller exists
- ✅ Filter state is managed
- ✅ Filter options are loaded
- ✅ Filter operations work correctly

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test filter state management
- Test: Test filter validation

---

### Task 4: Create Report Filter UI Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for displaying and interacting with report filters.

**Files to Create**:
- `lib/features/reports/presentation/widgets/report_filter_widget.dart` (new file)

**Implementation Steps**:
1. Create `ReportFilterWidget`:
   ```dart
   class ReportFilterWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<ReportFilterController>();
       
       return GetBuilder<ReportFilterController>(
         builder: (ctrl) {
           return TDCard(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       AppStrings.filters,
                       style: AppTextStyles.heading,
                     ),
                     TDButton(
                       text: AppStrings.clearFilters,
                       onPressed: () => ctrl.clearFilters(),
                       variant: TDButtonVariant.outlined,
                       icon: Icons.clear,
                     ),
                   ],
                 ),
                 SizedBox(height: AppSpacing.md),
                 
                 // Project filter
                 TDTextField(
                   label: AppStrings.project,
                   readOnly: true,
                   controller: TextEditingController(
                     text: ctrl.currentFilter.projectId != null
                         ? _getProjectName(ctrl.currentFilter.projectId!)
                         : AppStrings.allProjects,
                   ),
                   onTap: () => _showProjectPicker(ctrl),
                   suffixIcon: Icons.arrow_drop_down,
                 ),
                 SizedBox(height: AppSpacing.sm),
                 
                 // Team filter
                 TDTextField(
                   label: AppStrings.team,
                   readOnly: true,
                   controller: TextEditingController(
                     text: ctrl.currentFilter.teamId != null
                         ? _getTeamName(ctrl.currentFilter.teamId!)
                         : AppStrings.allTeams,
                   ),
                   onTap: () => _showTeamPicker(ctrl),
                   suffixIcon: Icons.arrow_drop_down,
                 ),
                 SizedBox(height: AppSpacing.sm),
                 
                 // Assignee filter
                 TDTextField(
                   label: AppStrings.assignee,
                   readOnly: true,
                   controller: TextEditingController(
                     text: ctrl.currentFilter.assigneeId != null
                         ? _getAssigneeName(ctrl.currentFilter.assigneeId!)
                         : AppStrings.allAssignees,
                   ),
                   onTap: () => _showAssigneePicker(ctrl),
                   suffixIcon: Icons.arrow_drop_down,
                 ),
                 SizedBox(height: AppSpacing.sm),
                 
                 // Date range filter
                 Row(
                   children: [
                     Expanded(
                       child: TDTextField(
                         label: AppStrings.fromDate,
                         readOnly: true,
                         controller: TextEditingController(
                           text: ctrl.currentFilter.fromDate != null
                               ? _formatDate(ctrl.currentFilter.fromDate!)
                               : AppStrings.selectDate,
                         ),
                         onTap: () => _selectFromDate(ctrl),
                         suffixIcon: Icons.calendar_today,
                       ),
                     ),
                     SizedBox(width: AppSpacing.sm),
                     Expanded(
                       child: TDTextField(
                         label: AppStrings.toDate,
                         readOnly: true,
                         controller: TextEditingController(
                           text: ctrl.currentFilter.toDate != null
                               ? _formatDate(ctrl.currentFilter.toDate!)
                               : AppStrings.selectDate,
                         ),
                         onTap: () => _selectToDate(ctrl),
                         suffixIcon: Icons.calendar_today,
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: AppSpacing.sm),
                 
                 // Quick date range buttons
                 Wrap(
                   spacing: AppSpacing.xs,
                   children: [
                     TDButton(
                       text: AppStrings.last7Days,
                       onPressed: () => _setQuickDateRange(ctrl, 7),
                       variant: TDButtonVariant.outlined,
                     ),
                     TDButton(
                       text: AppStrings.last30Days,
                       onPressed: () => _setQuickDateRange(ctrl, 30),
                       variant: TDButtonVariant.outlined,
                     ),
                     TDButton(
                       text: AppStrings.last90Days,
                       onPressed: () => _setQuickDateRange(ctrl, 90),
                       variant: TDButtonVariant.outlined,
                     ),
                   ],
                 ),
               ],
             ),
           );
         },
       );
     }
     
     void _showProjectPicker(ReportFilterController ctrl) async {
       // Show project picker dialog
       final selected = await showDialog<String>(
         context: Get.context!,
         builder: (context) => _ProjectPickerDialog(projects: ctrl.projects),
       );
       if (selected != null) {
         await ctrl.setProjectFilter(selected);
       }
     }
     
     void _setQuickDateRange(ReportFilterController ctrl, int days) {
       final toDate = DateTime.now();
       final fromDate = toDate.subtract(Duration(days: days));
       ctrl.setDateRange(fromDate, toDate);
     }
     
     // Similar methods for team, assignee, date selection
   }
   ```

2. Use TD widgets and AppStrings

3. Add validation feedback

**Expected Results**:
- ✅ Report filter widget exists
- ✅ All filter options are displayed
- ✅ Filter interactions work
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test filter widget
- Manual test: Test filter interactions
- Test: Verify UI follows project rules

---

### Task 5: Integrate Filters with Overview Report Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `OverviewReportController` to use filters from `ReportFilterController`.

**Files to Modify**:
- `lib/features/reports/presentation/controllers/overview_report_controller.dart`

**Implementation Steps**:
1. Inject `ReportFilterController`:
   ```dart
   class OverviewReportController extends GetxController {
     final GenerateOverviewReport _generateReport;
     final ReportFilterController _filterController = Get.find<ReportFilterController>();
     // ... existing code ...
   }
   ```

2. Update `loadOverviewReport()` to use filters:
   ```dart
   Future<void> loadOverviewReport() async {
     try {
       _isLoading.value = true;
       
       final filter = _filterController.currentFilter;
       if (!filter.validate()) {
         return;
       }
       
       final result = await _generateReport(
         workspaceId: filter.workspaceId,
         fromDate: filter.fromDate,
         toDate: filter.toDate,
         projectId: filter.projectId,
         assigneeId: filter.assigneeId,
         teamId: filter.teamId,
       );
       
       // ... rest of method ...
     } catch (e) {
       // ... error handling ...
     } finally {
       _isLoading.value = false;
     }
   }
   ```

3. Listen to filter changes:
   ```dart
   @override
   void onInit() {
     super.onInit();
     // Listen to filter changes
     ever(_filterController._currentFilter, (_) {
       loadOverviewReport();
     });
   }
   ```

**Expected Results**:
- ✅ Overview report uses filters
- ✅ Report updates when filters change
- ✅ Filters are applied correctly

**Test Criteria**:
- Test: Overview report uses filters
- Test: Report updates when filters change

---

### Task 6: Integrate Filters with Report Analytics Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add filter widget to report analytics page.

**Files to Modify**:
- `lib/app/pages/reports/report_analytics_page.dart`

**Implementation Steps**:
1. Add filter widget to page:
   ```dart
   body: Column(
     children: [
       // Filter widget
       ReportFilterWidget(),
       
       // Period selector (keep for backward compatibility or remove)
       // ... existing period selector ...
       
       // Analytics content
       Expanded(
         child: SingleChildScrollView(
           // ... existing content ...
         ),
       ),
     ],
   ),
   ```

2. Initialize filter controller:
   ```dart
   @override
   void initState() {
     super.initState();
     Get.put(ReportFilterController());
     _loadAnalytics();
   }
   ```

3. Update `_loadAnalytics()` to use filters

**Expected Results**:
- ✅ Filter widget is displayed in report analytics page
- ✅ Filters work correctly
- ✅ Analytics update when filters change

**Test Criteria**:
- Manual test: View report analytics page
- Test: Verify filters are displayed
- Test: Verify filters work

---

### Task 7: Add Saved Filter Configurations

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add ability to save and load filter configurations.

**Files to Create**:
- `lib/features/reports/domain/entities/saved_report_filter.dart` (new file)
- `lib/features/reports/data/repositories/saved_filter_repository.dart` (new file)

**Implementation Steps**:
1. Create `SavedReportFilter` entity:
   ```dart
   class SavedReportFilter {
     final String id;
     final String workspaceId;
     final String userId;
     final String name;
     final ReportFilter filter;
     final DateTime createdAt;
     
     const SavedReportFilter({
       required this.id,
       required this.workspaceId,
       required this.userId,
       required this.name,
       required this.filter,
       required this.createdAt,
     });
     
     // fromMap, toMap, copyWith methods
   }
   ```

2. Create repository for saved filters

3. Add save/load methods to `ReportFilterController`:
   ```dart
   Future<void> saveFilter(String name) async {
     final savedFilter = SavedReportFilter(
       id: uuid.v4(),
       workspaceId: _currentFilter.value.workspaceId,
       userId: _storageService.getUserId()!,
       name: name,
       filter: _currentFilter.value,
       createdAt: DateTime.now(),
     );
     await _savedFilterRepository.save(savedFilter);
   }
   
   Future<void> loadSavedFilter(String savedFilterId) async {
     final savedFilter = await _savedFilterRepository.getById(savedFilterId);
     if (savedFilter != null) {
       _currentFilter.value = savedFilter.filter;
       await _applyFilter();
     }
   }
   ```

**Expected Results**:
- ✅ Saved filter configurations exist
- ✅ Filters can be saved and loaded
- ✅ Saved filters are persisted

**Test Criteria**:
- Test: Save filter configuration
- Test: Load saved filter
- Test: Delete saved filter

---

### Task 8: Add Filter State Persistence

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Persist filter state across page navigation and app restarts.

**Files to Modify**:
- `lib/features/reports/presentation/controllers/report_filter_controller.dart`

**Implementation Steps**:
1. Save filter state to storage:
   ```dart
   Future<void> _saveFilterState() async {
     final storageService = Get.find<StorageService>();
     await storageService.setString(
       'report_filter_state',
       jsonEncode(_currentFilter.value.toMap()),
     );
   }
   ```

2. Load filter state on init:
   ```dart
   void _loadFilterState() async {
     final storageService = Get.find<StorageService>();
     final saved = await storageService.getString('report_filter_state');
     if (saved != null) {
       try {
         final map = jsonDecode(saved) as Map<String, dynamic>;
         _currentFilter.value = ReportFilter.fromMap(map);
       } catch (e) {
         // Use default filter
       }
     }
   }
   ```

3. Save state whenever filter changes

**Expected Results**:
- ✅ Filter state persists
- ✅ Filters are preserved across navigation
- ✅ User experience is improved

**Test Criteria**:
- Test: Filter state persists across navigation
- Test: Filter state persists across app restart

---

### Task 9: Add Filter Validation

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add validation for filter inputs.

**Files to Modify**:
- `lib/features/reports/domain/entities/report_filter.dart`
- `lib/features/reports/presentation/widgets/report_filter_widget.dart`

**Implementation Steps**:
1. Enhance validation in `ReportFilter`:
   ```dart
   String? validate() {
     if (workspaceId.isEmpty) {
       return AppStrings.workspaceIdRequired;
     }
     if (fromDate != null && toDate != null) {
       if (fromDate!.isAfter(toDate!)) {
         return AppStrings.startDateMustBeBeforeEndDate;
       }
       if (toDate!.difference(fromDate!).inDays > 365) {
         return AppStrings.dateRangeTooLarge;
       }
     }
     return null;
   }
   ```

2. Show validation errors in UI:
   ```dart
   // In filter widget
   if (ctrl.currentFilter.validate() != null) {
     Text(
       ctrl.currentFilter.validate()!,
       style: AppTextStyles.error,
     ),
   }
   ```

3. Prevent applying invalid filters

**Expected Results**:
- ✅ Filter validation works
- ✅ Validation errors are shown
- ✅ Invalid filters are rejected

**Test Criteria**:
- Test: Invalid date range is rejected
- Test: Validation errors are shown
- Test: Invalid filters are not applied

---

### Task 10: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for filtering functionality.

**Files to Create**:
- `test/features/reports/domain/entities/report_filter_test.dart`
- `test/core/services/report_filter_service_test.dart`
- `test/features/reports/presentation/controllers/report_filter_controller_test.dart`

**Implementation Steps**:
1. Test filter model:
   - Test creation
   - Test validation
   - Test serialization

2. Test filter service:
   - Test query building
   - Test filtering logic
   - Test workspace scoping

3. Test filter controller:
   - Test filter state management
   - Test filter operations
   - Test validation

**Expected Results**:
- ✅ Unit tests cover filtering
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Report Filter Model (Critical - Foundation)
2. **Task 2**: Create Report Filter Query Service (Critical - Core Logic)
3. **Task 3**: Create Report Filter Controller (High Priority - State Management)
4. **Task 4**: Create Report Filter UI Widget (High Priority - User Experience)
5. **Task 5**: Integrate Filters with Overview Report Controller (High Priority - Integration)
6. **Task 6**: Integrate Filters with Report Analytics Page (High Priority - UI Integration)
7. **Task 9**: Add Filter Validation (Medium Priority - Quality Assurance)
8. **Task 7**: Add Saved Filter Configurations (Medium Priority - Feature Enhancement)
9. **Task 8**: Add Filter State Persistence (Medium Priority - UX Enhancement)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Report filter model exists
- ✅ Filter query service exists
- ✅ Filter controller exists
- ✅ Filter UI widget exists
- ✅ Filters are integrated with overview report
- ✅ Filters are integrated with report analytics page
- ✅ Filter validation works
- ✅ Saved filter configurations work (optional)
- ✅ Filter state persists (optional)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing and querying filtered reports
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **Task Aggregation**: From Report Overview Aggregation feature
- **Project/Team/User Repositories**: Required for loading filter options

---

## Notes

1. **Workspace Scoping**: Critical to always enforce workspace scoping in all filters for data isolation and security.

2. **Server-Side vs Client-Side Filtering**: Use server-side filtering where possible (date range, userId) and client-side filtering for fields not in ReportEntity (project, team, assignee may need to filter from task data).

3. **Filter Integration**: Filters need to be integrated with:
   - Report aggregation
   - Charts
   - Task statistics
   - Query layer

4. **Existing Period Selector**: Basic period selector exists in `report_analytics_page.dart`. Can keep for quick selection or replace with full filter widget.

5. **Filter State**: Consider persisting filter state for better UX, but ensure workspace changes reset filters.

---

## Related Documentation

- `REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `REPORT_FILTERING_TEST_CASES.md` - Test cases for this feature
- `REPORT_OVERVIEW_AGGREGATION_TASKS.md` - Overview aggregation feature (integration point)
- `docs/v1/feature_checklists/reports/reports.md` - Report requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

