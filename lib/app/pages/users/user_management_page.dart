import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../widgets/td_app_bar.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
  final _searchController = TextEditingController();
  final _inviteEmailController = TextEditingController();
  final _inviteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadWorkspaceMembers();
  }

  /// Check if user has permission to access user management
  Future<void> _checkPermissions() async {
    try {
      final canManageUsers = await _workspaceController.hasPermission('manage_users');
      if (!canManageUsers) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inviteEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspaceMembers() async {
    await _workspaceController.loadWorkspaceMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(
        title: AppStrings.userManagement,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService().back<void>(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showInviteUserDialog,
            tooltip: AppStrings.inviteUser,
          ),
        ],
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
              child: TDTextField(
                controller: _searchController,
                hint: AppStrings.searchUsers,
                prefixIcon: Icons.search,
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
                        return _buildMemberCard(member);
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
            Icons.people_outline,
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
            AppStrings.inviteUsersToGetStarted,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TDButton(
            text: AppStrings.inviteUser,
            onPressed: _showInviteUserDialog,
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(WorkspaceMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            member.userId.isNotEmpty ? member.userId[0].toUpperCase() : '?',
          ),
        ),
        title: Text(member.userId),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleChip(member.role),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMemberAction(value, member),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit_role',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text(AppStrings.editRole),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.remove_circle, color: Colors.red),
                  SizedBox(width: 8),
                  Text(AppStrings.removeUser, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChip(WorkspaceRole role) {
    final display = role.displayName;
    final Color chipColor = switch (role) {
      WorkspaceRole.admin => Colors.blue,
      WorkspaceRole.member => Colors.green,
      _ => Colors.grey,
    };

    return Chip(
      label: Text(
        display.toUpperCase(),
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

  List<WorkspaceMember> _filterMembers(List<WorkspaceMember> members) {
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) return members;
    
    return members.where((member) {
      final roleName = member.role.displayName.toLowerCase();
      return member.userId.toLowerCase().contains(searchQuery) ||
             roleName.contains(searchQuery);
    }).toList();
  }

  void _showInviteUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.inviteUser),
        content: Form(
          key: _inviteFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDTextField(
                controller: _inviteEmailController,
                label: AppStrings.emailAddress,
                hint: AppStrings.enterEmailAddress,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterEmail;
                  }
                  if (!GetUtils.isEmail(value)) {
                    return AppStrings.pleaseEnterValidEmail;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TDButton(
            text: AppStrings.sendInvitation,
            onPressed: _handleSendInvitation,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendInvitation() async {
    if (!_inviteFormKey.currentState!.validate()) return;

    try {
      await _workspaceController.inviteUserToWorkspace(
        _inviteEmailController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        _inviteEmailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.invitationSent),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.failedToSendInvitation}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleMemberAction(String action, WorkspaceMember member) async {
    switch (action) {
      case 'edit_role':
        _showEditRoleDialog(member);
      case 'remove':
        _showRemoveUserDialog(member);
    }
  }

  void _showEditRoleDialog(WorkspaceMember member) {
    var selectedRole = member.role.displayName;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(AppStrings.editRole),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppStrings.user}: ${member.userId}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(
                  labelText: AppStrings.selectRole,
                  border: OutlineInputBorder(),
                ),
                items: ['Admin', 'Member'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TDButton(
              text: AppStrings.save,
              onPressed: () => _handleUpdateUserRole(member, selectedRole),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpdateUserRole(WorkspaceMember member, String newRole) async {
    try {
      await _workspaceController.updateUserRole(member.userId, newRole);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.userRoleUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.failedToUpdateRole}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showRemoveUserDialog(WorkspaceMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.removeUser),
        content: Text('${AppStrings.removeUserConfirmation} ${member.userId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(AppStrings.remove),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await _workspaceController.removeUserFromWorkspace(member.userId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.userRemoved),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.failedToRemoveUser}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
