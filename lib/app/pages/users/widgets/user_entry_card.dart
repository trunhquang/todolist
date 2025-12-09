import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../models/workspace_user_entry.dart';
import 'invitation_card.dart';
import 'member_card.dart';

typedef InvitationAction = Future<void> Function(
    String action, Invitation invitation);
typedef MemberAction = Future<void> Function(
    String action, WorkspaceMember member);

class UserEntryCard extends StatelessWidget {
  const UserEntryCard({
    super.key,
    required this.user,
    required this.onInvitationAction,
    required this.onMemberAction,
  });

  final WorkspaceUserEntry user;
  final InvitationAction onInvitationAction;
  final MemberAction onMemberAction;

  @override
  Widget build(BuildContext context) {
    return switch (user) {
      WorkspaceUserEntryMember(:final member) => MemberCard(
          member: member,
          onAction: (value) => unawaited(onMemberAction(value, member)),
        ),
      WorkspaceUserEntryInvitation(:final invitation) => InvitationCard(
          invitation: invitation,
          onAction: (value) =>
              unawaited(onInvitationAction(value, invitation)),
        ),
    };
  }
}
