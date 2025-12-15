import 'package:flutter/material.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/app/pages/users/widgets/role_chip.dart';

class MemberCard extends StatelessWidget {
  final WorkspaceMember member;
  final void Function(String action) onAction;

  const MemberCard({super.key, required this.member, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            member.displayName.isNotEmpty
                ? member.displayName[0].toUpperCase()
                : '?',
          ),
        ),
        title: Text(member.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if  (member.email.isNotEmpty) ...[
              Text(
                member.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 4),
            ],
            TDRoleChip(role: member.role),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: member.isAccountHolder ? null : onAction,
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
                    AppStrings.I.editRole,
                    style: member.isAccountHolder
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.outline)
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
                    AppStrings.I.removeUser,
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
}


