import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/dashboard_controller.dart';

class TDQuickActionsSection extends StatelessWidget {
  const TDQuickActionsSection({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final title = controller.workspaceTitle.isEmpty
              ? AppStrings.I.overview
              : controller.workspaceTitle;
          final roleLabel = controller.workspaceRoleLabel;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.onBackground,
                ),
              ),
              if (roleLabel.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  roleLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        }),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TDDashboardQuickActionCard(
                icon: Icons.analytics,
                title: AppStrings.I.taskStatistics,
                subtitle: AppStrings.I.taskStatisticsSubtitle,
                onTap: () async {
                  await NavigationService().toNamed<void>(AppRouter.taskStatistics);
                },
              ),
            ),
            // Expanded(
            //   child: TDDashboardQuickActionCard(
            //     icon: Icons.assignment,
            //     title: AppStrings.I.reports,
            //     subtitle: AppStrings.I.createNewReport,
            //     onTap: () async {
            //       await NavigationService().toNamed<void>(AppRouter.reportCreate);
            //     },
            //   ),
            // ),
          ],
        ),
        // const SizedBox(height: 12),
        // Row(
        //   children: [
        //     Expanded(
        //       child: TDDashboardQuickActionCard(
        //         icon: Icons.analytics,
        //         title: AppStrings.I.taskStatistics,
        //         subtitle: AppStrings.I.taskStatisticsSubtitle,
        //         onTap: () async {
        //           await NavigationService().toNamed<void>(AppRouter.taskStatistics);
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: TDDashboardQuickActionCard(
        //         icon: Icons.cloud_sync_outlined,
        //         title: AppStrings.I.backupAndRestore,
        //         subtitle: AppStrings.I.backupAndRestoreSubtitle,
        //         onTap: () async {
        //           await NavigationService().toNamed<void>(AppRouter.backupRestore);
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TDDashboardQuickActionCard(
                icon: Icons.folder_open,
                title: AppStrings.I.projects,
                subtitle: AppStrings.I.manageProjects,
                onTap: () async {
                  await NavigationService().toNamed<void>(AppRouter.projects);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TDDashboardQuickActionCard(
                icon: Icons.list_alt,
                title: AppStrings.I.tasks,
                subtitle: AppStrings.I.manageTasks,
                onTap: () async {
                  await NavigationService().toNamed<void>(AppRouter.tasks);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TDDashboardQuickActionCard extends StatelessWidget {
  const TDDashboardQuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
}
