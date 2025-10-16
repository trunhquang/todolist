import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/td_app_bar.dart';
import '../../../core/widgets/td_button.dart';
import '../../../core/widgets/td_text_field.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';

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
    _loadWorkspaceMembers();
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
        showBackButton: true,
        onBackPressed: () => NavigationService().back<void>(),
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

  Widget _buildMemberCard(dynamic member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
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
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMemberAction(value, member),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit_role',
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(AppStrings.editRole),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  const Icon(Icons.remove_circle, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(AppStrings.removeUser, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
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

  List<dynamic> _filterMembers(List<dynamic> members) {
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) return members;
    
    return members.where((member) {
      return member.name.toLowerCase().contains(searchQuery) ||
             member.email.toLowerCase().contains(searchQuery) ||
             member.role.toLowerCase().contains(searchQuery);
    }).toList();
  }

  void _showInviteUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.inviteUser),
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
            child: Text(AppStrings.cancel),
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
          SnackBar(
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

  Future<void> _handleMemberAction(String action, dynamic member) async {
    switch (action) {
      case 'edit_role':
        _showEditRoleDialog(member);
        break;
      case 'remove':
        _showRemoveUserDialog(member);
        break;
    }
  }

  void _showEditRoleDialog(dynamic member) {
    String selectedRole = member.role;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppStrings.editRole),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppStrings.user}: ${member.name}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: AppStrings.selectRole,
                  border: const OutlineInputBorder(),
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
              child: Text(AppStrings.cancel),
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

  Future<void> _handleUpdateUserRole(dynamic member, String newRole) async {
    try {
      await _workspaceController.updateUserRole(member.id, newRole);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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

  Future<void> _showRemoveUserDialog(dynamic member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.removeUser),
        content: Text('${AppStrings.removeUserConfirmation} ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppStrings.remove),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _workspaceController.removeUserFromWorkspace(member.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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
