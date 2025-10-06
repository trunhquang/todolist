import 'package:flutter/material.dart';
import 'package:todolist/app/routes/app_router.dart';

import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/td_button.dart';
import '../../../core/services/navigation_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                    AppColors.primary.withOpacity(0.8),
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
                      color: AppColors.onPrimary.withOpacity(0.9),
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
                    onTap: () {
                      // TODO: Navigate to create task
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.assignment,
                    title: 'Daily Report',
                    subtitle: 'Submit daily report',
                    onTap: () {
                      // TODO: Navigate to daily report
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
                    title: 'Analytics',
                    subtitle: 'View performance',
                    onTap: () {
                      // TODO: Navigate to analytics
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App settings',
                    onTap: () {
                      // TODO: Navigate to settings
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
            // Sign Out Button
            Center(
              child: TDButton(
                text: 'Sign Out',
                onPressed: () async {
                  // TODO: Implement sign out
                  await NavigationService.instance.offAllNamed<void>(AppRouter.login);
                },
                variant: TDButtonVariant.outlined,
                icon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create task
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
              color: Colors.black.withOpacity(0.05),
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
                color: AppColors.primary.withOpacity(0.1),
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
      children: tasks.map((task) => _buildTaskCard(task)).toList(),
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
            color: Colors.black.withOpacity(0.05),
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
                        color: _getTypeColor(task['type']!).withOpacity(0.1),
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
                        color: _getStatusColor(task['status']!).withOpacity(0.1),
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
