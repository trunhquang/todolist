import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Page for managing workspace settings and members
class WorkspaceManagementPage extends StatelessWidget {
  final Workspace workspace;

  const WorkspaceManagementPage({
    super.key,
    required this.workspace,
  });

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = Get.find<WorkspaceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.manageWorkspace),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Workspace Info Card
              _buildWorkspaceInfoCard(),
              const SizedBox(height: 24),
              // Workspace Settings
              _buildWorkspaceSettingsSection(controller),
              const SizedBox(height: 24),
              // Workspace Members
              _buildWorkspaceMembersSection(controller),
              const SizedBox(height: 24),
              // Danger Zone
              _buildDangerZoneSection(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspaceInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    workspace.initials,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspace.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workspace.type.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (workspace.hasDescription) ...[
            const SizedBox(height: 16),
            Text(
              workspace.description!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                '${AppStrings.workspaceCreatedAt}: ${_formatDate(workspace.createdAt)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceSettingsSection(WorkspaceController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.workspaceSettings,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.edit,
                title: AppStrings.editWorkspace,
                subtitle: 'Update workspace name and description',
                onTap: () => _editWorkspace(controller),
              ),
              const Divider(),
              _buildSettingsItem(
                icon: Icons.people,
                title: AppStrings.workspaceMembers,
                subtitle: 'Manage workspace members and permissions',
                onTap: () => _manageMembers(controller),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceMembersSection(WorkspaceController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.workspaceMembers,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final members = controller.workspaceMembers;
          if (members.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outline),
              ),
              child: Center(
                child: Text(
                  'No members found',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: members.asMap().entries.map((entry) {
                final index = entry.key;
                final member = entry.value;
                return Column(
                  children: [
                    _buildMemberItem(member),
                    if (index < members.length - 1) const Divider(),
                  ],
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDangerZoneSection(WorkspaceController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.deleteWorkspace,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone. All workspace data will be permanently deleted.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TDButton(
                text: AppStrings.deleteWorkspace,
                onPressed: () => _confirmDeleteWorkspace(controller),
                variant: TDButtonVariant.outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.onBackground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildMemberItem(WorkspaceMember member) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          member.userId.substring(0, 1).toUpperCase(),
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        member.userId, // TODO: Get actual user name
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.onBackground,
        ),
      ),
      subtitle: Text(
        member.role.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.more_vert,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editWorkspace(WorkspaceController controller) {
    // TODO: Navigate to edit workspace page
    SnackbarService().showInfo(
      title: 'Info',
      message: 'Edit workspace functionality coming soon',
    );
  }

  void _manageMembers(WorkspaceController controller) {
    // TODO: Navigate to manage members page
    SnackbarService().showInfo(
      title: 'Info',
      message: 'Manage members functionality coming soon',
    );
  }

  void _confirmDeleteWorkspace(WorkspaceController controller) {
    // TODO: Show confirmation dialog
    SnackbarService().showInfo(
      title: 'Info',
      message: 'Delete workspace confirmation coming soon',
    );
  }
}
