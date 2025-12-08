import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../controllers/user_management_controller.dart';
import 'user_entry_card.dart';
import 'user_management_actions.dart';
import 'user_management_empty_state.dart';
import 'user_management_search_bar.dart';

class UserManagementBody extends StatelessWidget {
  const UserManagementBody({super.key, required this.controller});

  final UserManagementController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final members = controller.workspaceMembers;
      final invitations = controller.filteredInvitations;
      final allUsers = _combineMembersAndInvitations(members, invitations);
      final filteredUsers = _filterUsers(allUsers, controller.searchQuery);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: UserManagementSearchBar(
              controller: controller,
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? UserManagementEmptyState(controller: controller)
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return UserEntryCard(
                        user: user,
                        onInvitationAction: (value, invitation) =>
                            handleInvitationAction(
                                action: value,
                                invitation: invitation,
                                controller: controller),
                        onMemberAction: (value, member) =>
                            handleMemberAction(
                          context: context,
                          action: value,
                          member: member,
                          controller: controller,
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  List<dynamic> _combineMembersAndInvitations(
    List<WorkspaceMember> members,
    List<Invitation> invitations,
  ) {
    return <dynamic>[...members, ...invitations];
  }

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
}
