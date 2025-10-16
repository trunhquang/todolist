import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Workspace selector widget for switching between workspaces
class WorkspaceSelector extends StatelessWidget {
  const WorkspaceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = Get.find<WorkspaceController>();

    return Obx(() {
      final workspaces = controller.workspaces;
      final currentWorkspace = controller.currentWorkspace.value;

      if (workspaces.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.currentWorkspace,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: workspaces.asMap().entries.map((entry) {
                final index = entry.key;
                final workspace = entry.value;
                final isSelected = currentWorkspace?.id == workspace.id;
                
                return Column(
                  children: [
                    _buildWorkspaceItem(
                      workspace: workspace,
                      isSelected: isSelected,
                      onTap: () => controller.switchToWorkspace(workspace.id),
                    ),
                    if (index < workspaces.length - 1) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Create new workspace button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _createNewWorkspace(),
              icon: const Icon(Icons.add),
              label: Text(AppStrings.createWorkspace),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.currentWorkspace,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.work_outline,
                size: 48,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.noWorkspacesFound,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first workspace to get started',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _createNewWorkspace(),
                  icon: const Icon(Icons.add),
                  label: Text(AppStrings.createWorkspace),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceItem({
    required Workspace workspace,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            workspace.initials,
            style: AppTextStyles.titleSmall.copyWith(
              color: isSelected ? AppColors.primary : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        workspace.name,
        style: AppTextStyles.titleSmall.copyWith(
          color: isSelected ? AppColors.primary : AppColors.onBackground,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        workspace.type.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 20,
            )
          : Icon(
              Icons.radio_button_unchecked,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
      onTap: onTap,
    );
  }

  void _createNewWorkspace() {
    // TODO: Navigate to create workspace page
    // NavigationService().toNamed<void>(AppRoutes.createWorkspace);
    Get.snackbar(
      'Info',
      'Create workspace functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
