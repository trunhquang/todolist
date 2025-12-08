import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/dashboard_controller.dart';

class TDRecentTasksSection extends StatelessWidget {
  const TDRecentTasksSection({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tasks,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: controller.recentTasks
                  .map((task) => _TDDashboardTaskCard(task: task))
                  .toList(),
            )),
      ],
    );
  }
}

class _TDDashboardTaskCard extends StatelessWidget {
  const _TDDashboardTaskCard({required this.task});

  final Map<String, String> task;

  @override
  Widget build(BuildContext context) {
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
