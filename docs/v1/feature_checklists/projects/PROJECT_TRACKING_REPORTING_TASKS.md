# Project Tracking & Reporting (Dashboard, Task Charts, Burndown/Burnup, Overdue/Near-Due List, Change Log) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project Tracking & Reporting** feature (project dashboard, task charts, burndown/burnup, overdue/near-due list, change log for status/members/deadline/budget). Currently, this feature is **PARTIAL** - `project_progress_card.dart` provides progress display, but no burndown/burnup or change log; overdue/near-due not surfaced.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `project_progress_card.dart` - basic progress display widget
- ✅ `CalculateProjectProgress` use case - calculates project progress
- ✅ `ProjectProgressResult` - progress calculation result
- ✅ Overdue detection - `isOverdue` field in progress result
- ✅ Task statistics - total, completed, pending, in progress, cancelled
- ✅ Progress bar - shows completion percentage
- ✅ Chart libraries available - `fl_chart` and `syncfusion_flutter_charts` in pubspec.yaml
- ✅ `ActivityLog` entity exists - supports 'project' entityType

### What's Missing/Broken:
- ⛔ Project dashboard page - no dedicated dashboard
- ⛔ Burndown chart - no burndown visualization
- ⛔ Burnup chart - no burnup visualization
- ⛔ Task charts - no pie/bar charts for task distribution
- ⛔ Overdue tasks list - overdue shown on cards but not as dedicated list
- ⛔ Near-due tasks list - not implemented
- ⛔ Change log for projects - no logging of project changes
- ⛔ Change log UI - no UI to view project change log
- ⛔ Budget tracking - budget field may not exist in Project entity

---

## Task List

### Task 1: Create Project Dashboard Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create dedicated project dashboard page with overview, charts, and lists.

**Files to Create**:
- `lib/app/pages/projects/project_dashboard_page.dart` (new file)
- `lib/features/tasks/presentation/pages/project_dashboard_page.dart` (new file)

**Implementation Steps**:
1. Create `ProjectDashboardPage`:
   ```dart
   class ProjectDashboardPage extends StatelessWidget {
     final Project project;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<ProjectController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: '${project.title} - Dashboard',
           ),
           body: SingleChildScrollView(
             padding: EdgeInsets.all(16),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 _buildOverviewSection(project, controller),
                 SizedBox(height: 24),
                 _buildChartsSection(project, controller),
                 SizedBox(height: 24),
                 _buildOverdueNearDueSection(project, controller),
                 SizedBox(height: 24),
                 _buildChangeLogSection(project, controller),
               ],
             ),
           ),
         ),
       );
     }
   }
   ```

2. Add navigation to dashboard from project detail page

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Project dashboard page exists
- ✅ Dashboard displays comprehensive information
- ✅ Dashboard is visually organized
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View project dashboard
- Test: Verify all sections are displayed
- Test: Verify navigation works

---

### Task 2: Create Task Status Distribution Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display task status distribution as pie chart or bar chart.

**Files to Create**:
- `lib/app/widgets/task_status_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskStatusChart` widget:
   ```dart
   class TaskStatusChart extends StatelessWidget {
     final List<TaskEntity> tasks;
     final ChartType chartType; // pie or bar
     
     @override
     Widget build(BuildContext context) {
       final statusData = _calculateStatusData(tasks);
       
       if (chartType == ChartType.pie) {
         return _buildPieChart(statusData);
       } else {
         return _buildBarChart(statusData);
       }
     }
     
     Map<String, int> _calculateStatusData(List<TaskEntity> tasks) {
       return {
         'Pending': tasks.where((t) => t.status == 'pending').length,
         'In Progress': tasks.where((t) => t.status == 'in_progress').length,
         'Completed': tasks.where((t) => t.status == 'completed').length,
         'Cancelled': tasks.where((t) => t.status == 'cancelled').length,
         'On Hold': tasks.where((t) => t.status == 'on_hold').length,
       };
     }
   }
   ```

2. Use `fl_chart` or `syncfusion_flutter_charts` for chart rendering

3. Add interactivity (tap to see details)

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Task status chart widget exists
- ✅ Chart shows accurate data
- ✅ Chart is interactive
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify chart updates

---

### Task 3: Create Task Priority Distribution Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display task priority distribution as bar chart or pie chart.

**Files to Create**:
- `lib/app/widgets/task_priority_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskPriorityChart` widget similar to `TaskStatusChart`

2. Calculate priority data:
   ```dart
   Map<String, int> _calculatePriorityData(List<TaskEntity> tasks) {
     return {
       'Low': tasks.where((t) => t.priority == 'low').length,
       'Medium': tasks.where((t) => t.priority == 'medium').length,
       'High': tasks.where((t) => t.priority == 'high').length,
       'Urgent': tasks.where((t) => t.priority == 'urgent').length,
     };
   }
   ```

3. Use color coding for priorities

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Task priority chart widget exists
- ✅ Chart shows accurate data
- ✅ Chart is color-coded
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify color coding

---

### Task 4: Create Burndown Chart Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to calculate burndown chart data.

**Files to Create**:
- `lib/features/tasks/domain/usecases/calculate_burndown_chart.dart` (new file)

**Implementation Steps**:
1. Create `CalculateBurndownChart` use case:
   ```dart
   class CalculateBurndownChart {
     final ProjectRepository _repository;
     
     CalculateBurndownChart(this._repository);
     
     Future<BurndownChartData> call({
       required String workspaceId,
       required String projectId,
     }) async {
       // 1. Get project
       // 2. Get all tasks
       // 3. Calculate total work (total tasks or story points)
       // 4. Calculate ideal burndown line (straight line from start to deadline)
       // 5. Calculate actual burndown line (tasks completed over time)
       // 6. Return chart data
     }
   }
   ```

2. Create `BurndownChartData` class:
   ```dart
   class BurndownChartData {
     final List<BurndownDataPoint> idealLine;
     final List<BurndownDataPoint> actualLine;
     final DateTime startDate;
     final DateTime? deadline;
     final int totalWork;
     final int remainingWork;
   }
   
   class BurndownDataPoint {
     final DateTime date;
     final int remainingWork;
   }
   ```

3. Calculate daily completion data from task completion timestamps

**Expected Results**:
- ✅ Burndown chart use case exists
- ✅ Chart data is calculated correctly
- ✅ Ideal and actual lines are accurate

**Test Criteria**:
- Unit test: Test burndown calculation
- Test: Verify ideal line calculation
- Test: Verify actual line calculation

---

### Task 5: Create Burndown Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display burndown chart.

**Files to Create**:
- `lib/app/widgets/burndown_chart_widget.dart` (new file)

**Implementation Steps**:
1. Create `BurndownChartWidget`:
   ```dart
   class BurndownChartWidget extends StatelessWidget {
     final BurndownChartData data;
     
     @override
     Widget build(BuildContext context) {
       return Container(
         height: 300,
         child: LineChart(
           LineChartData(
             lineBarsData: [
               LineChartBarData(
                 spots: data.idealLine.map((point) => 
                   FlSpot(point.date.millisecondsSinceEpoch.toDouble(), 
                          point.remainingWork.toDouble())
                 ).toList(),
                 color: Colors.grey,
                 isCurved: false,
                 dotData: FlDotData(show: false),
               ),
               LineChartBarData(
                 spots: data.actualLine.map((point) => 
                   FlSpot(point.date.millisecondsSinceEpoch.toDouble(), 
                          point.remainingWork.toDouble())
                 ).toList(),
                 color: Colors.blue,
                 isCurved: true,
                 dotData: FlDotData(show: true),
               ),
             ],
             titlesData: FlTitlesData(
               leftTitles: AxisTitles(
                 sideTitles: SideTitles(showTitles: true),
               ),
               bottomTitles: AxisTitles(
                 sideTitles: SideTitles(
                   showTitles: true,
                   getTitlesWidget: (value, meta) {
                     return Text(DateFormat('MM/dd').format(
                       DateTime.fromMillisecondsSinceEpoch(value.toInt())
                     ));
                   },
                 ),
               ),
             ),
           ),
         ),
       );
     }
   }
   ```

2. Use `fl_chart` for line chart rendering

3. Add legend and labels

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Burndown chart widget exists
- ✅ Chart displays ideal and actual lines
- ✅ Chart is visually clear
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify chart updates

---

### Task 6: Create Burnup Chart Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to calculate burnup chart data.

**Files to Create**:
- `lib/features/tasks/domain/usecases/calculate_burnup_chart.dart` (new file)

**Implementation Steps**:
1. Create `CalculateBurnupChart` use case similar to `CalculateBurndownChart`

2. Create `BurnupChartData` class:
   ```dart
   class BurnupChartData {
     final List<BurnupDataPoint> scopeLine; // Total tasks over time
     final List<BurnupDataPoint> completedLine; // Completed tasks over time
     final DateTime startDate;
     final DateTime? deadline;
     final int currentScope;
     final int currentCompleted;
   }
   ```

3. Calculate scope line (total tasks may increase over time)
4. Calculate completed line (tasks completed over time)

**Expected Results**:
- ✅ Burnup chart use case exists
- ✅ Chart data is calculated correctly
- ✅ Scope and completed lines are accurate

**Test Criteria**:
- Unit test: Test burnup calculation
- Test: Verify scope line calculation
- Test: Verify completed line calculation

---

### Task 7: Create Burnup Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display burnup chart.

**Files to Create**:
- `lib/app/widgets/burnup_chart_widget.dart` (new file)

**Implementation Steps**:
1. Create `BurnupChartWidget` similar to `BurndownChartWidget`

2. Display scope line and completed line

3. Use `fl_chart` for line chart rendering

4. Add legend and labels

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Burnup chart widget exists
- ✅ Chart displays scope and completed lines
- ✅ Chart is visually clear
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify chart updates

---

### Task 8: Create Overdue Tasks List Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display list of overdue tasks in project.

**Files to Create**:
- `lib/app/widgets/overdue_tasks_list.dart` (new file)

**Implementation Steps**:
1. Create `OverdueTasksList` widget:
   ```dart
   class OverdueTasksList extends StatelessWidget {
     final List<TaskEntity> tasks;
     
     @override
     Widget build(BuildContext context) {
       final overdueTasks = _getOverdueTasks(tasks);
       
       if (overdueTasks.isEmpty) {
         return _buildEmptyState();
       }
       
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             AppStrings.overdueTasks,
             style: AppTextStyles.titleMedium,
           ),
           SizedBox(height: 12),
           ListView.builder(
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemCount: overdueTasks.length,
             itemBuilder: (context, index) {
               return _buildTaskCard(overdueTasks[index]);
             },
           ),
         ],
       );
     }
     
     List<TaskEntity> _getOverdueTasks(List<TaskEntity> tasks) {
       final now = DateTime.now();
       return tasks.where((task) {
         if (task.deadline == null) return false;
         return task.deadline!.isBefore(now) && 
                task.status != 'completed' && 
                task.status != 'cancelled';
       }).toList()
       ..sort((a, b) {
         // Sort by days overdue (most overdue first)
         final aDays = now.difference(a.deadline!).inDays;
         final bDays = now.difference(b.deadline!).inDays;
         return bDays.compareTo(aDays);
       });
     }
   }
   ```

2. Display task card with:
   - Task title
   - Days overdue
   - Assignee
   - Priority
   - Status

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Overdue tasks list widget exists
- ✅ List shows all overdue tasks
- ✅ List is sorted by days overdue
- ✅ List updates when tasks change

**Test Criteria**:
- Widget test: Test list widget
- Manual test: Verify list displays correctly
- Test: Verify sorting works

---

### Task 9: Create Near-Due Tasks List Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display list of near-due tasks in project.

**Files to Create**:
- `lib/app/widgets/near_due_tasks_list.dart` (new file)

**Implementation Steps**:
1. Create `NearDueTasksList` widget similar to `OverdueTasksList`

2. Filter tasks that are due within threshold (e.g., 3 days):
   ```dart
   List<TaskEntity> _getNearDueTasks(List<TaskEntity> tasks, int thresholdDays) {
     final now = DateTime.now();
     final threshold = now.add(Duration(days: thresholdDays));
     return tasks.where((task) {
       if (task.deadline == null) return false;
       final isNotOverdue = task.deadline!.isAfter(now);
       final isWithinThreshold = task.deadline!.isBefore(threshold) || 
                                  task.deadline!.isAtSameMomentAs(threshold);
       return isNotOverdue && isWithinThreshold && 
              task.status != 'completed' && 
              task.status != 'cancelled';
     }).toList()
     ..sort((a, b) {
       // Sort by days until due (soonest first)
       final aDays = a.deadline!.difference(now).inDays;
       final bDays = b.deadline!.difference(now).inDays;
       return aDays.compareTo(bDays);
     });
   }
   ```

3. Add configurable threshold (default 3 days)

4. Display days until due

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Near-due tasks list widget exists
- ✅ List shows all near-due tasks
- ✅ Threshold is configurable
- ✅ List updates when tasks change

**Test Criteria**:
- Widget test: Test list widget
- Manual test: Verify list displays correctly
- Test: Verify threshold works

---

### Task 10: Create Project Change Log Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to log project changes (status, members, deadline, budget).

**Files to Create**:
- `lib/core/services/project_change_log_service.dart` (new file)

**Implementation Steps**:
1. Create `ProjectChangeLogService`:
   ```dart
   class ProjectChangeLogService {
     final FirebaseDatabaseService _databaseService;
     
     ProjectChangeLogService(this._databaseService);
     
     Future<void> logStatusChange({
       required String workspaceId,
       required String projectId,
       required String oldStatus,
       required String newStatus,
       required String userId,
     }) async {
       await _logChange(
         workspaceId: workspaceId,
         projectId: projectId,
         changeType: 'status_changed',
         oldValue: oldStatus,
         newValue: newStatus,
         userId: userId,
       );
     }
     
     Future<void> logMemberAdded({
       required String workspaceId,
       required String projectId,
       required String memberId,
       required String memberName,
       required String userId,
     }) async {
       await _logChange(
         workspaceId: workspaceId,
         projectId: projectId,
         changeType: 'member_added',
         newValue: memberName,
         metadata: {'memberId': memberId},
         userId: userId,
       );
     }
     
     Future<void> logDeadlineChange({
       required String workspaceId,
       required String projectId,
       required DateTime? oldDeadline,
       required DateTime? newDeadline,
       required String userId,
     }) async {
       await _logChange(
         workspaceId: workspaceId,
         projectId: projectId,
         changeType: 'deadline_changed',
         oldValue: oldDeadline?.toIso8601String(),
         newValue: newDeadline?.toIso8601String(),
         userId: userId,
       );
     }
     
     Future<void> _logChange({
       required String workspaceId,
       required String projectId,
       required String changeType,
       String? oldValue,
       String? newValue,
       Map<String, dynamic>? metadata,
       required String userId,
     }) async {
       final changeLog = {
         'id': _generateId(),
         'projectId': projectId,
         'changeType': changeType,
         'oldValue': oldValue,
         'newValue': newValue,
         'metadata': metadata,
         'userId': userId,
         'timestamp': DateTime.now().millisecondsSinceEpoch,
       };
       
       await _databaseService.addProjectChangeLog(
         workspaceId: workspaceId,
         projectId: projectId,
         changeLog: changeLog,
       );
     }
   }
   ```

2. Store change logs in Firebase: `workspaces/{workspaceId}/projects/{projectId}/changeLogs/{logId}`

**Expected Results**:
- ✅ Change log service exists
- ✅ All change types are logged
- ✅ Change logs are stored in Firebase
- ✅ Service is easy to use

**Test Criteria**:
- Unit test: Test change log service
- Test: Verify all change types are logged
- Test: Verify logs are stored correctly

---

### Task 11: Create Project Change Log Repository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository interface and implementation for project change logs.

**Files to Create**:
- `lib/features/tasks/domain/repositories/project_change_log_repository.dart` (new file)
- `lib/features/tasks/data/repositories/project_change_log_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `ProjectChangeLogRepository` interface:
   ```dart
   abstract class ProjectChangeLogRepository {
     Future<List<ProjectChangeLog>> getChangeLogs({
       required String workspaceId,
       required String projectId,
       String? changeType,
       DateTime? startDate,
       DateTime? endDate,
       String? userId,
     });
     
     Future<void> addChangeLog({
       required String workspaceId,
       required String projectId,
       required ProjectChangeLog changeLog,
     });
   }
   ```

2. Create `ProjectChangeLog` entity:
   ```dart
   class ProjectChangeLog {
     final String id;
     final String projectId;
     final String changeType;
     final String? oldValue;
     final String? newValue;
     final Map<String, dynamic>? metadata;
     final String userId;
     final DateTime timestamp;
   }
   ```

3. Implement repository using `FirebaseDatabaseService`

**Expected Results**:
- ✅ Repository interface exists
- ✅ Repository implementation exists
- ✅ Change logs can be retrieved
- ✅ Filtering works correctly

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase
- Test: Verify filtering works

---

### Task 12: Create Project Change Log UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to view project change log with filtering.

**Files to Create**:
- `lib/app/widgets/project_change_log_widget.dart` (new file)

**Implementation Steps**:
1. Create `ProjectChangeLogWidget`:
   ```dart
   class ProjectChangeLogWidget extends StatelessWidget {
     final String projectId;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<ProjectController>(
         builder: (controller) => Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _buildFilterSection(controller),
             SizedBox(height: 12),
             _buildChangeLogList(controller),
           ],
         ),
       );
     }
     
     Widget _buildChangeLogList(ProjectController controller) {
       return FutureBuilder<List<ProjectChangeLog>>(
         future: controller.getProjectChangeLogs(projectId),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return TDLoadingIndicator();
           }
           
           if (snapshot.hasError) {
             return TDErrorWidget(message: snapshot.error.toString());
           }
           
           final logs = snapshot.data ?? [];
           
           if (logs.isEmpty) {
             return _buildEmptyState();
           }
           
           return ListView.builder(
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemCount: logs.length,
             itemBuilder: (context, index) {
               return _buildChangeLogCard(logs[index]);
             },
           );
         },
       );
     }
   }
   ```

2. Add filter UI:
   - Change type filter
   - Date range filter
   - User filter

3. Format change log entries clearly

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Change log widget exists
- ✅ Change logs are displayed
- ✅ Filtering works correctly
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test change log widget
- Manual test: Verify change logs are displayed
- Test: Verify filtering works

---

### Task 13: Integrate Change Logging with Project Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate change logging with project CRUD operations.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/features/tasks/domain/usecases/add_project_member.dart` (when created)
- `lib/features/tasks/domain/usecases/remove_project_member.dart` (when created)
- `lib/features/tasks/domain/usecases/update_project_member_role.dart` (when created)

**Implementation Steps**:
1. Inject `ProjectChangeLogService` into `ProjectController`

2. Log status changes in `updateProject`:
   ```dart
   Future<void> updateProject(Project project) async {
     // Get old project
     final oldProject = _projects.firstWhere((p) => p.id == project.id);
     
     // Update project
     // ... existing update code ...
     
     // Log changes
     if (oldProject.status != project.status) {
       await _changeLogService.logStatusChange(
         workspaceId: _workspaceContext.currentWorkspaceId,
         projectId: project.id,
         oldStatus: oldProject.status,
         newStatus: project.status,
         userId: currentUser.id,
       );
     }
     
     if (oldProject.deadline != project.deadline) {
       await _changeLogService.logDeadlineChange(
         workspaceId: _workspaceContext.currentWorkspaceId,
         projectId: project.id,
         oldDeadline: oldProject.deadline,
         newDeadline: project.deadline,
         userId: currentUser.id,
       );
     }
   }
   ```

3. Log member changes in member management use cases

4. Log all relevant changes

**Expected Results**:
- ✅ Change logging is integrated
- ✅ All changes are logged
- ✅ Logging doesn't affect performance

**Test Criteria**:
- Test: Verify status changes are logged
- Test: Verify member changes are logged
- Test: Verify deadline changes are logged
- Test: Verify performance is acceptable

---

### Task 14: Add Get Change Logs Method to ProjectController

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add method to `ProjectController` to get project change logs.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add method:
   ```dart
   Future<List<ProjectChangeLog>> getProjectChangeLogs(
     String projectId, {
     String? changeType,
     DateTime? startDate,
     DateTime? endDate,
     String? userId,
   }) async {
     try {
       return await _changeLogRepository.getChangeLogs(
         workspaceId: _workspaceContext.currentWorkspaceId,
         projectId: projectId,
         changeType: changeType,
         startDate: startDate,
         endDate: endDate,
         userId: userId,
       );
     } catch (e) {
       throw ProjectControllerException('Failed to get change logs: $e');
     }
   }
   ```

2. Add error handling

**Expected Results**:
- ✅ Method exists
- ✅ Filtering works correctly
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test get change logs
- Test: Verify filtering works
- Test: Verify error handling

---

### Task 15: Add Budget Field to Project Entity (If Needed)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add budget field to Project entity if budget tracking is required.

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`

**Implementation Steps**:
1. Add budget field:
   ```dart
   class Project {
     // ... existing fields ...
     final double? budget; // Optional budget
     final String? budgetCurrency; // e.g., 'USD', 'VND'
   }
   ```

2. Update `fromMap` and `toMap` methods

3. Update `copyWith` method

**Expected Results**:
- ✅ Budget field exists (if needed)
- ✅ Entity supports budget
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity with budget
- Test: Verify budget is stored correctly

---

### Task 16: Create Task Completion Trend Chart Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display task completion trend over time.

**Files to Create**:
- `lib/app/widgets/task_completion_trend_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskCompletionTrendChart` widget

2. Calculate completion data over time:
   ```dart
   List<CompletionDataPoint> _calculateCompletionData(List<TaskEntity> tasks) {
     // Group tasks by completion date
     // Calculate cumulative completion
     // Return data points
   }
   ```

3. Display as line chart or area chart

4. Use `fl_chart` for rendering

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Completion trend chart widget exists
- ✅ Chart shows completion over time
- ✅ Chart is accurate
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify chart updates

---

### Task 17: Create Task Assignee Distribution Chart Widget

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display task distribution by assignee.

**Files to Create**:
- `lib/app/widgets/task_assignee_chart.dart` (new file)

**Implementation Steps**:
1. Create `TaskAssigneeChart` widget

2. Calculate assignee data:
   ```dart
   Map<String, int> _calculateAssigneeData(List<TaskEntity> tasks) {
     final assigneeMap = <String, int>{};
     for (final task in tasks) {
       final assignee = task.assignee ?? 'Unassigned';
       assigneeMap[assignee] = (assigneeMap[assignee] ?? 0) + 1;
     }
     return assigneeMap;
   }
   ```

3. Display as bar chart or pie chart

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Assignee distribution chart widget exists
- ✅ Chart shows accurate data
- ✅ Chart is interactive
- ✅ Chart updates when tasks change

**Test Criteria**:
- Widget test: Test chart widget
- Manual test: Verify chart displays correctly
- Test: Verify chart updates

---

### Task 18: Add Export Dashboard Data Feature

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add feature to export project dashboard data as PDF/Excel/CSV.

**Files to Create/Modify**:
- `lib/core/services/project_dashboard_export_service.dart` (new file)
- `lib/app/pages/projects/project_dashboard_page.dart` (modify)

**Implementation Steps**:
1. Create `ProjectDashboardExportService`:
   ```dart
   class ProjectDashboardExportService {
     Future<String> exportToPDF({
       required Project project,
       required ProjectProgressResult progress,
       required List<TaskEntity> tasks,
       required List<ProjectChangeLog> changeLogs,
     }) async {
       // Generate PDF with dashboard data
       // Include charts as images
       // Include tables for statistics
       // Return file path
     }
     
     Future<String> exportToExcel({/* ... */}) async {
       // Generate Excel file
     }
     
     Future<String> exportToCSV({/* ... */}) async {
       // Generate CSV file
     }
   }
   ```

2. Add export button to dashboard

3. Use `pdf`, `excel`, `path_provider` packages

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Export service exists
- ✅ Multiple export formats are available
- ✅ Export includes all relevant data
- ✅ Files are generated correctly

**Test Criteria**:
- Test: Export to PDF
- Test: Export to Excel
- Test: Export to CSV
- Test: Verify exported files are correct

---

### Task 19: Add Unit Tests for Tracking & Reporting

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for tracking & reporting functionality.

**Files to Create**:
- `test/features/tasks/domain/usecases/calculate_burndown_chart_test.dart`
- `test/features/tasks/domain/usecases/calculate_burnup_chart_test.dart`
- `test/core/services/project_change_log_service_test.dart`
- `test/widgets/task_status_chart_test.dart`

**Implementation Steps**:
1. Test burndown chart calculation
2. Test burnup chart calculation
3. Test change log service
4. Test chart widgets
5. Test overdue/near-due list widgets

**Expected Results**:
- ✅ Unit tests cover tracking & reporting
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 10**: Create Project Change Log Service (High Priority - Foundation)
2. **Task 11**: Create Project Change Log Repository (High Priority - Data Layer)
3. **Task 13**: Integrate Change Logging with Project Operations (High Priority - Integration)
4. **Task 1**: Create Project Dashboard Page (High Priority - UI)
5. **Task 2**: Create Task Status Distribution Chart Widget (Medium Priority - UI)
6. **Task 3**: Create Task Priority Distribution Chart Widget (Medium Priority - UI)
7. **Task 4**: Create Burndown Chart Use Case (High Priority - Business Logic)
8. **Task 5**: Create Burndown Chart Widget (High Priority - UI)
9. **Task 6**: Create Burnup Chart Use Case (High Priority - Business Logic)
10. **Task 7**: Create Burnup Chart Widget (High Priority - UI)
11. **Task 8**: Create Overdue Tasks List Widget (Medium Priority - UI)
12. **Task 9**: Create Near-Due Tasks List Widget (Medium Priority - UI)
13. **Task 12**: Create Project Change Log UI (Medium Priority - UI)
14. **Task 14**: Add Get Change Logs Method to ProjectController (Medium Priority - Controller Layer)
15. **Task 16**: Create Task Completion Trend Chart Widget (Medium Priority - UI)
16. **Task 17**: Create Task Assignee Distribution Chart Widget (Low Priority - UI)
17. **Task 15**: Add Budget Field to Project Entity (Low Priority - Optional)
18. **Task 18**: Add Export Dashboard Data Feature (Low Priority - Enhancement)
19. **Task 19**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Project dashboard page exists
- ✅ Task status distribution chart is displayed
- ✅ Task priority distribution chart is displayed
- ✅ Burndown chart is displayed
- ✅ Burnup chart is displayed
- ✅ Overdue tasks list is displayed
- ✅ Near-due tasks list is displayed
- ✅ Project change log is displayed
- ✅ Change logging is integrated with all project operations
- ✅ Change log can be filtered
- ✅ Dashboard data can be exported (if implemented)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **Chart Libraries**: `fl_chart` and `syncfusion_flutter_charts` are available in pubspec.yaml
- **ProjectRepository**: Required for getting project data
- **TaskRepository**: Required for getting task data
- **Firebase Realtime Database**: Required for storing change logs
- **ActivityLog**: Entity exists and can be used for change logs
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **PDF/Excel packages**: May need `pdf`, `excel` packages for export

---

## Notes

1. **Progress Card Exists**: `project_progress_card.dart` already provides basic progress display. Need to enhance and add dashboard page.

2. **Chart Libraries**: `fl_chart` and `syncfusion_flutter_charts` are available, so chart implementation is possible.

3. **Activity Log**: `ActivityLog` entity exists and supports 'project' entityType, but may not be used for project changes yet. Can reuse or create separate `ProjectChangeLog` entity.

4. **Overdue Detection**: Overdue detection exists in `calculate_project_progress.dart` and is shown on progress cards, but not as a dedicated list. Need to create overdue/near-due list widgets.

5. **Burndown/Burnup**: Need to calculate historical data from task completion timestamps. May need to store daily snapshots for accurate charts.

6. **Change Log**: Need to log all project changes (status, members, deadline, budget). Should be automatic and not require manual logging.

7. **Performance**: Charts and lists should be optimized for performance, especially with large datasets. Consider pagination or data aggregation.

8. **Budget**: Budget field may not exist in Project entity. Add if budget tracking is required.

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_TRACKING_REPORTING_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/reports/REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Related reports audit
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
