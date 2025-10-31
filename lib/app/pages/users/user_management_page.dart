import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../features/invitations/domain/entities/invitation.dart';
import '../../widgets/td_app_bar.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';
import 'controllers/user_management_controller.dart';
import 'widgets/member_card.dart';
import 'widgets/invitation_card.dart';

/// Controller for User Management Page

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementController>(
      init: UserManagementController(),
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.userManagement,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService().back<void>(),
          ),
          actions: [
            Obx(() {
              if (controller.canManageUsers) {
                return IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _showInviteUserDialog(context, controller),
                  tooltip: AppStrings.inviteUser,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final members = controller.workspaceMembers;
          final invitations = controller.invitations;
          final allUsers = _combineMembersAndInvitations(members, invitations);
          final filteredUsers = _filterUsers(allUsers, controller.searchQuery);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TDTextField(
                  controller: controller.searchController,
                  hint: AppStrings.searchUsers,
                  prefixIcon: Icons.search,
                  onChanged: (value) => controller.updateSearchQuery(value),
                ),
              ),

              // Users List
              Expanded(
                child: filteredUsers.isEmpty
                    ? _buildEmptyState(context, controller)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return _buildUserCard(context, user, controller);
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, UserManagementController controller) {
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
          Obx(() {
            if (controller.canManageUsers)
              return TDButton(
                text: AppStrings.inviteUser,
                onPressed: () => _showInviteUserDialog(context, controller),
                icon: Icons.person_add,
              );
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  /// Combine members and invitations into a unified list
  List<dynamic> _combineMembersAndInvitations(
      List<WorkspaceMember> members, List<Invitation> invitations) {
    final List<dynamic> allUsers = [...members];

    allUsers.addAll(invitations);

    return allUsers;
  }

  /// Filter users based on search query
  List<dynamic> _filterUsers(List<dynamic> users, String searchQuery) {
    if (searchQuery.isEmpty) return users;

    final query = searchQuery.toLowerCase();
    return users.where((user) {
      if (user is WorkspaceMember) {
        final roleName = user.role.displayName.toLowerCase();
        final displayName = user.displayName.toLowerCase();
        final email = user.email?.toLowerCase() ?? '';
        final userId = user.userId.toLowerCase();

        return displayName.contains(query) ||
            email.contains(query) ||
            userId.contains(query) ||
            roleName.contains(query);
      } else if (user is Invitation) {
        final email = user.email.toLowerCase();
        final role = user.role.toLowerCase();
        final name = user.name?.toLowerCase() ?? '';
        return email.contains(query) ||
            role.contains(query) ||
            name.contains(query);
      }
      return false;
    }).toList();
  }

  Widget _buildUserCard(
      BuildContext context, dynamic user, UserManagementController controller) {
    if (user is WorkspaceMember) {
      return MemberCard(
        member: user,
        onAction: (value) =>
            _handleMemberAction(context, value, user, controller),
      );
    } else if (user is Invitation) {
      return InvitationCard(
        invitation: user,
        onAction: (value) =>
            _handleInvitationAction(context, value, user, controller),
      );
    }
    return const SizedBox.shrink();
  }

  /// Handle invitation actions
  Future<void> _handleInvitationAction(BuildContext context, String action,
      Invitation invitation, UserManagementController controller) async {
    switch (action) {
      case 'revoke':
        await controller.revokeInvitation(invitation.id);
        await controller.refreshData();
        break;
    }
  }

  void _showInviteUserDialog(
      BuildContext context, UserManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.inviteUser),
        content: Form(
          key: controller.inviteFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDTextField(
                controller: controller.inviteNameController,
                label: AppStrings.fullName,
                hint: AppStrings.enterFullName,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterFullName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TDTextField(
                controller: controller.inviteEmailController,
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
            onPressed: () => _handleSendInvitation(context, controller),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendInvitation(
      BuildContext context, UserManagementController controller) async {
    if (!controller.inviteFormKey.currentState!.validate()) return;

    try {
      await controller.inviteUserToWorkspace();

      if (context.mounted) {
        Navigator.of(context).pop();
        controller.inviteEmailController.clear();
        controller.inviteNameController.clear();
        // Refresh the member list to show the new invitation
        await controller.refreshData();
        SnackbarService().showSuccess(
          title: AppStrings.success,
          message: AppStrings.invitationSent,
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: '${AppStrings.failedToSendInvitation}: $e',
        );
      }
    }
  }

  Future<void> _handleMemberAction(BuildContext context, String action,
      WorkspaceMember member, UserManagementController controller) async {
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
        _showEditRoleDialog(context, member, controller);
      case 'remove':
        _showRemoveUserDialog(context, member, controller);
    }
  }

  void _showEditRoleDialog(BuildContext context, WorkspaceMember member,
      UserManagementController controller) {
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
              onPressed: () => _handleUpdateUserRole(
                  context, member, selectedRole, controller),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpdateUserRole(
      BuildContext context,
      WorkspaceMember member,
      String newRole,
      UserManagementController controller) async {
    try {
      await controller.updateUserRole(member.userId, newRole);

      if (context.mounted) {
        Navigator.of(context).pop();
        await controller.refreshData();
        SnackbarService().showSuccess(
          title: AppStrings.success,
          message: AppStrings.userRoleUpdated,
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: '${AppStrings.failedToUpdateRole}: $e',
        );
      }
    }
  }

  Future<void> _showRemoveUserDialog(BuildContext context,
      WorkspaceMember member, UserManagementController controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.removeUser),
        content:
            Text('${AppStrings.removeUserConfirmation} ${member.displayName}?'),
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
        await controller.removeUserFromWorkspace(member.userId);
        await controller.refreshData();

        if (context.mounted) {
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.userRemoved,
          );
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarService().showError(
            title: AppStrings.error,
            message: '${AppStrings.failedToRemoveUser}: $e',
          );
        }
      }
    }
  }
}
