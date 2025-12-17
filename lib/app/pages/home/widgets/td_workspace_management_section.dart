import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/dashboard_controller.dart';
import 'td_quick_actions_section.dart';

class TDWorkspaceManagementSection extends StatelessWidget {
  const TDWorkspaceManagementSection({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final wsCtrl = Get.find<WorkspaceController>();
      final hasWorkspace = wsCtrl.currentWorkspace.value != null;
      if (!hasWorkspace) return const SizedBox.shrink();
      return FutureBuilder<bool>(
        future: controller.canManageWorkspace(),
        builder: (context, snapshot) {
          final canManageWorkspace = snapshot.data ?? false;
          if (!canManageWorkspace) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.I.workspaceManagement,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TDDashboardQuickActionCard(
                      icon: Icons.settings,
                      title: AppStrings.I.workspaceSettings,
                      subtitle: AppStrings.I.manageWorkspaceSettings,
                      onTap: () async {
                        await NavigationService()
                            .toNamed<void>(AppRouter.workspaceSettings);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TDDashboardQuickActionCard(
                      icon: Icons.people,
                      title: AppStrings.I.userManagement,
                      subtitle: AppStrings.I.manageWorkspaceMember,
                      onTap: () async {
                        await NavigationService()
                            .toNamed<void>(AppRouter.userManagement);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TDDashboardQuickActionCard(
                      icon: Icons.admin_panel_settings,
                      title: AppStrings.I.manageUserPermissions,
                      subtitle: AppStrings.I.workspaceAdminTools,
                      onTap: () async {
                        await NavigationService()
                            .toNamed<void>(AppRouter.permissionManagement);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TDDashboardQuickActionCard(
                      icon: Icons.group,
                      title: AppStrings.I.teamManagement,
                      subtitle: AppStrings.I.manageTeamMembers,
                      onTap: () async {
                        await NavigationService()
                            .toNamed<void>(AppRouter.teamManagement);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }
}
