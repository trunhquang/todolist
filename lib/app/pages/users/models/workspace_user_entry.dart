import 'package:meta/meta.dart';

import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';

/// Sealed class representing a user entry in workspace management
/// Can be either a [WorkspaceMember] or an [Invitation]
@immutable
sealed class WorkspaceUserEntry {
  const WorkspaceUserEntry();

  /// Factory constructor to create from WorkspaceMember
  factory WorkspaceUserEntry.fromMember(WorkspaceMember member) {
    return WorkspaceUserEntryMember(member);
  }

  /// Factory constructor to create from Invitation
  factory WorkspaceUserEntry.fromInvitation(Invitation invitation) {
    return WorkspaceUserEntryInvitation(invitation);
  }

  /// Get the email address for search/filtering
  String get email;

  /// Get the display name for search/filtering
  String get displayName;

  /// Get the role string for search/filtering
  String get roleString;
}

/// Represents a workspace member entry
@immutable
final class WorkspaceUserEntryMember extends WorkspaceUserEntry {
  const WorkspaceUserEntryMember(this.member) : super();

  final WorkspaceMember member;

  @override
  String get email => member.email;

  @override
  String get displayName => member.displayName;

  @override
  String get roleString => member.role.displayName;
}

/// Represents an invitation entry
@immutable
final class WorkspaceUserEntryInvitation extends WorkspaceUserEntry {
  const WorkspaceUserEntryInvitation(this.invitation) : super();

  final Invitation invitation;

  @override
  String get email => invitation.email;

  @override
  String get displayName => invitation.name ?? invitation.email;

  @override
  String get roleString => invitation.role;
}
