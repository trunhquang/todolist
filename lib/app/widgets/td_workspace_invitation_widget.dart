import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/app/routes/app_router.dart';
import 'package:todolist/app/widgets/td_button.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Widget to handle workspace invitations when user has no workspace
class TDCreateWorkspaceWidget extends StatelessWidget {
  const TDCreateWorkspaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceController>(
      builder: (controller) => Obx(() {
        // Only show create workspace widget if user has no workspace at all
        final hasWorkspace = controller.currentWorkspace.value != null;
        if (!hasWorkspace) {
          return _buildCreateWorkspaceWidget();
        }
        return const SizedBox.shrink();
      }),
    );
  }


  /// Build create workspace widget when no invitations
  Widget _buildCreateWorkspaceWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.workspace,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.enterWorkspaceDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TDButton(
              text: AppStrings.createWorkspace,
              onPressed: () async {
                await NavigationService().toNamed<void>(AppRouter.createWorkspace);
              },
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }

}
