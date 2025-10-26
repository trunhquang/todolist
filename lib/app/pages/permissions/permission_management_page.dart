import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../features/workspace/domain/entities/workspace_permissions.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../widgets/td_app_bar.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';
import '../../widgets/td_loading_indicator.dart';
import '../../widgets/td_chip.dart';
import '../../widgets/td_card.dart';

class PermissionManagementPage extends StatelessWidget {
  const PermissionManagementPage({super.key});

  WorkspaceController get _workspaceController => Get.find<WorkspaceController>();
  // Local reactive search query state
  static final RxString _searchQuery = ''.obs;
  static final RxBool _canAssign = false.obs;

  // Available permissions
  static const List<PermissionItem> _availablePermissions = <PermissionItem>[
    PermissionItem(
      id: WorkspacePermissions.createTasks,
      name: AppStrings.createTask,
      description: AppStrings.createTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: WorkspacePermissions.updateTaskStatus,
      name: AppStrings.editTask,
      description: AppStrings.editTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: WorkspacePermissions.deleteTasks,
      name: AppStrings.deleteTask,
      description: AppStrings.deleteTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: WorkspacePermissions.manageUsers,
      name: AppStrings.manageUsers,
      description: AppStrings.manageUsersPermissionDescription,
      category: 'Users',
    ),
    PermissionItem(
      id: WorkspacePermissions.manageWorkspace,
      name: AppStrings.manageWorkspace,
      description: AppStrings.manageWorkspacePermissionDescription,
      category: 'Workspace',
    ),
    PermissionItem(
      id: WorkspacePermissions.viewAnalytics,
      name: AppStrings.viewAnalytics,
      description: AppStrings.viewAnalyticsPermissionDescription,
      category: 'Analytics',
    ),
    PermissionItem(
      id: WorkspacePermissions.assignPermissions,
      name: AppStrings.managePermissions,
      description: AppStrings.managePermissionsPermissionDescription,
      category: 'Permissions',
    ),
  ];

  Future<void> _loadUserPermissions() async {
    await _workspaceController.loadWorkspaceMembers();
    final assign = await _workspaceController.hasPermission(WorkspacePermissions.assignPermissions);
    _canAssign.value = assign;
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial load
    _loadUserPermissions();

    return Scaffold(
      appBar: const TDAppBar(
        title: AppStrings.permissionManagement,
        // Rely on default back behavior via NavigationService elsewhere
      ),
      body: Obx(() {
        if (_workspaceController.isLoading) {
          return const Center(child: TDLoadingIndicator());
        }

        final members = _workspaceController.workspaceMembers;
        final filteredMembers = _filterMembers(members);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TDTextField(
                hint: AppStrings.searchUsers,
                prefixIcon: Icons.search,
                onChanged: (value) => _searchQuery.value = value,
              ),
            ),
            Expanded(
              child: filteredMembers.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        return _buildMemberPermissionCard(context, member);
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: TDButton(
        text: AppStrings.back,
        variant: TDButtonVariant.outlined,
        onPressed: () async => NavigationService().back<void>(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.security_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noUsersFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.addUsersToManagePermissions,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberPermissionCard(BuildContext context, WorkspaceMember member) {
    return TDCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(member.userId, style: Theme.of(context).textTheme.titleMedium),
              _buildRoleChip(member.role),
            ],
          ),
          const SizedBox(height: 8),
          Text(AppStrings.permissions, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildPermissionGrid(context, member),
        ],
      ),
    );
  }

  Widget _buildRoleChip(WorkspaceRole role) {
    final isAdmin = role == WorkspaceRole.admin || role == WorkspaceRole.accountHolder;
    return TDChip(
      label: role.displayName,
      type: isAdmin ? TDChipType.info : TDChipType.secondary,
    );
  }

  Widget _buildPermissionGrid(BuildContext context, WorkspaceMember member) {
    // Group permissions by category
    final groupedPermissions = <String, List<PermissionItem>>{};
    for (final permission in _availablePermissions) {
      groupedPermissions.putIfAbsent(permission.category, () => []);
      groupedPermissions[permission.category]!.add(permission);
    }

    return Column(
      children: groupedPermissions.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _mapCategoryToAppString(entry.key),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entry.value.map((permission) {
                final hasPermission = _userHasPermission(member, permission.id);
                return _buildPermissionChip(context, permission, hasPermission, member);
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPermissionChip(BuildContext context, PermissionItem permission, bool hasPermission, WorkspaceMember member) {
    return Obx(() {
      final enabled = _canAssign.value;
      return TDChip(
        label: permission.name,
        isSelected: hasPermission,
        onTap: enabled ? () => _handlePermissionToggle(member, permission.id, !hasPermission) : null,
      );
    });
  }

  bool _userHasPermission(WorkspaceMember member, String permissionId) {
    if (member.isAdmin || member.isAccountHolder) {
      return true;
    }
    return member.permissions.contains(permissionId);
  }

  List<WorkspaceMember> _filterMembers(List<WorkspaceMember> members) {
    final query = _searchQuery.value.toLowerCase();
    if (query.isEmpty) return members;

    return members.where((member) {
      final roleName = member.role.displayName.toLowerCase();
      return member.userId.toLowerCase().contains(query) || roleName.contains(query);
    }).toList();
  }

  Future<void> _handlePermissionToggle(WorkspaceMember member, String permissionId, bool granted) async {
    try {
      if (granted) {
        await _workspaceController.grantPermission(member.userId, permissionId);
      } else {
        await _workspaceController.revokePermission(member.userId, permissionId);
      }

      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: granted ? AppStrings.permissionGranted : AppStrings.permissionRevoked,
      );
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: '${AppStrings.failedToUpdatePermission}: $e',
      );
    }
  }

  String _mapCategoryToAppString(String raw) {
    switch (raw) {
      case 'Tasks':
        return AppStrings.tasks;
      case 'Users':
        return AppStrings.manageUsers;
      case 'Workspace':
        return AppStrings.manageWorkspace;
      case 'Analytics':
        return AppStrings.viewAnalytics;
      case 'Permissions':
        return AppStrings.managePermissions;
      default:
        return raw;
    }
  }
}

class PermissionItem {

  const PermissionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });
  final String id;
  final String name;
  final String description;
  final String category;
}
