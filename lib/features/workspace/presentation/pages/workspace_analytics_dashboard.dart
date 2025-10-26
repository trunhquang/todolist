import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Analytics dashboard for workspace metrics and insights
class WorkspaceAnalyticsDashboard extends StatefulWidget {
  const WorkspaceAnalyticsDashboard({super.key});

  @override
  State<WorkspaceAnalyticsDashboard> createState() => _WorkspaceAnalyticsDashboardState();
}

class _WorkspaceAnalyticsDashboardState extends State<WorkspaceAnalyticsDashboard> {
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
  
  // Analytics data
  final RxMap<String, dynamic> _workspaceMetrics = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> _userMetrics = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> _performanceMetrics = <String, dynamic>{}.obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    _isLoading.value = true;
    
    try {
      // Load workspace metrics
      await _loadWorkspaceMetrics();
      
      // Load user metrics
      await _loadUserMetrics();
      
      // Load performance metrics
      await _loadPerformanceMetrics();
      
    } catch (e) {
      // Handle error
      print('Error loading analytics data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadWorkspaceMetrics() async {
    // Simulate loading workspace metrics
    await Future.delayed(const Duration(milliseconds: 500));
    
    _workspaceMetrics.assignAll({
      'totalWorkspaces': _workspaceController.workspaces.length,
      'personalWorkspaces': _workspaceController.workspaces
          .where((w) => w.type == WorkspaceType.personal)
          .length,
      'companyWorkspaces': _workspaceController.workspaces
          .where((w) => w.type == WorkspaceType.company)
          .length,
      'activeWorkspaces': _workspaceController.workspaces
          .where((w) => w.isActive)
          .length,
      'workspaceCreationRate': 0.85, // 85% success rate
      'averageWorkspaceSize': 12.5, // Average members per workspace
    });
  }

  Future<void> _loadUserMetrics() async {
    // Simulate loading user metrics
    await Future.delayed(const Duration(milliseconds: 300));
    
    _userMetrics.assignAll({
      'totalUsers': 156,
      'activeUsers': 142,
      'newUsersThisMonth': 23,
      'userRetentionRate': 0.91, // 91% retention
      'averageSessionDuration': 25.5, // minutes
      'userSatisfactionScore': 4.7, // out of 5
    });
  }

  Future<void> _loadPerformanceMetrics() async {
    // Simulate loading performance metrics
    await Future.delayed(const Duration(milliseconds: 200));
    
    _performanceMetrics.assignAll({
      'workspaceCreationTime': 2.3, // seconds
      'workspaceSwitchingTime': 0.8, // seconds
      'permissionCheckTime': 0.05, // seconds
      'dataSyncTime': 1.2, // seconds
      'appStartupTime': 3.1, // seconds
      'memoryUsage': 45.2, // MB
      'crashRate': 0.02, // 2% crash rate
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workspace Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
          ),
        ],
      ),
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewSection(),
              const SizedBox(height: 24),
              _buildWorkspaceMetricsSection(),
              const SizedBox(height: 24),
              _buildUserMetricsSection(),
              const SizedBox(height: 24),
              _buildPerformanceMetricsSection(),
              const SizedBox(height: 24),
              _buildChartsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOverviewSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Workspaces',
                    _workspaceMetrics['totalWorkspaces']?.toString() ?? '0',
                    Icons.work_outline,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Active Users',
                    _userMetrics['activeUsers']?.toString() ?? '0',
                    Icons.people_outline,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Success Rate',
                    '${(_workspaceMetrics['workspaceCreationRate'] * 100).toStringAsFixed(1)}%',
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'User Satisfaction',
                    '${_userMetrics['userSatisfactionScore']?.toStringAsFixed(1) ?? '0.0'}/5.0',
                    Icons.star_outline,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceMetricsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workspace Metrics',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'Personal Workspaces',
              _workspaceMetrics['personalWorkspaces']?.toString() ?? '0',
            ),
            _buildMetricRow(
              'Company Workspaces',
              _workspaceMetrics['companyWorkspaces']?.toString() ?? '0',
            ),
            _buildMetricRow(
              'Active Workspaces',
              _workspaceMetrics['activeWorkspaces']?.toString() ?? '0',
            ),
            _buildMetricRow(
              'Average Workspace Size',
              '${_workspaceMetrics['averageWorkspaceSize']?.toStringAsFixed(1) ?? '0.0'} members',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMetricsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Metrics',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'Total Users',
              _userMetrics['totalUsers']?.toString() ?? '0',
            ),
            _buildMetricRow(
              'New Users This Month',
              _userMetrics['newUsersThisMonth']?.toString() ?? '0',
            ),
            _buildMetricRow(
              'User Retention Rate',
              '${(_userMetrics['userRetentionRate'] * 100).toStringAsFixed(1)}%',
            ),
            _buildMetricRow(
              'Average Session Duration',
              '${_userMetrics['averageSessionDuration']?.toStringAsFixed(1) ?? '0.0'} min',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetricsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'Workspace Creation Time',
              '${_performanceMetrics['workspaceCreationTime']?.toStringAsFixed(1) ?? '0.0'}s',
            ),
            _buildMetricRow(
              'Workspace Switching Time',
              '${_performanceMetrics['workspaceSwitchingTime']?.toStringAsFixed(1) ?? '0.0'}s',
            ),
            _buildMetricRow(
              'Permission Check Time',
              '${_performanceMetrics['permissionCheckTime']?.toStringAsFixed(2) ?? '0.00'}s',
            ),
            _buildMetricRow(
              'Data Sync Time',
              '${_performanceMetrics['dataSyncTime']?.toStringAsFixed(1) ?? '0.0'}s',
            ),
            _buildMetricRow(
              'App Startup Time',
              '${_performanceMetrics['appStartupTime']?.toStringAsFixed(1) ?? '0.0'}s',
            ),
            _buildMetricRow(
              'Memory Usage',
              '${_performanceMetrics['memoryUsage']?.toStringAsFixed(1) ?? '0.0'} MB',
            ),
            _buildMetricRow(
              'Crash Rate',
              '${(_performanceMetrics['crashRate'] * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Charts & Trends',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildChartPlaceholder('Workspace Creation Trend'),
            const SizedBox(height: 16),
            _buildChartPlaceholder('User Activity Over Time'),
            const SizedBox(height: 16),
            _buildChartPlaceholder('Performance Metrics'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(String title) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Chart visualization would go here',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
