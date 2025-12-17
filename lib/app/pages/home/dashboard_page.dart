import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/dashboard_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import 'widgets/td_invitation_notification_widget.dart';
import 'widgets/td_recent_tasks_section.dart';
import 'widgets/td_quick_actions_section.dart';
import 'widgets/td_welcome_section.dart';
import 'widgets/td_workspace_invitation_widget.dart';
import 'widgets/td_workspace_management_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.I.dashboard),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
                onPressed: () async {
                  await NavigationService().toNamed<void>(AppRouter.notificationSettings);
                },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
                onPressed: () async {
                  await NavigationService().toNamed<void>(AppRouter.profilePage);
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
            const TDWelcomeSection(),
            const SizedBox(height: 24),
            // Invitation Notification Banner
            const TDInvitationNotificationWidget(),
            // Workspace Invitation or Create Workspace CTA
            const TDCreateWorkspaceWidget(),
            const SizedBox(height: 16),
            // Quick Actions
            TDQuickActionsSection(controller: controller),
            const SizedBox(height: 24),
            // Workspace Management Section (only for account holders and admins)
            TDWorkspaceManagementSection(controller: controller),
            const SizedBox(height: 24),
            TDRecentTasksSection(controller: controller),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NavigationService().toNamed<void>(AppRouter.taskCreate);
        },
        tooltip: AppStrings.I.newTask,
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
