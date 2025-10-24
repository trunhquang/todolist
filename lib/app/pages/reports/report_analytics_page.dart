import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/report_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/td_button.dart';
import '../../constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportAnalyticsPage extends StatefulWidget {
  const ReportAnalyticsPage({super.key});

  @override
  State<ReportAnalyticsPage> createState() => _ReportAnalyticsPageState();
}

class _ReportAnalyticsPageState extends State<ReportAnalyticsPage> {
  final _reportService = Get.find<ReportService>();
  final _storageService = Get.find<StorageService>();
  
  final _isLoading = false.obs;
  final _selectedPeriod = 'week'.obs;
  final _analytics = <String, dynamic>{}.obs;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      _isLoading.value = true;
      final workspaceId = _storageService.getWorkspaceId();

      if (workspaceId == null) return;

      final endDate = DateTime.now();
      // final startDate = _getStartDate(endDate); // TODO: Use for date range filtering
      
      // Load department reports for the selected period
        final departmentData = await _reportService.aggregateDepartmentReports(
            workspaceId: workspaceId,
          date: endDate);
        _analytics.assignAll(departmentData);

    } catch (e) {
      SnackbarService().showError(
        title: 'Error',
        message: 'Failed to load analytics: $e',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  DateTime _getStartDate(DateTime endDate) {
    switch (_selectedPeriod.value) {
      case 'week':
        return endDate.subtract(const Duration(days: 7));
      case 'month':
        return endDate.subtract(const Duration(days: 30));
      case 'quarter':
        return endDate.subtract(const Duration(days: 90));
      default:
        return endDate.subtract(const Duration(days: 7));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Report Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: AppStrings.openPowerBiDashboard,
            onPressed: () async {
              final uri = Uri.parse(AppConstants.powerBiDashboardUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                SnackbarService().showError(title: AppStrings.error, message: 'Cannot open Power BI');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Period Selector
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              children: [
                Text(
                  'Period: ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Obx(() => DropdownButton<String>(
                  value: _selectedPeriod.value,
                  items: const [
                    DropdownMenuItem(value: 'week', child: Text('Last 7 days')),
                    DropdownMenuItem(value: 'month', child: Text('Last 30 days')),
                    DropdownMenuItem(value: 'quarter', child: Text('Last 90 days')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _selectedPeriod.value = value;
                      _loadAnalytics();
                    }
                  },
                )),
                const Spacer(),
                TDButton(
                  text: 'Refresh',
                  onPressed: _loadAnalytics,
                  variant: TDButtonVariant.outlined,
                ),
              ],
            ),
          ),

          // Analytics Content
          Expanded(
            child: Obx(() {
              if (_isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewCards(),
                    const SizedBox(height: 24),
                    _buildReportTrends(),
                    const SizedBox(height: 24),
                    _buildTaskCompletionStats(),
                    const SizedBox(height: 24),
                    _buildDepartmentComparison(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Reports',
                value: '${_analytics['totalReports'] ?? 0}',
                icon: Icons.assignment,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Completed Tasks',
                value: '${_analytics['totalCompletedTasks'] ?? 0}',
                icon: Icons.task_alt,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Avg. Tasks/Report',
                value: '${_analytics['avgTasksPerReport']?.toStringAsFixed(1) ?? '0.0'}',
                icon: Icons.analytics,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Submission Rate',
                value: '${(_analytics['submissionRate'] ?? 0.0).toStringAsFixed(1)}%',
                icon: Icons.check_circle,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report Trends',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              Icon(
                Icons.trending_up,
                size: 48,
                color: AppColors.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Trend Analysis',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Report submission trends and patterns will be displayed here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCompletionStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Completion by Type',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              Icon(
                Icons.pie_chart,
                size: 48,
                color: AppColors.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Task Type Distribution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Task completion statistics by type will be displayed here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department Performance',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              Icon(
                Icons.business,
                size: 48,
                color: AppColors.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Department Comparison',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Department performance comparison will be displayed here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
