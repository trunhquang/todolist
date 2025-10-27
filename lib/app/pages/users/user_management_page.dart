import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../../features/invitations/domain/entities/invitation.dart';
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
  bool _canManageUsers = false;

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
      setState(() {
        _canManageUsers = canManageUsers;
      });
      if (!canManageUsers) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      setState(() {
        _canManageUsers = false;
      });
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
    await _workspaceController.loadInvitations();
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
          if (_canManageUsers)
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
        final invitations = _workspaceController.invitations;
        final allUsers = _combineMembersAndInvitations(members, invitations);
        final filteredUsers = _filterUsers(allUsers);

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
            
            // Users List
            Expanded(
              child: filteredUsers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _buildUserCard(user);
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
          if (_canManageUsers)
            TDButton(
              text: AppStrings.inviteUser,
              onPressed: _showInviteUserDialog,
              icon: Icons.person_add,
            ),
        ],
      ),
    );
  }

  /// Combine members and invitations into a unified list
  List<dynamic> _combineMembersAndInvitations(List<WorkspaceMember> members, List<Invitation> invitations) {
    final List<dynamic> allUsers = [];
    
    // Add accepted members
    allUsers.addAll(members);
    
    // Add pending invitations (only non-accepted, non-revoked)
    final pendingInvitations = invitations.where((inv) => !inv.isAccepted && !inv.isRevoked).toList();
    allUsers.addAll(pendingInvitations);
    
    return allUsers;
  }

  /// Filter users based on search query
  List<dynamic> _filterUsers(List<dynamic> users) {
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) return users;
    
    return users.where((user) {
      if (user is WorkspaceMember) {
        final roleName = user.role.displayName.toLowerCase();
        final displayName = user.displayName.toLowerCase();
        final email = user.email?.toLowerCase() ?? '';
        final userId = user.userId.toLowerCase();

        return displayName.contains(searchQuery) ||
               email.contains(searchQuery) ||
               userId.contains(searchQuery) ||
               roleName.contains(searchQuery);
      } else if (user is Invitation) {
        final email = user.email.toLowerCase();
        final role = user.role.toLowerCase();
        return email.contains(searchQuery) || role.contains(searchQuery);
      }
      return false;
    }).toList();
  }

  Widget _buildUserCard(dynamic user) {
    if (user is WorkspaceMember) {
      return _buildMemberCard(user);
    } else if (user is Invitation) {
      return _buildInvitationCard(user);
    }
    return const SizedBox.shrink();
  }

  Widget _buildMemberCard(WorkspaceMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            member.displayName.isNotEmpty ? member.displayName[0].toUpperCase() : '?',
          ),
        ),
        title: Text(member.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (member.email != null && member.email!.isNotEmpty) ...[
              Text(
                member.email!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
            ],
            _buildRoleChip(member.role),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: member.isAccountHolder ? null : (value) => _handleMemberAction(value, member),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit_role',
              enabled: !member.isAccountHolder,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: member.isAccountHolder 
                        ? Theme.of(context).colorScheme.outline 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.editRole,
                    style: member.isAccountHolder 
                        ? TextStyle(color: Theme.of(context).colorScheme.outline)
                        : null,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'remove',
              enabled: !member.isAccountHolder,
              child: Row(
                children: [
                  Icon(
                    Icons.remove_circle,
                    color: member.isAccountHolder 
                        ? Theme.of(context).colorScheme.outline 
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.removeUser,
                    style: TextStyle(
                      color: member.isAccountHolder 
                          ? Theme.of(context).colorScheme.outline 
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationCard(Invitation invitation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            invitation.email.isNotEmpty ? invitation.email[0].toUpperCase() : '?',
          ),
        ),
        title: Text(invitation.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invited ${_formatDate(invitation.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildRoleChip(WorkspaceRole.fromString(invitation.role)),
                const SizedBox(width: 8),
                _buildStatusChip('Pending', Colors.orange),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleInvitationAction(value, invitation),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'revoke',
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Revoke Invitation',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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

  /// Handle invitation actions
  Future<void> _handleInvitationAction(String action, Invitation invitation) async {
    switch (action) {
      case 'revoke':
        await _workspaceController.revokeInvitation(invitation.id);
        break;
    }
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
        // Refresh the member list to show the new invitation
        await _loadWorkspaceMembers();
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
    // Không cho phép thay đổi Account Holder
    if (member.isAccountHolder) {
      SnackbarService().showInfo(
        title: AppStrings.info,
        message: AppStrings.cannotModifyAdminPermissions,
      );
      return;
    }

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
              Text('${AppStrings.user}: ${member.displayName}'),
              if (member.email != null && member.email!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  member.email!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
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
        content: Text('${AppStrings.removeUserConfirmation} ${member.displayName}?'),
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
