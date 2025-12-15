import 'package:flutter/material.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/app/pages/users/widgets/role_chip.dart';
import 'package:todolist/app/pages/users/widgets/status_chip.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/app/theme/app_colors.dart';

class InvitationCard extends StatelessWidget {
  final Invitation invitation;
  final void Function(String action) onAction;

  const InvitationCard({super.key, required this.invitation, required this.onAction});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return AppStrings.I.today.toLowerCase();
    } else if (difference.inDays == 1) {
      return AppStrings.I.yesterday.toLowerCase();
    } else if (difference.inDays < 7) {
      return AppStrings.formatDaysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = invitation.isRevoked
        ? AppStrings.I.invitationRevoked
        : invitation.isWaiting
            ? AppStrings.I.invitationWaiting
            : invitation.isAccepted
                ? AppStrings.I.invitationAcceptedStatus
                : AppStrings.I.invitationDenied;
    final statusColor = _statusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            invitation.email.isNotEmpty
                ? invitation.email[0].toUpperCase()
                : '?',
          ),
        ),
        title: Text(invitation.name != null && invitation.name!.isNotEmpty
            ? invitation.name!
            : invitation.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (invitation.name != null && invitation.name!.isNotEmpty)
              Text(
                invitation.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            Text(
              '${AppStrings.I.invitedPrefix} ${_formatDate(invitation.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                TDRoleChip(
                    role: WorkspaceRole.fromString(invitation.role)),
                const SizedBox(width: 8),
                TDStatusChip(label: statusText, color: statusColor),
              ],
            ),
          ],
        ),
        trailing: invitation.isRevoked || !invitation.isWaiting
            ? const SizedBox.shrink()
            : PopupMenuButton<String>(
                onSelected: onAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'revoke',
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.I.revokeInvitation,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _statusColor() {
    if (invitation.isRevoked) return AppColors.cancelledStatus;
    if (invitation.isWaiting) return AppColors.pendingStatus;
    if (invitation.isAccepted) return AppColors.completedStatus;
    return AppColors.error; // Denied
  }
}


