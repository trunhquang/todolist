import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/td_app_bar.dart';
import '../../../core/widgets/td_button.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';

class PermissionManagementPage extends StatefulWidget {
  const PermissionManagementPage({super.key});

  @override
  State<PermissionManagementPage> createState() => _PermissionManagementPageState();
}

class _PermissionManagementPageState extends State<PermissionManagementPage> {
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
  final _searchController = TextEditingController();

  // Available permissions
  final List<PermissionItem> _availablePermissions = [
    PermissionItem(
      id: 'create_task',
      name: AppStrings.createTask,
      description: AppStrings.createTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: 'edit_task',
      name: AppStrings.editTask,
      description: AppStrings.editTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: 'delete_task',
      name: AppStrings.deleteTask,
      description: AppStrings.deleteTaskPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: 'view_tasks',
      name: AppStrings.viewTasks,
      description: AppStrings.viewTasksPermissionDescription,
      category: 'Tasks',
    ),
    PermissionItem(
      id: 'manage_users',
      name: AppStrings.manageUsers,
      description: AppStrings.manageUsersPermissionDescription,
      category: 'Users',
    ),
    PermissionItem(
      id: 'manage_workspace',
      name: AppStrings.manageWorkspace,
      description: AppStrings.manageWorkspacePermissionDescription,
      category: 'Workspace',
    ),
    PermissionItem(
      id: 'view_analytics',
      name: AppStrings.viewAnalytics,
      description: AppStrings.viewAnalyticsPermissionDescription,
      category: 'Analytics',
    ),
    PermissionItem(
      id: 'manage_permissions',
      name: AppStrings.managePermissions,
      description: AppStrings.managePermissionsPermissionDescription,
      category: 'Permissions',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPermissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPermissions() async {
    await _workspaceController.loadWorkspaceMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(
        title: AppStrings.permissionManagement,
        showBackButton: true,
        onBackPressed: () => NavigationService().back<void>(),
      ),
      body: Obx(() {
        if (_workspaceController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final members = _workspaceController.workspaceMembers;
        final filteredMembers = _filterMembers(members);

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchUsers,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            
            // Members List
            Expanded(
              child: filteredMembers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        return _buildMemberPermissionCard(member);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
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

  Widget _buildMemberPermissionCard(dynamic member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: member.profileImageUrl != null
              ? NetworkImage(member.profileImageUrl)
              : null,
          child: member.profileImageUrl == null
              ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?')
              : null,
        ),
        title: Text(member.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            const SizedBox(height: 4),
            _buildRoleChip(member.role),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.permissions,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPermissionGrid(member),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color chipColor;
    switch (role.toLowerCase()) {
      case 'admin':
        chipColor = Colors.blue;
        break;
      case 'member':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        role.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPermissionGrid(dynamic member) {
    // Group permissions by category
    final Map<String, List<PermissionItem>> groupedPermissions = {};
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
              entry.key,
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
                return _buildPermissionChip(permission, hasPermission, member);
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPermissionChip(PermissionItem permission, bool hasPermission, dynamic member) {
    return FilterChip(
      label: Text(permission.name),
      selected: hasPermission,
      onSelected: (selected) => _handlePermissionToggle(member, permission.id, selected),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      tooltip: permission.description,
    );
  }

  bool _userHasPermission(dynamic member, String permissionId) {
    // This is a simplified implementation
    // In a real app, you would check the user's actual permissions
    if (member.role.toLowerCase() == 'admin') {
      return true; // Admins have all permissions
    }
    
    // Default permissions for members
    final memberPermissions = ['view_tasks', 'create_task', 'edit_task'];
    return memberPermissions.contains(permissionId);
  }

  List<dynamic> _filterMembers(List<dynamic> members) {
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) return members;
    
    return members.where((member) {
      return member.name.toLowerCase().contains(searchQuery) ||
             member.email.toLowerCase().contains(searchQuery) ||
             member.role.toLowerCase().contains(searchQuery);
    }).toList();
  }

  Future<void> _handlePermissionToggle(dynamic member, String permissionId, bool granted) async {
    try {
      if (granted) {
        await _workspaceController.grantPermission(member.id, permissionId);
      } else {
        await _workspaceController.revokePermission(member.id, permissionId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              granted 
                  ? AppStrings.permissionGranted 
                  : AppStrings.permissionRevoked,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.failedToUpdatePermission}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class PermissionItem {
  final String id;
  final String name;
  final String description;
  final String category;

  PermissionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });
}
