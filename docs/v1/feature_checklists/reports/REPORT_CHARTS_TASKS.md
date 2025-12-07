# Report Charts (Bar/Pie Charts for Tasks per Status/Priority) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Report Charts** feature (bar/pie charts for tasks per status/priority). Currently, this feature is **PARTIAL** - Dashboard has metrics placeholders (not fully reviewed), but dedicated chart implementation for reports not evident; no charts tied to reports feature.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ Chart libraries available: `fl_chart: ^0.66.0` and `syncfusion_flutter_charts: ^23.2.7` in pubspec.yaml
- ✅ `task_statistics_page.dart` - has `_PlaceholderChart` widget
- ✅ `report_analytics_page.dart` - has placeholder for pie chart in `_buildTaskCompletionStats()`
- ✅ `workspace_analytics_dashboard.dart` - has `_buildChartPlaceholder` method
- ✅ Task aggregation data (from previous feature - Report Overview Aggregation)

### What's Missing/Broken:
- ⛔ No actual chart implementations (only placeholders)
- ⛔ Charts not tied to reports feature
- ⛔ No status distribution chart (pie/bar)
- ⛔ No priority distribution chart (pie/bar)
- ⛔ No chart view switching (pie/bar toggle)
- ⛔ No chart legend
- ⛔ No chart tooltips/interactions
- ⛔ No chart filtering integration
- ⛔ No empty state handling for charts
- ⛔ No performance optimization for large datasets

---

## Task List

### Task 1: Create Status Distribution Pie Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task status distribution as pie chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/status_distribution_pie_chart.dart` (new file)

**Implementation Steps**:
1. Create `StatusDistributionPieChart` widget:
   ```dart
   import 'package:fl_chart/fl_chart.dart';
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../../../core/constants/task_enums.dart';
   import '../../../../core/constants/app_strings.dart';
   import '../../../../core/constants/app_spacing.dart';
   import '../../domain/entities/task_aggregation_metrics.dart';
   
   class StatusDistributionPieChart extends StatelessWidget {
     final TaskAggregationMetrics metrics;
     
     const StatusDistributionPieChart({
       super.key,
       required this.metrics,
     });
     
     @override
     Widget build(BuildContext context) {
       if (metrics.totalTasks == 0) {
         return _buildEmptyState();
       }
       
       return Container(
         padding: EdgeInsets.all(AppSpacing.md),
         decoration: BoxDecoration(
           color: AppColors.surface,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: AppColors.outline),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.statusDistribution,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             Row(
               children: [
                 Expanded(
                   flex: 2,
                   child: SizedBox(
                     height: 200,
                     child: PieChart(
                       PieChartData(
                         sections: _buildSections(),
                         sectionsSpace: 2,
                         centerSpaceRadius: 40,
                         pieTouchData: PieTouchData(
                           touchCallback: (FlTouchEvent event, pieTouchResponse) {
                             // Handle touch interaction
                           },
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox(width: AppSpacing.md),
                 Expanded(
                   flex: 1,
                   child: _buildLegend(),
                 ),
               ],
             ),
           ],
         ),
       );
     }
     
     List<PieChartSectionData> _buildSections() {
       return TaskStatus.values.map((status) {
         final count = metrics.tasksByStatus[status] ?? 0;
         final percentage = metrics.totalTasks > 0
             ? (count / metrics.totalTasks * 100)
             : 0.0;
         
         return PieChartSectionData(
           value: count.toDouble(),
           title: '${count}\n${percentage.toStringAsFixed(1)}%',
           color: status.color,
           radius: 60,
           titleStyle: AppTextStyles.bodySmall.copyWith(
             color: AppColors.onSurface,
             fontWeight: FontWeight.bold,
           ),
         );
       }).toList();
     }
     
     Widget _buildLegend() {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: TaskStatus.values.map((status) {
           final count = metrics.tasksByStatus[status] ?? 0;
           return Padding(
             padding: EdgeInsets.only(bottom: AppSpacing.sm),
             child: Row(
               children: [
                 Container(
                   width: 16,
                   height: 16,
                   decoration: BoxDecoration(
                     color: status.color,
                     shape: BoxShape.circle,
                   ),
                 ),
                 SizedBox(width: AppSpacing.sm),
                 Expanded(
                   child: Text(
                     status.displayText,
                     style: AppTextStyles.bodySmall,
                   ),
                 ),
                 Text(
                   '$count',
                   style: AppTextStyles.bodySmall.copyWith(
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ],
             ),
           );
         }).toList(),
       );
     }
     
     Widget _buildEmptyState() {
       return Container(
         padding: EdgeInsets.all(AppSpacing.md),
         decoration: BoxDecoration(
           color: AppColors.surface,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: AppColors.outline),
         ),
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 Icons.pie_chart_outline,
                 size: 48,
                 color: AppColors.onSurfaceVariant,
               ),
               SizedBox(height: AppSpacing.sm),
               Text(
                 AppStrings.noDataAvailable,
                 style: AppTextStyles.bodyMedium,
               ),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Use `fl_chart` package (already in pubspec.yaml)

3. Use task enum colors from `TaskStatus.color`

4. Use AppStrings and AppSpacing

**Expected Results**:
- ✅ Status distribution pie chart widget exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors
- ✅ Legend is displayed
- ✅ Empty state is handled
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test pie chart widget
- Manual test: View pie chart
- Test: Verify colors match enum colors
- Test: Verify empty state

---

### Task 2: Create Status Distribution Bar Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task status distribution as bar chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/status_distribution_bar_chart.dart` (new file)

**Implementation Steps**:
1. Create `StatusDistributionBarChart` widget:
   ```dart
   import 'package:fl_chart/fl_chart.dart';
   import 'package:flutter/material.dart';
   import '../../../../core/constants/task_enums.dart';
   import '../../../../core/constants/app_strings.dart';
   import '../../../../core/constants/app_spacing.dart';
   import '../../domain/entities/task_aggregation_metrics.dart';
   
   class StatusDistributionBarChart extends StatelessWidget {
     final TaskAggregationMetrics metrics;
     
     const StatusDistributionBarChart({
       super.key,
       required this.metrics,
     });
     
     @override
     Widget build(BuildContext context) {
       if (metrics.totalTasks == 0) {
         return _buildEmptyState();
       }
       
       return Container(
         padding: EdgeInsets.all(AppSpacing.md),
         decoration: BoxDecoration(
           color: AppColors.surface,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: AppColors.outline),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.statusDistribution,
               style: AppTextStyles.heading,
             ),
             SizedBox(height: AppSpacing.md),
             SizedBox(
               height: 200,
               child: BarChart(
                 BarChartData(
                   alignment: BarChartAlignment.spaceAround,
                   maxY: _getMaxValue(),
                   barTouchData: BarTouchData(
                     touchTooltipData: BarTouchTooltipData(
                       getTooltipColor: (group) => AppColors.surface,
                       tooltipRoundedRadius: 8,
                     ),
                   ),
                   titlesData: FlTitlesData(
                     show: true,
                     bottomTitles: AxisTitles(
                       sideTitles: SideTitles(
                         showTitles: true,
                         getTitlesWidget: (value, meta) {
                           final status = TaskStatus.values[value.toInt()];
                           return Padding(
                             padding: EdgeInsets.only(top: AppSpacing.xs),
                             child: Text(
                               status.displayText,
                               style: AppTextStyles.bodySmall,
                               textAlign: TextAlign.center,
                             ),
                           );
                         },
                       ),
                     ),
                     leftTitles: AxisTitles(
                       sideTitles: SideTitles(
                         showTitles: true,
                         getTitlesWidget: (value, meta) {
                           return Text(
                             value.toInt().toString(),
                             style: AppTextStyles.bodySmall,
                           );
                         },
                       ),
                     ),
                     topTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                     rightTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                   ),
                   borderData: FlBorderData(show: true),
                   barGroups: _buildBarGroups(),
                 ),
               ),
             ),
           ],
         ),
       );
     }
     
     List<BarChartGroupData> _buildBarGroups() {
       return TaskStatus.values.asMap().entries.map((entry) {
         final index = entry.key;
         final status = entry.value;
         final count = metrics.tasksByStatus[status] ?? 0;
         
         return BarChartGroupData(
           x: index,
           barRods: [
             BarChartRodData(
               toY: count.toDouble(),
               color: status.color,
               width: 20,
               borderRadius: BorderRadius.circular(4),
             ),
           ],
         );
       }).toList();
     }
     
     double _getMaxValue() {
       final maxCount = metrics.tasksByStatus.values.reduce(
         (a, b) => a > b ? a : b,
       );
       return (maxCount * 1.2).toDouble(); // Add 20% padding
     }
     
     Widget _buildEmptyState() {
       // Similar to pie chart empty state
     }
   }
   ```

2. Use `fl_chart` package

3. Use task enum colors

4. Use AppStrings and AppSpacing

**Expected Results**:
- ✅ Status distribution bar chart widget exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors
- ✅ Empty state is handled
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test bar chart widget
- Manual test: View bar chart
- Test: Verify colors match enum colors

---

### Task 3: Create Priority Distribution Pie Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task priority distribution as pie chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/priority_distribution_pie_chart.dart` (new file)

**Implementation Steps**:
1. Create `PriorityDistributionPieChart` widget similar to `StatusDistributionPieChart`:
   - Use `TaskPriority` enum instead of `TaskStatus`
   - Use `metrics.tasksByPriority` instead of `metrics.tasksByStatus`
   - Use `TaskPriority.color` for colors
   - Use `TaskPriority.displayText` for labels

2. Follow same structure as status pie chart

**Expected Results**:
- ✅ Priority distribution pie chart widget exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test priority pie chart widget
- Manual test: View priority pie chart

---

### Task 4: Create Priority Distribution Bar Chart Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create widget for displaying task priority distribution as bar chart.

**Files to Create**:
- `lib/features/reports/presentation/widgets/priority_distribution_bar_chart.dart` (new file)

**Implementation Steps**:
1. Create `PriorityDistributionBarChart` widget similar to `StatusDistributionBarChart`:
   - Use `TaskPriority` enum instead of `TaskStatus`
   - Use `metrics.tasksByPriority` instead of `metrics.tasksByStatus`
   - Use `TaskPriority.color` for colors
   - Use `TaskPriority.displayText` for labels

2. Follow same structure as status bar chart

**Expected Results**:
- ✅ Priority distribution bar chart widget exists
- ✅ Chart displays correctly
- ✅ Colors match enum colors
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test priority bar chart widget
- Manual test: View priority bar chart

---

### Task 5: Create Chart View Switcher Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget for switching between pie and bar chart views.

**Files to Create**:
- `lib/features/reports/presentation/widgets/chart_view_switcher.dart` (new file)

**Implementation Steps**:
1. Create `ChartViewSwitcher` widget:
   ```dart
   import 'package:flutter/material.dart';
   import '../../../../core/constants/app_strings.dart';
   import '../../../../core/constants/app_spacing.dart';
   
   enum ChartViewType { pie, bar }
   
   class ChartViewSwitcher extends StatelessWidget {
     final ChartViewType selectedView;
     final ValueChanged<ChartViewType> onViewChanged;
     
     const ChartViewSwitcher({
       super.key,
       required this.selectedView,
       required this.onViewChanged,
     });
     
     @override
     Widget build(BuildContext context) {
       return Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           _buildToggleButton(
             label: AppStrings.pieChart,
             icon: Icons.pie_chart,
             isSelected: selectedView == ChartViewType.pie,
             onTap: () => onViewChanged(ChartViewType.pie),
           ),
           SizedBox(width: AppSpacing.sm),
           _buildToggleButton(
             label: AppStrings.barChart,
             icon: Icons.bar_chart,
             isSelected: selectedView == ChartViewType.bar,
             onTap: () => onViewChanged(ChartViewType.bar),
           ),
         ],
       );
     }
     
     Widget _buildToggleButton({
       required String label,
       required IconData icon,
       required bool isSelected,
       required VoidCallback onTap,
     }) {
       return TDButton(
         text: label,
         icon: icon,
         onPressed: onTap,
         variant: isSelected ? TDButtonVariant.filled : TDButtonVariant.outlined,
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Chart view switcher exists
- ✅ Switching works correctly
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test view switcher
- Manual test: Switch between views

---

### Task 6: Create Combined Chart Widget with View Switcher

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create combined widget that shows status/priority charts with view switcher.

**Files to Create**:
- `lib/features/reports/presentation/widgets/task_distribution_chart_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskDistributionChartWidget`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../../../core/constants/app_strings.dart';
   import '../../domain/entities/task_aggregation_metrics.dart';
   import 'status_distribution_pie_chart.dart';
   import 'status_distribution_bar_chart.dart';
   import 'priority_distribution_pie_chart.dart';
   import 'priority_distribution_bar_chart.dart';
   import 'chart_view_switcher.dart';
   
   class TaskDistributionChartWidget extends StatelessWidget {
     final TaskAggregationMetrics metrics;
     final Rx<ChartViewType> selectedView = ChartViewType.pie.obs;
     
     const TaskDistributionChartWidget({
       super.key,
       required this.metrics,
     });
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Status Chart
           Obx(() => selectedView.value == ChartViewType.pie
               ? StatusDistributionPieChart(metrics: metrics)
               : StatusDistributionBarChart(metrics: metrics),
           ),
           SizedBox(height: AppSpacing.md),
           
           // View Switcher
           ChartViewSwitcher(
             selectedView: selectedView.value,
             onViewChanged: (view) => selectedView.value = view,
           ),
           SizedBox(height: AppSpacing.md),
           
           // Priority Chart
           Obx(() => selectedView.value == ChartViewType.pie
               ? PriorityDistributionPieChart(metrics: metrics)
               : PriorityDistributionBarChart(metrics: metrics),
           ),
         ],
       );
     }
   }
   ```

2. Use GetX for state management

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Combined chart widget exists
- ✅ View switching works
- ✅ Both charts are displayed
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test combined chart widget
- Manual test: View charts and switch views

---

### Task 7: Update Report Analytics Page with Charts

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Replace placeholder in `report_analytics_page.dart` with actual charts.

**Files to Modify**:
- `lib/app/pages/reports/report_analytics_page.dart`

**Implementation Steps**:
1. Import chart widgets:
   ```dart
   import '../../../features/reports/presentation/widgets/task_distribution_chart_widget.dart';
   import '../../../features/reports/presentation/controllers/overview_report_controller.dart';
   ```

2. Replace `_buildTaskCompletionStats()` placeholder:
   ```dart
   Widget _buildTaskCompletionStats() {
     final controller = Get.find<OverviewReportController>();
     
     return GetBuilder<OverviewReportController>(
       builder: (ctrl) {
         final metrics = ctrl.metrics;
         if (metrics == null) {
           return Container(
             // Empty state
           );
         }
         
         return TaskDistributionChartWidget(metrics: metrics);
       },
     );
   }
   ```

3. Ensure `OverviewReportController` is initialized and data is loaded

**Expected Results**:
- ✅ Report analytics page shows charts
- ✅ Placeholder is replaced
- ✅ Charts use real data
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View report analytics page
- Test: Verify charts are displayed
- Test: Verify placeholder is replaced

---

### Task 8: Update Task Statistics Page with Charts

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Replace placeholder in `task_statistics_page.dart` with actual charts.

**Files to Modify**:
- `lib/app/pages/tasks/task_statistics_page.dart`

**Implementation Steps**:
1. Convert to GetX controller pattern:
   ```dart
   class TaskStatisticsPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.put(OverviewReportController());
       
       return Scaffold(
         // ... existing code ...
         body: GetBuilder<OverviewReportController>(
           builder: (ctrl) {
             if (ctrl.isLoading) {
               return TDLoadingIndicator();
             }
             
             final metrics = ctrl.metrics;
             if (metrics == null) {
               return Center(child: Text(AppStrings.noDataAvailable));
             }
             
             return SingleChildScrollView(
               child: Column(
                 children: [
                   // Overview section
                   _buildOverviewSection(metrics),
                   SizedBox(height: AppSpacing.md),
                   
                   // Status distribution chart
                   StatusDistributionPieChart(metrics: metrics),
                   SizedBox(height: AppSpacing.md),
                   
                   // Priority distribution chart
                   PriorityDistributionPieChart(metrics: metrics),
                 ],
               ),
             );
           },
         ),
       );
     }
   }
   ```

2. Replace `_PlaceholderChart` with actual chart widgets

3. Load metrics on init

**Expected Results**:
- ✅ Task statistics page shows charts
- ✅ Placeholder is replaced
- ✅ Charts use real data
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View task statistics page
- Test: Verify charts are displayed
- Test: Verify placeholder is replaced

---

### Task 9: Add Chart Tooltips and Interactions

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Enhance charts with tooltips and interactive features.

**Files to Modify**:
- `lib/features/reports/presentation/widgets/status_distribution_pie_chart.dart`
- `lib/features/reports/presentation/widgets/status_distribution_bar_chart.dart`
- `lib/features/reports/presentation/widgets/priority_distribution_pie_chart.dart`
- `lib/features/reports/presentation/widgets/priority_distribution_bar_chart.dart`

**Implementation Steps**:
1. Enhance pie chart tooltips:
   ```dart
   pieTouchData: PieTouchData(
     touchCallback: (FlTouchEvent event, pieTouchResponse) {
       if (pieTouchResponse?.touchedSection != null) {
         final section = pieTouchResponse!.touchedSection;
         final status = TaskStatus.values[section.touchedSectionIndex];
         final count = metrics.tasksByStatus[status] ?? 0;
         final percentage = (count / metrics.totalTasks * 100);
         
         // Show tooltip or snackbar
         SnackbarService().showInfo(
           title: status.displayText,
           message: '$count tasks (${percentage.toStringAsFixed(1)}%)',
         );
       }
     },
   ),
   ```

2. Enhance bar chart tooltips:
   ```dart
   barTouchData: BarTouchData(
     touchTooltipData: BarTouchTooltipData(
       getTooltipColor: (group) => AppColors.surface,
       tooltipRoundedRadius: 8,
       tooltipPadding: EdgeInsets.all(8),
       getTooltipItem: (group, groupIndex, rod, rodIndex) {
         final status = TaskStatus.values[group.x.toInt()];
         final count = rod.toY.toInt();
         return BarTooltipItem(
           '${status.displayText}\n$count tasks',
           AppTextStyles.bodySmall,
         );
       },
     ),
   ),
   ```

3. Add highlight on tap (optional)

**Expected Results**:
- ✅ Chart tooltips work
- ✅ Interactions are responsive
- ✅ Tooltips are clear
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Tap on chart segments/bars
- Test: Verify tooltips are displayed
- Test: Verify interactions work

---

### Task 10: Integrate Charts with Filtering

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Ensure charts update when filters are applied.

**Files to Modify**:
- `lib/features/reports/presentation/widgets/task_distribution_chart_widget.dart`
- `lib/features/reports/presentation/controllers/overview_report_controller.dart`

**Implementation Steps**:
1. Charts should automatically update when `OverviewReportController.metrics` changes:
   ```dart
   // In TaskDistributionChartWidget
   GetBuilder<OverviewReportController>(
     builder: (ctrl) {
       final metrics = ctrl.metrics;
       if (metrics == null) return _buildEmptyState();
       
       return TaskDistributionChartWidget(metrics: metrics);
     },
   )
   ```

2. When filters change in controller, metrics are recalculated and charts update automatically

3. Ensure reactive updates work correctly

**Expected Results**:
- ✅ Charts update when filters change
- ✅ Data is accurate after filtering
- ✅ Updates are smooth
- ✅ No performance issues

**Test Criteria**:
- Manual test: Apply filters and verify charts update
- Test: Verify data accuracy after filtering

---

### Task 11: Add Chart Performance Optimization

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Optimize charts for large datasets.

**Files to Modify**:
- All chart widget files

**Implementation Steps**:
1. Use `RepaintBoundary` to prevent unnecessary repaints:
   ```dart
   RepaintBoundary(
     child: PieChart(...),
   )
   ```

2. Cache chart data if needed

3. Limit chart data points for very large datasets (if applicable)

4. Use `const` constructors where possible

**Expected Results**:
- ✅ Charts perform well with large datasets
- ✅ No performance issues
- ✅ UI remains responsive

**Test Criteria**:
- Performance test: Test with 1000+ tasks
- Test: Verify charts render quickly
- Test: Verify UI remains responsive

---

### Task 12: Add Chart Export Functionality (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add ability to export charts as images (optional enhancement).

**Files to Create/Modify**:
- `lib/features/reports/presentation/widgets/chart_export_button.dart` (new file)
- Chart widget files

**Implementation Steps**:
1. Add export button to chart widgets:
   ```dart
   IconButton(
     icon: Icon(Icons.download),
     onPressed: () => _exportChart(),
     tooltip: AppStrings.exportChart,
   ),
   ```

2. Use `RepaintBoundary` and `RenderRepaintBoundary` to capture chart as image:
   ```dart
   Future<void> _exportChart() async {
     final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
         as RenderRepaintBoundary?;
     if (boundary == null) return;
     
     final image = await boundary.toImage();
     final byteData = await image.toByteData(format: ImageByteFormat.png);
     // Save or share image
   }
   ```

3. Use `share_plus` package for sharing

**Expected Results**:
- ✅ Chart export works
- ✅ Images are clear
- ✅ Export is user-friendly

**Test Criteria**:
- Manual test: Export chart
- Test: Verify image is generated
- Test: Verify image is clear

---

### Task 13: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for chart widgets.

**Files to Create**:
- `test/features/reports/presentation/widgets/status_distribution_pie_chart_test.dart`
- `test/features/reports/presentation/widgets/status_distribution_bar_chart_test.dart`
- `test/features/reports/presentation/widgets/priority_distribution_pie_chart_test.dart`
- `test/features/reports/presentation/widgets/priority_distribution_bar_chart_test.dart`
- `test/features/reports/presentation/widgets/chart_view_switcher_test.dart`

**Implementation Steps**:
1. Test chart widgets:
   - Test chart rendering
   - Test empty state
   - Test data accuracy
   - Test color matching

2. Test view switcher:
   - Test view switching
   - Test state management

3. Test interactions:
   - Test tooltips
   - Test touch callbacks

**Expected Results**:
- ✅ Unit tests cover chart widgets
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Status Distribution Pie Chart Widget (Critical - Core Feature)
2. **Task 2**: Create Status Distribution Bar Chart Widget (Critical - Core Feature)
3. **Task 3**: Create Priority Distribution Pie Chart Widget (High Priority - Core Feature)
4. **Task 4**: Create Priority Distribution Bar Chart Widget (High Priority - Core Feature)
5. **Task 6**: Create Combined Chart Widget with View Switcher (High Priority - Integration)
6. **Task 7**: Update Report Analytics Page with Charts (High Priority - UI Integration)
7. **Task 8**: Update Task Statistics Page with Charts (High Priority - UI Integration)
8. **Task 5**: Create Chart View Switcher Widget (Medium Priority - Feature Enhancement)
9. **Task 9**: Add Chart Tooltips and Interactions (Medium Priority - UX Enhancement)
10. **Task 10**: Integrate Charts with Filtering (Medium Priority - Feature Enhancement)
11. **Task 13**: Add Unit Tests (Medium Priority - Quality Assurance)
12. **Task 11**: Add Chart Performance Optimization (Low Priority - Performance Enhancement)
13. **Task 12**: Add Chart Export Functionality (Low Priority - Optional Enhancement)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Status distribution pie chart exists
- ✅ Status distribution bar chart exists
- ✅ Priority distribution pie chart exists
- ✅ Priority distribution bar chart exists
- ✅ Chart view switcher exists
- ✅ Charts are displayed in report analytics page
- ✅ Charts are displayed in task statistics page
- ✅ Chart tooltips/interactions work
- ✅ Charts integrate with filtering
- ✅ Empty state is handled
- ✅ Performance is acceptable
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Chart colors match enum colors
- ✅ No known bugs or issues

---

## Dependencies

- **Chart Libraries**: `fl_chart: ^0.66.0` and `syncfusion_flutter_charts: ^23.2.7` (already in pubspec.yaml)
- **Task Aggregation Metrics**: From Report Overview Aggregation feature
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **Task Enums**: Must use enums from `task_enums.dart` for colors and labels
- **OverviewReportController**: Required for getting aggregation metrics

---

## Notes

1. **Chart Libraries**: Both `fl_chart` and `syncfusion_flutter_charts` are available. Choose one library for consistency (recommend `fl_chart` for simplicity).

2. **Enum Colors**: Critical to use `TaskStatus.color` and `TaskPriority.color` from enums for consistency.

3. **Placeholders**: Multiple placeholder widgets exist and need to be replaced with actual chart implementations.

4. **Integration**: Charts need to be integrated with:
   - Task aggregation data (from Report Overview Aggregation feature)
   - Report analytics page
   - Task statistics page
   - Filtering system

5. **Performance**: For large datasets, consider:
   - Using `RepaintBoundary` to prevent unnecessary repaints
   - Caching chart data
   - Limiting data points if needed

6. **Empty State**: All charts should handle empty data gracefully with clear messages.

---

## Related Documentation

- `REPORTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `REPORT_CHARTS_TEST_CASES.md` - Test cases for this feature
- `REPORT_OVERVIEW_AGGREGATION_TASKS.md` - Task aggregation feature (prerequisite)
- `docs/v1/feature_checklists/reports/reports.md` - Report requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `lib/core/constants/task_enums.dart` - Task enums with colors
