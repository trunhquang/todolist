import 'package:flutter/material.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';

class ProjectMembersTab extends StatelessWidget {
  const ProjectMembersTab({
    super.key,
    required this.members,
    required this.onAddMemberTap,
  });

  final List<User> members;
  final VoidCallback onAddMemberTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TDButton(
              text: AppStrings.addMember,
              onPressed: onAddMemberTap,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: members.isEmpty
                ? const TDEmptyState(
                    title: AppStrings.projectMembers,
                    icon: Icons.group_outlined,
                  )
                : ListView.separated(
                    itemCount: members.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, index) {
                      final member = members[index];
                      return TDCard(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(member.name),
                          subtitle: Text(member.email),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
