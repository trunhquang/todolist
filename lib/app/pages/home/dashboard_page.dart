import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/routes/app_router.dart';

import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/td_button.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/recurring_task_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _checkAndGenerateRecurringTasks();
  }

  /// Check and generate recurring tasks on app startup
  Future<void> _checkAndGenerateRecurringTasks() async {
    try {
      final recurringTaskService = Get.find<RecurringTaskService>();
      
      // Check if generation should run
      final shouldRun = await recurringTaskService.shouldRunGeneration();
      if (shouldRun) {
        await recurringTaskService.generateRecurringTasks();
        await recurringTaskService.markGenerationRun();
      }
    } catch (e) {
      // Silent fail for background generation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${AppConstants.appName}!',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your tasks and daily reports efficiently',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.add_task,
                    title: 'New Task',
                    subtitle: 'Create a new task',
                    onTap: () async {
                      await NavigationService().toNamed<void>(AppRouter.taskEdit);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.assignment,
                    title: 'Daily Report',
                    subtitle: 'Submit daily report',
                    onTap: () async {
                      await NavigationService().toNamed<void>(AppRouter.reportCreate);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.analytics,
                    title: AppStrings.projects,
                    subtitle: AppStrings.manageProjects,
                    onTap: () async {
                      await NavigationService().toNamed<void>(AppRouter.projects);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.cloud_sync_outlined,
                    title: AppStrings.backupAndRestore,
                    subtitle: AppStrings.backupAndRestoreSubtitle,
                    onTap: () async {
                      await NavigationService().toNamed<void>(AppRouter.backupRestore);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent Tasks
            Text(
              'Recent Tasks',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            _buildTaskList(),
            const SizedBox(height: 24),
            // Backup & Sign Out Buttons
            Center(
              child: Column(
                children: [
                  TDButton(
                    text: AppStrings.backupToOneDrive,
                    onPressed: () async {
                      try {
                        SnackbarService().showLoading(
                          title: AppStrings.backup,
                          message: AppStrings.exportingDataToOneDrive);
                        await BackupService().exportCompanyDataToOneDrive();
                        SnackbarService().showSuccess(
                          title: AppStrings.backupComplete,
                          message: AppStrings.dataExportedToOneDriveSuccessfully);
                      } catch (e) {
                        SnackbarService().showError(
                          title: AppStrings.backupFailed,
                          message: e.toString());
                      }
                    },
                    icon: Icons.cloud_upload_outlined,
                  ),
                  const SizedBox(height: 12),
                  TDButton(
                    text: AppStrings.logout,
                    onPressed: () async {
                      await NavigationService().offAllNamed<void>(AppRouter.login);
                    },
                    variant: TDButtonVariant.outlined,
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NavigationService().toNamed<void>(AppRouter.taskEdit);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    // TODO: Replace with actual task data
    final tasks = [
      {
        'title': 'Complete project proposal',
        'type': 'Project',
        'status': 'In Progress',
        'priority': 'High',
      },
      {
        'title': 'Daily standup meeting',
        'type': 'Daily',
        'status': 'Pending',
        'priority': 'Medium',
      },
      {
        'title': 'Weekly team review',
        'type': 'Weekly',
        'status': 'Completed',
        'priority': 'Low',
      },
    ];

    return Column(
      children: tasks.map(_buildTaskCard).toList(),
    );
  }

  Widget _buildTaskCard(Map<String, String> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getPriorityColor(task['priority']!),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(task['type']!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task['type']!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _getTypeColor(task['type']!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(task['status']!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task['status']!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _getStatusColor(task['status']!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.highPriority;
      case 'medium':
        return AppColors.mediumPriority;
      case 'low':
        return AppColors.lowPriority;
      default:
        return AppColors.mediumPriority;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'daily':
        return AppColors.dailyTask;
      case 'weekly':
        return AppColors.weeklyTask;
      case 'monthly':
        return AppColors.monthlyTask;
      case 'project':
        return AppColors.projectTask;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.completedStatus;
      case 'in progress':
        return AppColors.inProgressStatus;
      case 'pending':
        return AppColors.pendingStatus;
      default:
        return AppColors.pendingStatus;
    }
  }
}
