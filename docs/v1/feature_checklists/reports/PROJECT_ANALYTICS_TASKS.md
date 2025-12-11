# Project Analytics (Project Status, Completion Rate, Burnup/Burndown, Overdue/Near-Due Task List) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project Analytics** feature in the Reports module (project status, completion rate, burnup/burndown, overdue/near-due task list). Currently, this feature is **PARTIAL** - `project_progress_card.dart` exists; no dedicated project analytics in reports module; overdue/near-due listing not implemented.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `project_progress_card.dart` - basic progress display widget (for project list, not reports)
- ✅ `CalculateProjectProgress` use case - calculates project progress
- ✅ `ProjectProgressResult` - progress calculation result
- ✅ Overdue detection - `isProjectOverdue` method in `CalculateProjectProgress`
- ✅ Task statistics - total, completed, pending, in progress, cancelled
- ✅ Progress bar - shows completion percentage
- ✅ Chart libraries available - `fl_chart` and `syncfusion_flutter_charts` in pubspec.yaml

### What's Missing/Broken:
- ⛔ No dedicated project analytics section in reports module
- ⛔ No project status overview in reports
- ⛔ No completion rate display in reports
- ⛔ No burnup chart
- ⛔ No burndown chart
- ⛔ No overdue tasks list in reports module
- ⛔ No near-due tasks list in reports module
- ⛔ No integration with reports module

---

## Task List

### Task 1: Create Project Analytics Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing project analytics in reports module.

**Files to Create**:
- `lib/features/reports/presentation/controllers/project_analytics_controller.dart` (new file)

**Implementation Steps**:
1. Create `ProjectAnalyticsController`:
   ```dart
   class ProjectAnalyticsController extends GetxController {
     final CalculateProjectProgress _calculateProgress;
     final ProjectRepository _projectRepository;
     final TaskRepository _taskRepository;
     final StorageService _storageService = Get.find<StorageService>();
     
     final Rx<ProjectAnalyticsData?> _analytics = Rx<ProjectAnalyticsData?>(null);
     final RxList<ProjectProgressResult> _projectProgress = <ProjectProgressResult>[].obs;
     final RxList<TaskEntity> _overdueTasks = <TaskEntity>[].obs;
     final RxList<TaskEntity> _nearDueTasks = <TaskEntity>[].obs;
     final RxBool _isLoading = false.obs;
     
     ProjectAnalyticsData? get analytics => _analytics.value;
     List<ProjectProgressResult> get projectProgress => _projectProgress;
     List<TaskEntity> get overdueTasks => _overdueTasks;
     List<TaskEntity> get nearDueTasks => _nearDueTasks;
     bool get isLoading => _isLoading.value;
     
     @override
     void onInit() {
       super.onInit();
       loadProjectAnalytics();
     }
     
     Future<void> loadProjectAnalytics() async {
       try {
         _isLoading.value = true;
         
         final workspaceId = _storageService.getWorkspaceId();
         if (workspaceId == null) return;
         
         // Get all projects
         final projects = await _projectRepository.getProjects(workspaceId: workspaceId);
         
         // Calculate progress for all projects
         final progressResults = <ProjectProgressResult>[];
         for (final project in projects) {
           final progress = await _calculateProgress.call(
             workspaceId: workspaceId,
             projectId: project.id,
           );
           if (progress.isSuccess) {
             progressResults.add(progress);
           }
         }
         _projectProgress.value = progressResults;
         
         // Get overdue and near-due tasks
         await _loadOverdueTasks(workspaceId);
         await _loadNearDueTasks(workspaceId);
         
         // Calculate analytics data
         _analytics.value = _calculateAnalyticsData(progressResults);
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.failedToLoadProjectAnalytics,
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> _loadOverdueTasks(String workspaceId) async {
       final now = DateTime.now();
       final tasks = await _taskRepository.getTasks(workspaceId: workspaceId);
       _overdueTasks.value = tasks.where((task) {
         if (task.deadline == null) return false;
         return task.deadline!.isBefore(now) && 
                task.status != 'completed' && 
                task.status != 'cancelled';
       }).toList();
     }
     
     Future<void> _loadNearDueTasks(String workspaceId) async {
       final now = DateTime.now();
       final nearDueThreshold = now.add(Duration(days: 3));
       final tasks = await _taskRepository.getTasks(workspaceId: workspaceId);
       _nearDueTasks.value = tasks.where((task) {
         if (task.deadline == null) return false;
         final isNotOverdue = !task.deadline!.isBefore(now);
         final isNearDue = task.deadline!.isBefore(nearDueThreshold) || 
                          task.deadline!.isAtSameMomentAs(nearDueThreshold);
         return isNotOverdue && isNearDue && 
                task.status != 'completed' && 
                task.status != 'cancelled';
       }).toList();
     }
     
     ProjectAnalyticsData _calculateAnalyticsData(List<ProjectProgressResult> progressResults) {
       final totalProjects = progressResults.length;
       final completedProjects = progressResults.where((p) => p.isCompleted).length;
       final overdueProjects = progressResults.where((p) => p.isOverdue).length;
       
       final statusCounts = <String, int>{};
       for (final progress in progressResults) {
         final status = progress.project?.status ?? 'unknown';
         statusCounts[status] = (statusCounts[status] ?? 0) + 1;
       }
       
       final overallCompletionRate = totalProjects > 0
           ? (completedProjects / totalProjects * 100).round()
           : 0;
       
       return ProjectAnalyticsData(
         totalProjects: totalProjects,
         completedProjects: completedProjects,
         overdueProjects: overdueProjects,
         overallCompletionRate: overallCompletionRate,
         statusCounts: statusCounts,
       );
     }
   }
   ```

2. Create `ProjectAnalyticsData` model:
   ```dart
   class ProjectAnalyticsData {
     final int totalProjects;
     final int completedProjects;
     final int overdueProjects;
     final int overallCompletionRate;
     final Map<String, int> statusCounts;
     
     const ProjectAnalyticsData({
       required this.totalProjects,
       required this.completedProjects,
       required this.overdueProjects,
       required this.overallCompletionRate,
       required this.statusCounts,
     });
   }
   ```

3. Use GetX for state management

4. Use SnackbarService and AppStrings

**Expected Results**:
- ✅ Project analytics controller exists
- ✅ Analytics data is calculated
- ✅ Overdue/near-due tasks are loaded
- ✅ Controller follows project rules

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test analytics calculation
- Test: Test overdue/near-due loading

---

### Task 2: Create Project Status Overview Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying project status overview in reports.

**Files to Create**:
- `lib/features/reports/presentation/widgets/project_status_overview_widget.dart` (new file)

**Implementation Steps**:
1. Create `ProjectStatusOverviewWidget`:
   ```dart
   class ProjectStatusOverviewWidget extends StatelessWidget {
     final ProjectAnalyticsData analytics;
     
     @override
     Widget build(BuildContext context) {
       return TDCard(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.projectStatusOverview,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             
             // Status counts
             Row(
               children: [
                 Expanded(
                   child: _buildStatusCard(
                     AppStrings.pending,
                     analytics.statusCounts['pending'] ?? 0,
                     Colors.orange,
                   ),
                 ),
                 SizedBox(width: AppSpacing.sm),
                 Expanded(
                   child: _buildStatusCard(
                     AppStrings.inProgress,
                     analytics.statusCounts['in_progress'] ?? 0,
                     Colors.blue,
                   ),
                 ),
                 SizedBox(width: AppSpacing.sm),
                 Expanded(
                   child: _buildStatusCard(
                     AppStrings.completed,
                     analytics.statusCounts['completed'] ?? 0,
                     Colors.green,
                   ),
                 ),
                 SizedBox(width: AppSpacing.sm),
                 Expanded(
                   child: _buildStatusCard(
                     AppStrings.cancelled,
                     analytics.statusCounts['cancelled'] ?? 0,
                     Colors.red,
                   ),
                 ),
               ],
             ),
           ],
         ),
       );
     }
     
     Widget _buildStatusCard(String label, int count, Color color) {
       return Container(
         padding: EdgeInsets.all(AppSpacing.md),
         decoration: BoxDecoration(
           color: color.withValues(alpha: 0.1),
           borderRadius: BorderRadius.circular(8),
           border: Border.all(color: color),
         ),
         child: Column(
           children: [
             Text(
               '$count',
               style: AppTextStyles.headlineMedium.copyWith(
                 color: color,
                 fontWeight: FontWeight.bold,
               ),
             ),
             SizedBox(height: AppSpacing.xs),
             Text(
               label,
               style: AppTextStyles.bodySmall,
               textAlign: TextAlign.center,
             ),
           ],
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Project status overview widget exists
- ✅ Status counts are displayed
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test status overview widget
- Manual test: View status overview

---

### Task 3: Create Project Completion Rate Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying project completion rate.

**Files to Create**:
- `lib/features/reports/presentation/widgets/project_completion_rate_widget.dart` (new file)

**Implementation Steps**:
1. Create `ProjectCompletionRateWidget`:
   ```dart
   class ProjectCompletionRateWidget extends StatelessWidget {
     final ProjectAnalyticsData analytics;
     
     @override
     Widget build(BuildContext context) {
       return TDCard(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.completionRate,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             
             // Overall completion rate
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   AppStrings.overallCompletionRate,
                   style: AppTextStyles.bodyLarge,
                 ),
                 Text(
                   '${analytics.overallCompletionRate}%',
                   style: AppTextStyles.headlineLarge.copyWith(
                     fontWeight: FontWeight.bold,
                     color: AppColors.primary,
                   ),
                 ),
               ],
             ),
             SizedBox(height: AppSpacing.sm),
             
             // Progress bar
             LinearProgressIndicator(
               value: analytics.overallCompletionRate / 100,
               backgroundColor: AppColors.surfaceVariant,
               valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
             ),
             SizedBox(height: AppSpacing.md),
             
             // Breakdown
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _buildStatItem(
                   AppStrings.completed,
                   analytics.completedProjects,
                   Colors.green,
                 ),
                 _buildStatItem(
                   AppStrings.total,
                   analytics.totalProjects,
                   Colors.blue,
                 ),
                 _buildStatItem(
                   AppStrings.overdue,
                   analytics.overdueProjects,
                   Colors.red,
                 ),
               ],
             ),
           ],
         ),
       );
     }
     
     Widget _buildStatItem(String label, int value, Color color) {
       return Column(
         children: [
           Text(
             '$value',
             style: AppTextStyles.headlineSmall.copyWith(
               color: color,
               fontWeight: FontWeight.bold,
             ),
           ),
           Text(
             label,
             style: AppTextStyles.bodySmall,
           ),
         ],
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Completion rate widget exists
- ✅ Completion rate is displayed
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test completion rate widget
- Manual test: View completion rate

---

### Task 4: Create Burnup Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying burnup chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/project_burnup_chart.dart` (new file)

**Implementation Steps**:
1. Create `ProjectBurnupChart` widget using `fl_chart`:
   ```dart
   class ProjectBurnupChart extends StatelessWidget {
     final String projectId;
     final List<TaskEntity> tasks;
     
     @override
     Widget build(BuildContext context) {
       final chartData = _calculateBurnupData(tasks);
       
       return TDCard(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.burnupChart,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             SizedBox(
               height: 200,
               child: LineChart(
                 LineChartData(
                   gridData: FlGridData(show: true),
                   titlesData: FlTitlesData(show: true),
                   borderData: FlBorderData(show: true),
                   lineBarsData: [
                     // Completed work line
                     LineChartBarData(
                       spots: chartData.completedWorkSpots,
                       isCurved: true,
                       color: Colors.green,
                       barWidth: 3,
                     ),
                     // Total scope line
                     LineChartBarData(
                       spots: chartData.totalScopeSpots,
                       isCurved: true,
                       color: Colors.blue,
                       barWidth: 3,
                     ),
                   ],
                 ),
               ),
             ),
           ],
         ),
       );
     }
     
     BurnupChartData _calculateBurnupData(List<TaskEntity> tasks) {
       // Calculate burnup data from task completion history
       // This requires storing task completion timestamps
       // For now, use simplified calculation
       final totalTasks = tasks.length;
       final completedTasks = tasks.where((t) => t.status == 'completed').length;
       
       // Generate data points (simplified - should use actual completion dates)
       final completedWorkSpots = <FlSpot>[];
       final totalScopeSpots = <FlSpot>[];
       
       for (int i = 0; i < 30; i++) {
         final date = DateTime.now().subtract(Duration(days: 30 - i));
         // Simplified calculation - should use actual historical data
         final completed = (completedTasks * (i / 30)).round();
         completedWorkSpots.add(FlSpot(i.toDouble(), completed.toDouble()));
         totalScopeSpots.add(FlSpot(i.toDouble(), totalTasks.toDouble()));
       }
       
       return BurnupChartData(
         completedWorkSpots: completedWorkSpots,
         totalScopeSpots: totalScopeSpots,
       );
     }
   }
   ```

2. Note: This requires storing task completion timestamps for accurate burnup calculation

**Expected Results**:
- ✅ Burnup chart widget exists
- ✅ Chart displays correctly
- ✅ Chart data is calculated

**Test Criteria**:
- Widget test: Test burnup chart widget
- Manual test: View burnup chart

---

### Task 5: Create Burndown Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying burndown chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/project_burndown_chart.dart` (new file)

**Implementation Steps**:
1. Create `ProjectBurndownChart` widget similar to burnup chart:
   - Show remaining work over time
   - Show ideal burndown line
   - Show actual burndown line

2. Use `fl_chart` package

3. Calculate burndown data from task completion history

**Expected Results**:
- ✅ Burndown chart widget exists
- ✅ Chart displays correctly
- ✅ Chart data is calculated

**Test Criteria**:
- Widget test: Test burndown chart widget
- Manual test: View burndown chart

---

### Task 6: Create Overdue Tasks List Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying overdue tasks list in reports.

**Files to Create**:
- `lib/features/reports/presentation/widgets/overdue_tasks_list_widget.dart` (new file)

**Implementation Steps**:
1. Create `OverdueTasksListWidget`:
   ```dart
   class OverdueTasksListWidget extends StatelessWidget {
     final List<TaskEntity> overdueTasks;
     
     @override
     Widget build(BuildContext context) {
       if (overdueTasks.isEmpty) {
         return _buildEmptyState();
       }
       
       return TDCard(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.overdueTasks,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             
             ListView.builder(
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               itemCount: overdueTasks.length,
               itemBuilder: (context, index) {
                 final task = overdueTasks[index];
                 return _buildTaskItem(task);
               },
             ),
           ],
         ),
       );
     }
     
     Widget _buildTaskItem(TaskEntity task) {
       final daysOverdue = task.deadline != null
           ? DateTime.now().difference(task.deadline!).inDays
           : 0;
       
       return ListTile(
         title: Text(task.title),
         subtitle: Text(
           '${AppStrings.daysOverdue}: $daysOverdue',
           style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
         ),
         trailing: Text(
           task.projectId ?? AppStrings.noProject,
           style: AppTextStyles.bodySmall,
         ),
       );
     }
     
     Widget _buildEmptyState() {
       return TDCard(
         child: Center(
           child: Column(
             children: [
               Icon(Icons.check_circle, size: 48, color: Colors.green),
               SizedBox(height: AppSpacing.sm),
               Text(AppStrings.noOverdueTasks),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Overdue tasks list widget exists
- ✅ List displays correctly
- ✅ Empty state is handled

**Test Criteria**:
- Widget test: Test overdue tasks list widget
- Manual test: View overdue tasks list

---

### Task 7: Create Near-Due Tasks List Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying near-due tasks list in reports.

**Files to Create**:
- `lib/features/reports/presentation/widgets/near_due_tasks_list_widget.dart` (new file)

**Implementation Steps**:
1. Create `NearDueTasksListWidget` similar to overdue tasks list:
   - Show tasks due within 3 days
   - Show days until due
   - Use similar structure

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Near-due tasks list widget exists
- ✅ List displays correctly
- ✅ Empty state is handled

**Test Criteria**:
- Widget test: Test near-due tasks list widget
- Manual test: View near-due tasks list

---

### Task 8: Create Project Analytics Page/Section

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create project analytics page or section in reports module.

**Files to Create**:
- `lib/app/pages/reports/project_analytics_page.dart` (new file)
- OR integrate into existing `report_analytics_page.dart`

**Implementation Steps**:
1. Create project analytics page or add section to existing page:
   ```dart
   class ProjectAnalyticsPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.put(ProjectAnalyticsController());
       
       return Scaffold(
         appBar: TDAppBar(
           title: AppStrings.projectAnalytics,
         ),
         body: GetBuilder<ProjectAnalyticsController>(
           builder: (ctrl) {
             if (ctrl.isLoading) {
               return TDLoadingIndicator();
             }
             
             final analytics = ctrl.analytics;
             if (analytics == null) {
               return Center(child: Text(AppStrings.noDataAvailable));
             }
             
             return SingleChildScrollView(
               child: Column(
                 children: [
                   // Status overview
                   ProjectStatusOverviewWidget(analytics: analytics),
                   SizedBox(height: AppSpacing.md),
                   
                   // Completion rate
                   ProjectCompletionRateWidget(analytics: analytics),
                   SizedBox(height: AppSpacing.md),
                   
                   // Burnup chart (if project selected)
                   // Burndown chart (if project selected)
                   
                   // Overdue tasks
                   OverdueTasksListWidget(overdueTasks: ctrl.overdueTasks),
                   SizedBox(height: AppSpacing.md),
                   
                   // Near-due tasks
                   NearDueTasksListWidget(nearDueTasks: ctrl.nearDueTasks),
                 ],
               ),
             );
           },
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Project analytics page/section exists
- ✅ All widgets are displayed
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View project analytics page
- Test: Verify all widgets are displayed

---

### Task 9: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for project analytics functionality.

**Files to Create**:
- `test/features/reports/presentation/controllers/project_analytics_controller_test.dart`
- `test/features/reports/presentation/widgets/project_status_overview_widget_test.dart`
- `test/features/reports/presentation/widgets/project_completion_rate_widget_test.dart`

**Implementation Steps**:
1. Test controller:
   - Test analytics calculation
   - Test overdue/near-due loading
   - Test workspace scoping

2. Test widgets:
   - Test widget rendering
   - Test empty states
   - Test data display

**Expected Results**:
- ✅ Unit tests cover project analytics
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Project Analytics Controller (Critical - Foundation)
2. **Task 2**: Create Project Status Overview Widget (High Priority - Core Feature)
3. **Task 3**: Create Project Completion Rate Widget (High Priority - Core Feature)
4. **Task 6**: Create Overdue Tasks List Widget (High Priority - Core Feature)
5. **Task 7**: Create Near-Due Tasks List Widget (High Priority - Core Feature)
6. **Task 8**: Create Project Analytics Page/Section (High Priority - Integration)
7. **Task 4**: Create Burnup Chart Widget (Medium Priority - Feature Enhancement)
8. **Task 5**: Create Burndown Chart Widget (Medium Priority - Feature Enhancement)
9. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Project analytics controller exists
- ✅ Project status overview is displayed
- ✅ Project completion rate is displayed
- ✅ Overdue tasks list is displayed
- ✅ Near-due tasks list is displayed
- ✅ Burnup chart is displayed (optional)
- ✅ Burndown chart is displayed (optional)
- ✅ Project analytics page/section exists
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **CalculateProjectProgress**: Existing use case for calculating project progress
- **ProjectRepository**: Required for getting project data
- **TaskRepository**: Required for getting task data
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **Chart Libraries**: `fl_chart` and `syncfusion_flutter_charts` (already in pubspec.yaml)

---

## Notes

1. **Integration with Existing Components**: Use existing `CalculateProjectProgress` use case and `ProjectProgressResult` for consistency.

2. **Burnup/Burndown Charts**: These require storing task completion timestamps for accurate historical data. May need to add completion timestamp tracking to tasks.

3. **Overdue/Near-Due Detection**: Use existing overdue detection logic from `CalculateProjectProgress` but extend it for task-level detection.

4. **Workspace Scoping**: Critical to always enforce workspace scoping for data isolation and security.

5. **Performance**: For large datasets, consider:
   - Server-side aggregation
   - Caching analytics data
   - Incremental updates

---

## Related Documentation

- `REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_ANALYTICS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/projects/PROJECT_TRACKING_REPORTING_TASKS.md` - Related project tracking feature
- `docs/v1/feature_checklists/reports/reports.md` - Report requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

