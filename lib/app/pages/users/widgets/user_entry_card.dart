import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
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

  final dynamic user;
  final InvitationAction onInvitationAction;
  final MemberAction onMemberAction;

  @override
  Widget build(BuildContext context) {
    if (user is WorkspaceMember) {
      return MemberCard(
        member: user as WorkspaceMember,
        onAction: (value) =>
            unawaited(onMemberAction(value, user as WorkspaceMember)),
      );
    }
    if (user is Invitation) {
      return InvitationCard(
        invitation: user as Invitation,
        onAction: (value) =>
            unawaited(onInvitationAction(value, user as Invitation)),
      );
    }
    return const SizedBox.shrink();
  }
}
