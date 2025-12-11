# Task Statistics & Filtering (Status/Priority/Assignee/Tag/Workspace/Project/Team) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Task Statistics & Filtering** feature (status/priority/assignee/tag/workspace/project/team). Currently, this feature is **PARTIAL** - pagination/filter basics exist but tag/team filters are missing, workspace filter guard not confirmed, and sorting/filter UIs not evident.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `PaginatedTaskController` exists with pagination support
- ✅ `FirebaseDatabaseService.getPaginatedTasks()` supports filtering by status, priority, type, projectId, assigneeId
- ✅ Basic filter logic exists in controllers
- ✅ `ProjectStatistics` exists for project-level statistics
- ✅ `workspaceId` field exists in TaskEntity

### What's Missing/Broken:
- ⛔ Tag filter - no tag filtering support (requires tags feature)
- ⛔ Team filter - no team filtering support (requires team assignment feature)
- ⛔ Workspace filter guard - not confirmed to be enforced globally
- ⛔ Filter UI - filter UI components not evident
- ⛔ Sort UI - sorting UI not evident
- ⛔ Workspace statistics - no workspace-level statistics
- ⛔ Team statistics - no team-level statistics
- ⛔ Comprehensive statistics dashboard - limited statistics

---

## Task List

### Task 1: Add Tag Filter to FirebaseDatabaseService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add tag filtering support to `FirebaseDatabaseService.getPaginatedTasks()` (requires tags feature to be implemented first).

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Update `getPaginatedTasks` method signature:
   ```dart
   Future<pagination.PaginatedResult<TaskEntity>> getPaginatedTasks({
     required String workspaceId,
     // ... existing parameters ...
     List<String>? tags, // Add tag filter
   }) async {
     // ...
   }
   ```

2. Add tag filter to filters map:
   ```dart
   final filters = <String, dynamic>{};
   // ... existing filters ...
   if (tags != null && tags.isNotEmpty) {
     // Filter tasks that have any of the specified tags
     // Note: Firebase Realtime DB doesn't support array-contains-any directly
     // May need to filter client-side or use a different approach
   }
   ```

3. Handle tag filtering:
   - Option 1: Filter client-side after fetching
   - Option 2: Use Firebase query with array-contains (if single tag)
   - Option 3: Create index for tags

**Expected Results**:
- ✅ Tag filter is added to getPaginatedTasks
- ✅ Tasks can be filtered by tags
- ✅ Filter works correctly

**Test Criteria**:
- Test: Filter tasks by tags
- Test: Verify filter works with multiple tags

**Note**: This requires tags feature to be implemented first (see TASK_CRUD_DETAILS_TASKS.md).

---

### Task 2: Add Team Filter to FirebaseDatabaseService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add team filtering support to `FirebaseDatabaseService.getPaginatedTasks()` (requires team assignment feature to be implemented first).

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Update `getPaginatedTasks` method signature:
   ```dart
   Future<pagination.PaginatedResult<TaskEntity>> getPaginatedTasks({
     required String workspaceId,
     // ... existing parameters ...
     String? teamId, // Add team filter
   }) async {
     // ...
   }
   ```

2. Add team filter to filters map:
   ```dart
   final filters = <String, dynamic>{};
   // ... existing filters ...
   if (teamId != null) {
     filters['teamId'] = teamId;
   }
   ```

3. Update Firebase query to filter by teamId

**Expected Results**:
- ✅ Team filter is added to getPaginatedTasks
- ✅ Tasks can be filtered by team
- ✅ Filter works correctly

**Test Criteria**:
- Test: Filter tasks by team
- Test: Verify filter works correctly

**Note**: This requires team assignment feature to be implemented first (see TASK_ASSIGNMENT_TASKS.md).

---

### Task 3: Enforce Workspace Filter Guard Globally

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure workspaceId is enforced in all task operations to prevent cross-workspace data access.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`
- All task-related controllers and services

**Implementation Steps**:
1. Review all task operations:
   - Task list queries
   - Task create
   - Task update
   - Task delete
   - Task filters
   - Task statistics

2. Ensure workspaceId is always included:
   ```dart
   // In all task queries:
   final tasksRef = _tasksRef(workspaceId); // Always use workspaceId
   
   // In all task operations:
   if (task.workspaceId != workspaceId) {
     throw WorkspaceMismatchException('Task does not belong to workspace');
   }
   ```

3. Add validation to all methods:
   ```dart
   Future<TaskEntity> updateTask({
     required String workspaceId,
     required TaskEntity task,
   }) async {
     // Validate workspace
     if (task.workspaceId != workspaceId) {
       throw WorkspaceMismatchException('Task workspace mismatch');
     }
     // ... rest of method
   }
   ```

4. Add workspace validation to filters:
   ```dart
   Future<List<TaskEntity>> getTasks({
     required String workspaceId,
     // ... filters ...
   }) async {
     // Always filter by workspaceId first
     final tasksRef = _tasksRef(workspaceId);
     // ... apply other filters
   }
   ```

**Expected Results**:
- ✅ WorkspaceId is enforced in all operations
- ✅ Cross-workspace access is prevented
- ✅ All queries include workspaceId
- ✅ Validation errors are thrown for mismatches

**Test Criteria**:
- Test: Verify workspaceId is included in all queries
- Test: Verify cross-workspace access is prevented
- Test: Verify validation works correctly

---

### Task 4: Create Task Filter Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for managing task filters and building filter queries.

**Files to Create**:
- `lib/core/services/task_filter_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskFilterService`:
   ```dart
   class TaskFilterService {
     /// Build filter map for Firebase query
     Map<String, dynamic> buildFilters({
       TaskStatus? status,
       TaskPriority? priority,
       TaskType? type,
       String? projectId,
       String? assigneeId,
       String? teamId,
       List<String>? tags,
     }) {
       final filters = <String, dynamic>{};
       if (status != null) filters['status'] = status.value;
       if (priority != null) filters['priority'] = priority.value;
       if (type != null) filters['taskType'] = type.value;
       if (projectId != null) filters['projectId'] = projectId;
       if (assigneeId != null) filters['assignee'] = assigneeId;
       if (teamId != null) filters['teamId'] = teamId;
       // Tags filtering may need special handling
       return filters;
     }
     
     /// Validate filters
     bool validateFilters(Map<String, dynamic> filters) {
       // Validate filter values
       return true;
     }
     
     /// Build cache key from filters
     String buildCacheKey({
       required String workspaceId,
       TaskStatus? status,
       TaskPriority? priority,
       TaskType? type,
       String? projectId,
       String? assigneeId,
       String? teamId,
       List<String>? tags,
     }) {
       final parts = <String>['tasks', workspaceId];
       if (status != null) parts.add('status:${status.value}');
       if (priority != null) parts.add('priority:${priority.value}');
       if (type != null) parts.add('type:${type.value}');
       if (projectId != null) parts.add('project:$projectId');
       if (assigneeId != null) parts.add('assignee:$assigneeId');
       if (teamId != null) parts.add('team:$teamId');
       if (tags != null && tags.isNotEmpty) {
         parts.add('tags:${tags.join(',')}');
       }
       return parts.join('_');
     }
   }
   ```

2. Use service in controllers and FirebaseDatabaseService

**Expected Results**:
- ✅ Filter service exists
- ✅ Filter building is centralized
- ✅ Cache key building is centralized

**Test Criteria**:
- Unit test: Test filter building
- Test: Verify cache keys are correct

---

### Task 5: Create Task Filter Model

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create model class to represent task filters.

**Files to Create**:
- `lib/features/tasks/domain/models/task_filter.dart` (new file)

**Implementation Steps**:
1. Create `TaskFilter` model:
   ```dart
   class TaskFilter {
     final TaskStatus? status;
     final TaskPriority? priority;
     final TaskType? type;
     final String? projectId;
     final String? assigneeId;
     final String? teamId;
     final List<String>? tags;
     final String? searchQuery;
     final String? sortBy;
     final bool ascending;
     
     const TaskFilter({
       this.status,
       this.priority,
       this.type,
       this.projectId,
       this.assigneeId,
       this.teamId,
       this.tags,
       this.searchQuery,
       this.sortBy,
       this.ascending = false,
     });
     
     TaskFilter copyWith({
       TaskStatus? status,
       TaskPriority? priority,
       TaskType? type,
       String? projectId,
       String? assigneeId,
       String? teamId,
       List<String>? tags,
       String? searchQuery,
       String? sortBy,
       bool? ascending,
     }) {
       return TaskFilter(
         status: status ?? this.status,
         priority: priority ?? this.priority,
         type: type ?? this.type,
         projectId: projectId ?? this.projectId,
         assigneeId: assigneeId ?? this.assigneeId,
         teamId: teamId ?? this.teamId,
         tags: tags ?? this.tags,
         searchQuery: searchQuery ?? this.searchQuery,
         sortBy: sortBy ?? this.sortBy,
         ascending: ascending ?? this.ascending,
       );
     }
     
     bool get hasFilters {
       return status != null ||
           priority != null ||
           type != null ||
           projectId != null ||
           assigneeId != null ||
           teamId != null ||
           (tags != null && tags!.isNotEmpty) ||
           (searchQuery != null && searchQuery!.isNotEmpty);
     }
   }
   ```

2. Use model in controllers

**Expected Results**:
- ✅ TaskFilter model exists
- ✅ Model represents all filter options
- ✅ Model is easy to use

**Test Criteria**:
- Unit test: Test TaskFilter model
- Test: Verify hasFilters works correctly

---

### Task 6: Update PaginatedTaskController with Filter Model

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `PaginatedTaskController` to use `TaskFilter` model.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`

**Implementation Steps**:
1. Import TaskFilter:
   ```dart
   import 'package:todolist/features/tasks/domain/models/task_filter.dart';
   ```

2. Add filter observable:
   ```dart
   final Rx<TaskFilter> _currentFilter = TaskFilter().obs;
   TaskFilter get currentFilter => _currentFilter.value;
   ```

3. Update loadTasks method:
   ```dart
   Future<void> loadTasks({
     TaskFilter? filter,
     int page = 1,
     int pageSize = 20,
   }) async {
     final effectiveFilter = filter ?? _currentFilter.value;
     _currentFilter.value = effectiveFilter;
     
     // Use filter in query
     final result = await _databaseService.getPaginatedTasks(
       workspaceId: workspaceId,
       status: effectiveFilter.status,
       priority: effectiveFilter.priority,
       type: effectiveFilter.type,
       projectId: effectiveFilter.projectId,
       assigneeId: effectiveFilter.assigneeId,
       teamId: effectiveFilter.teamId,
       tags: effectiveFilter.tags,
       // ... other parameters
     );
   }
   ```

4. Add filter methods:
   ```dart
   Future<void> applyFilter(TaskFilter filter) async {
     _currentFilter.value = filter;
     await loadTasks(filter: filter);
   }
   
   Future<void> clearFilter() async {
     _currentFilter.value = TaskFilter();
     await loadTasks();
   }
   ```

**Expected Results**:
- ✅ Controller uses TaskFilter model
- ✅ Filter management is centralized
- ✅ Filter methods work correctly

**Test Criteria**:
- Unit test: Test filter methods
- Test: Verify filter is applied correctly

---

### Task 7: Create Task Filter UI Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for task filtering.

**Files to Create**:
- `lib/app/widgets/task_filter_panel.dart` (new file)

**Implementation Steps**:
1. Create `TaskFilterPanel` widget:
   ```dart
   class TaskFilterPanel extends StatelessWidget {
     final TaskFilter initialFilter;
     final Function(TaskFilter) onFilterChanged;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         children: [
           _buildStatusFilter(),
           _buildPriorityFilter(),
           _buildTypeFilter(),
           _buildAssigneeFilter(),
           _buildProjectFilter(),
           _buildTeamFilter(), // If team assignment is implemented
           _buildTagFilter(), // If tags feature is implemented
           _buildSearchField(),
           _buildActions(),
         ],
       );
     }
   }
   ```

2. Add filter dropdowns:
   - Status dropdown (using TaskStatus enum)
   - Priority dropdown (using TaskPriority enum)
   - Type dropdown (using TaskType enum)
   - Assignee dropdown (list of workspace members)
   - Project dropdown (list of workspace projects)
   - Team dropdown (if team assignment is implemented)
   - Tag selector (if tags feature is implemented)

3. Add search field:
   - Text field for searching tasks

4. Add action buttons:
   - "Apply" button
   - "Clear" button
   - "Reset" button

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Filter panel widget exists
- ✅ All filter options are available
- ✅ Filter panel is intuitive
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test filter panel
- Manual test: Use filter panel

---

### Task 8: Create Task Sort UI Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for task sorting.

**Files to Create**:
- `lib/app/widgets/task_sort_panel.dart` (new file)

**Implementation Steps**:
1. Create `TaskSortPanel` widget:
   ```dart
   class TaskSortPanel extends StatelessWidget {
     final String? currentSortBy;
     final bool ascending;
     final Function(String?, bool) onSortChanged;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         children: [
           _buildSortBySelector(),
           _buildSortOrderSelector(),
           _buildActions(),
         ],
       );
     }
   }
   ```

2. Add sort by selector:
   - Dropdown with options:
     - Title
     - Status
     - Priority
     - Due Date
     - Created Date
     - Updated Date

3. Add sort order selector:
   - Radio buttons or toggle:
     - Ascending
     - Descending

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Sort panel widget exists
- ✅ All sort options are available
- ✅ Sort panel is intuitive
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test sort panel
- Manual test: Use sort panel

---

### Task 9: Add Filter UI to Task List Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add filter UI components to task list page.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/pages/task_list_page.dart`

**Implementation Steps**:
1. Add filter button to app bar:
   ```dart
   AppBar(
     actions: [
       IconButton(
         icon: Icon(Icons.filter_list),
         onPressed: () => _showFilterPanel(),
       ),
     ],
   )
   ```

2. Add filter panel:
   - Show filter panel as bottom sheet or drawer
   - Use `TaskFilterPanel` widget
   - Connect to controller filter methods

3. Add active filters indicator:
   - Show active filters as chips
   - Allow removing individual filters

4. Add sort button:
   - Show sort panel
   - Use `TaskSortPanel` widget

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Filter UI is added to task list
- ✅ Filter panel is accessible
- ✅ Active filters are shown
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Use filter UI
- Test: Verify filters are applied

---

### Task 10: Add Search to Task List Page

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add search functionality to task list page.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`

**Implementation Steps**:
1. Add search field to task list:
   ```dart
   TextField(
     controller: _searchController,
     decoration: InputDecoration(
       hintText: AppStrings.searchTasks,
       prefixIcon: Icon(Icons.search),
     ),
     onChanged: (query) {
       _applySearch(query);
     },
   )
   ```

2. Implement search logic:
   ```dart
   void _applySearch(String query) {
     // Filter tasks by title/description/tags
     // Update task list
   }
   ```

3. Add search to filter model:
   - Include searchQuery in TaskFilter

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Search field exists
- ✅ Search works correctly
- ✅ Search includes title, description, tags

**Test Criteria**:
- Manual test: Search tasks
- Test: Verify search works

---

### Task 11: Create Task Statistics Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for calculating task statistics.

**Files to Create**:
- `lib/core/services/task_statistics_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskStatisticsService`:
   ```dart
   class TaskStatisticsService {
     final FirebaseDatabaseService _databaseService;
     
     TaskStatisticsService(this._databaseService);
     
     Future<TaskStatistics> getWorkspaceStatistics({
       required String workspaceId,
     }) async {
       // Get all tasks in workspace
       // Calculate statistics
       // Return TaskStatistics
     }
     
     Future<TaskStatistics> getProjectStatistics({
       required String workspaceId,
       required String projectId,
     }) async {
       // Get all tasks in project
       // Calculate statistics
       // Return TaskStatistics
     }
     
     Future<TaskStatistics> getTeamStatistics({
       required String workspaceId,
       required String teamId,
     }) async {
       // Get all tasks assigned to team
       // Calculate statistics
       // Return TaskStatistics
     }
   }
   ```

2. Create `TaskStatistics` model:
   ```dart
   class TaskStatistics {
     final int totalTasks;
     final int completedTasks;
     final int pendingTasks;
     final int inProgressTasks;
     final int cancelledTasks;
     final int overdueTasks;
     final double completionRate;
     final Map<TaskStatus, int> statusBreakdown;
     final Map<TaskPriority, int> priorityBreakdown;
     final Map<TaskType, int> typeBreakdown;
   }
   ```

**Expected Results**:
- ✅ Statistics service exists
- ✅ Statistics can be calculated for workspace/project/team
- ✅ Statistics are accurate

**Test Criteria**:
- Unit test: Test statistics calculation
- Test: Verify statistics are accurate

---

### Task 12: Create Get Workspace Statistics Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to get workspace-level task statistics.

**Files to Create**:
- `lib/features/tasks/domain/usecases/get_workspace_statistics.dart` (new file)

**Implementation Steps**:
1. Create `GetWorkspaceStatistics` use case:
   ```dart
   class GetWorkspaceStatistics {
     final TaskStatisticsService _statisticsService;
     
     GetWorkspaceStatistics(this._statisticsService);
     
     Future<Either<Failure, TaskStatistics>> call({
       required String workspaceId,
     }) async {
       // 1. Validate workspace exists
       // 2. Get workspace statistics
       // 3. Return statistics
     }
   }
   ```

2. Add validation

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Workspace statistics are calculated
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test use case
- Test: Verify statistics are calculated

---

### Task 13: Create Get Team Statistics Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to get team-level task statistics (requires team assignment feature).

**Files to Create**:
- `lib/features/tasks/domain/usecases/get_team_statistics.dart` (new file)

**Implementation Steps**:
1. Create `GetTeamStatistics` use case similar to `GetWorkspaceStatistics`

2. Filter tasks by teamId

3. Calculate team-specific statistics

**Expected Results**:
- ✅ Use case exists
- ✅ Team statistics are calculated
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test use case
- Test: Verify statistics are calculated

**Note**: This requires team assignment feature to be implemented first.

---

### Task 14: Create Task Statistics Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create GetX controller for managing task statistics.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/task_statistics_controller.dart` (new file)

**Implementation Steps**:
1. Create `TaskStatisticsController`:
   ```dart
   class TaskStatisticsController extends GetxController {
     final GetWorkspaceStatistics _getWorkspaceStatistics;
     final GetProjectStatistics _getProjectStatistics;
     final GetTeamStatistics _getTeamStatistics;
     
     final Rx<TaskStatistics?> _workspaceStatistics = Rx<TaskStatistics?>(null);
     final RxMap<String, TaskStatistics> _projectStatistics = <String, TaskStatistics>{}.obs;
     final RxMap<String, TaskStatistics> _teamStatistics = <String, TaskStatistics>{}.obs;
     final RxBool _isLoading = false.obs;
     
     TaskStatistics? get workspaceStatistics => _workspaceStatistics.value;
     bool get isLoading => _isLoading.value;
     
     Future<void> loadWorkspaceStatistics(String workspaceId) async {
       // Load workspace statistics
     }
     
     Future<void> loadProjectStatistics(String projectId) async {
       // Load project statistics
     }
     
     Future<void> loadTeamStatistics(String teamId) async {
       // Load team statistics
     }
   }
   ```

2. Add error handling

3. Add caching (optional)

**Expected Results**:
- ✅ Statistics controller exists
- ✅ Statistics can be loaded
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify statistics are loaded

---

### Task 15: Create Task Statistics Dashboard UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create comprehensive task statistics dashboard UI.

**Files to Create**:
- `lib/app/pages/tasks/task_statistics_dashboard_page.dart` (new file)

**Implementation Steps**:
1. Create `TaskStatisticsDashboardPage`:
   ```dart
   class TaskStatisticsDashboardPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return GetBuilder<TaskStatisticsController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.taskStatistics,
           ),
           body: SingleChildScrollView(
             child: Column(
               children: [
                 _buildOverviewSection(controller),
                 _buildStatusDistributionChart(controller),
                 _buildPriorityDistributionChart(controller),
                 _buildAssigneeDistributionChart(controller),
                 _buildProjectDistributionChart(controller),
                 _buildTeamDistributionChart(controller), // If team assignment is implemented
                 _buildCompletionTrendChart(controller),
                 _buildOverdueTasksList(controller),
               ],
             ),
           ),
         ),
       );
     }
   }
   ```

2. Add overview section:
   - Total tasks
   - Completed tasks
   - Pending tasks
   - Completion rate
   - Overdue tasks

3. Add distribution charts:
   - Status distribution (pie/bar chart)
   - Priority distribution (pie/bar chart)
   - Assignee distribution (bar chart)
   - Project distribution (bar chart)
   - Team distribution (bar chart, if applicable)

4. Add completion trend chart:
   - Line chart showing completion over time

5. Add overdue tasks list:
   - List of overdue tasks

6. Use TD widgets, AppStrings, and chart libraries (fl_chart or syncfusion_flutter_charts)

**Expected Results**:
- ✅ Statistics dashboard exists
- ✅ All statistics are displayed
- ✅ Charts are rendered correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View statistics dashboard
- Test: Verify charts are displayed
- Test: Verify statistics are accurate

---

### Task 16: Create Status Distribution Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task status distribution chart.

**Files to Create**:
- `lib/app/widgets/task_status_distribution_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskStatusDistributionChart` widget:
   ```dart
   class TaskStatusDistributionChart extends StatelessWidget {
     final TaskStatistics statistics;
     
     @override
     Widget build(BuildContext context) {
       return PieChart(
         PieChartData(
           sections: [
             PieChartSectionData(
               value: statistics.statusBreakdown[TaskStatus.pending]?.toDouble() ?? 0,
               title: 'Pending',
               color: TaskStatus.pending.color,
             ),
             // ... other statuses
           ],
         ),
       );
     }
   }
   ```

2. Use fl_chart or syncfusion_flutter_charts

3. Use enum colors for chart colors

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Status distribution chart exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: View chart

---

### Task 17: Create Priority Distribution Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task priority distribution chart.

**Files to Create**:
- `lib/app/widgets/task_priority_distribution_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskPriorityDistributionChart` widget similar to status chart

2. Use priority breakdown from statistics

3. Use enum colors for chart colors

**Expected Results**:
- ✅ Priority distribution chart exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: View chart

---

### Task 18: Create Completion Trend Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task completion trend over time.

**Files to Create**:
- `lib/app/widgets/task_completion_trend_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskCompletionTrendChart` widget:
   ```dart
   class TaskCompletionTrendChart extends StatelessWidget {
     final List<CompletionDataPoint> dataPoints;
     
     @override
     Widget build(BuildContext context) {
       return LineChart(
         LineChartData(
           lineBarsData: [
             LineChartBarData(
               spots: dataPoints.map((point) {
                 return FlSpot(
                   point.date.millisecondsSinceEpoch.toDouble(),
                   point.completedCount.toDouble(),
                 );
               }).toList(),
             ),
           ],
         ),
       );
     }
   }
   ```

2. Create `CompletionDataPoint` model:
   ```dart
   class CompletionDataPoint {
     final DateTime date;
     final int completedCount;
   }
   ```

3. Calculate completion data over time

4. Use fl_chart or syncfusion_flutter_charts

**Expected Results**:
- ✅ Completion trend chart exists
- ✅ Chart displays correctly
- ✅ Trend data is accurate

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: View chart

---

### Task 19: Create Overdue Tasks List Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying list of overdue tasks.

**Files to Create**:
- `lib/app/widgets/overdue_tasks_list_widget.dart` (new file)

**Implementation Steps**:
1. Create `OverdueTasksListWidget`:
   ```dart
   class OverdueTasksListWidget extends StatelessWidget {
     final List<TaskEntity> overdueTasks;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             'Overdue Tasks (${overdueTasks.length})',
             style: AppTextStyles.titleLarge,
           ),
           ListView.builder(
             itemCount: overdueTasks.length,
             itemBuilder: (context, index) {
               return TaskCard(task: overdueTasks[index]);
             },
           ),
         ],
       );
     }
   }
   ```

2. Filter overdue tasks:
   - Tasks with deadline in the past
   - Tasks not completed or cancelled

3. Sort by deadline (oldest first)

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Overdue tasks list widget exists
- ✅ Overdue tasks are displayed correctly
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test overdue list widget
- Manual test: View overdue tasks

---

### Task 20: Add Statistics to Dashboard Page

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add task statistics section to main dashboard page.

**Files to Modify**:
- `lib/app/pages/home/dashboard_page.dart`

**Implementation Steps**:
1. Add statistics section to dashboard:
   ```dart
   _buildTaskStatisticsSection(controller)
   ```

2. Display key statistics:
   - Total tasks
   - Completed tasks
   - Pending tasks
   - Overdue tasks

3. Add link to full statistics dashboard

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Statistics are shown on dashboard
- ✅ Key metrics are displayed
- ✅ Link to full dashboard exists

**Test Criteria**:
- Manual test: View dashboard statistics
- Test: Verify statistics are displayed

---

### Task 21: Add Export Filtered Tasks Feature

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add feature to export filtered tasks (optional enhancement).

**Files to Create**:
- `lib/core/services/task_export_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskExportService`:
   ```dart
   class TaskExportService {
     Future<String> exportToCSV(List<TaskEntity> tasks) async {
       // Generate CSV file
     }
     
     Future<String> exportToExcel(List<TaskEntity> tasks) async {
       // Generate Excel file
     }
     
     Future<String> exportToPDF(List<TaskEntity> tasks) async {
       // Generate PDF file
     }
   }
   ```

2. Add export button to task list page

3. Use file sharing packages (excel, pdf, path_provider)

**Expected Results**:
- ✅ Export service exists
- ✅ Tasks can be exported
- ✅ Export includes filtered tasks only

**Test Criteria**:
- Test: Export tasks
- Test: Verify export file is correct

---

### Task 22: Add Unit Tests for Filtering

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for filtering functionality.

**Files to Create**:
- `test/core/services/task_filter_service_test.dart`
- `test/features/tasks/domain/models/task_filter_test.dart`
- `test/features/tasks/presentation/controllers/paginated_task_controller_test.dart` (update)

**Implementation Steps**:
1. Test filter building
2. Test filter validation
3. Test cache key building
4. Test controller filter methods
5. Test combined filters

**Expected Results**:
- ✅ Unit tests cover filtering
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 23: Add Unit Tests for Statistics

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for statistics functionality.

**Files to Create**:
- `test/core/services/task_statistics_service_test.dart`
- `test/features/tasks/domain/usecases/get_workspace_statistics_test.dart`
- `test/features/tasks/presentation/controllers/task_statistics_controller_test.dart`

**Implementation Steps**:
1. Test statistics calculation
2. Test workspace statistics
3. Test project statistics
4. Test team statistics
5. Test statistics accuracy

**Expected Results**:
- ✅ Unit tests cover statistics
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 3**: Enforce Workspace Filter Guard Globally (Critical - Security)
2. **Task 4**: Create Task Filter Service (High Priority - Foundation)
3. **Task 5**: Create Task Filter Model (High Priority - Foundation)
4. **Task 6**: Update PaginatedTaskController with Filter Model (High Priority - Business Logic)
5. **Task 7**: Create Task Filter UI Widget (High Priority - UI)
6. **Task 9**: Add Filter UI to Task List Page (High Priority - UI)
7. **Task 11**: Create Task Statistics Service (High Priority - Service)
8. **Task 12**: Create Get Workspace Statistics Use Case (High Priority - Business Logic)
9. **Task 14**: Create Task Statistics Controller (High Priority - Controller Layer)
10. **Task 15**: Create Task Statistics Dashboard UI (High Priority - UI)
16. **Task 8**: Create Task Sort UI Widget (Medium Priority - UI)
11. **Task 10**: Add Search to Task List Page (Medium Priority - UI)
12. **Task 13**: Create Get Team Statistics Use Case (Medium Priority - Business Logic)
13. **Task 16**: Create Status Distribution Chart Widget (Medium Priority - UI)
14. **Task 17**: Create Priority Distribution Chart Widget (Medium Priority - UI)
15. **Task 18**: Create Completion Trend Chart Widget (Medium Priority - UI)
16. **Task 19**: Create Overdue Tasks List Widget (Medium Priority - UI)
17. **Task 20**: Add Statistics to Dashboard Page (Medium Priority - UI)
18. **Task 22**: Add Unit Tests for Filtering (Medium Priority - Quality Assurance)
19. **Task 23**: Add Unit Tests for Statistics (Medium Priority - Quality Assurance)
20. **Task 1**: Add Tag Filter to FirebaseDatabaseService (Medium Priority - Enhancement, requires tags)
21. **Task 2**: Add Team Filter to FirebaseDatabaseService (Medium Priority - Enhancement, requires team assignment)
22. **Task 21**: Add Export Filtered Tasks Feature (Low Priority - Optional Enhancement)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Workspace filter guard is enforced globally
- ✅ Task filter service exists
- ✅ Task filter model exists
- ✅ Filter UI components exist and work
- ✅ Sort UI components exist and work
- ✅ Tasks can be filtered by status/priority/assignee/project
- ✅ Tasks can be filtered by tag (when tags feature is implemented)
- ✅ Tasks can be filtered by team (when team assignment is implemented)
- ✅ Tasks can be sorted
- ✅ Tasks can be searched
- ✅ Workspace statistics are displayed
- ✅ Project statistics are displayed
- ✅ Team statistics are displayed (when team assignment is implemented)
- ✅ Statistics dashboard exists
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Unit tests have minimum 80% coverage
- ✅ No known bugs or issues

---

## Dependencies

- **Tags Feature**: Required for tag filtering (see TASK_CRUD_DETAILS_TASKS.md)
- **Team Assignment Feature**: Required for team filtering (see TASK_ASSIGNMENT_TASKS.md)
- **TaskEntity**: Must have all required fields
- **Firebase Realtime Database**: Required for storing and querying tasks
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **Chart Libraries**: fl_chart or syncfusion_flutter_charts for charts
- **File Sharing**: excel, pdf, path_provider for export (optional)

---

## Notes

1. **Filter Dependencies**: Tag and team filters require their respective features to be implemented first. These can be added later.

2. **Workspace Guard**: This is critical for security. Must ensure workspaceId is enforced in ALL operations to prevent cross-workspace data access.

3. **Filter UI**: Filter UI should be intuitive and accessible. Consider using bottom sheet, drawer, or dedicated filter page.

4. **Sorting**: Sorting should support multiple fields and directions. Consider adding multi-level sorting.

5. **Statistics**: Statistics should be calculated efficiently. Consider caching statistics and updating incrementally.

6. **Charts**: Use existing chart libraries (fl_chart or syncfusion_flutter_charts) that are already in pubspec.yaml.

7. **Performance**: For large datasets, ensure filtering and statistics are efficient. Use server-side filtering when possible.

8. **Export**: Export feature is optional but useful. Can be added later as enhancement.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_STATISTICS_FILTERING_TEST_CASES.md` - Test cases for this feature
- `TASK_CRUD_DETAILS_TASKS.md` - Tags feature (dependency)
- `TASK_ASSIGNMENT_TASKS.md` - Team assignment feature (dependency)
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

