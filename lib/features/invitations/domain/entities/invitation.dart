import 'package:meta/meta.dart';

/// Invitation entity represents a pending invitation for a workspace
@immutable
class Invitation {
  const Invitation({
    required this.id,
    required this.workspaceId,
    required this.email,
    required this.role,
    required this.invitedByUserId,
    required this.createdAt,
    this.acceptedAt,
    this.revokedAt,
    this.token,
    this.isAccepted = false,
    this.isRevoked = false,
  });

  factory Invitation.fromMap(Map<String, dynamic> map, {String? id}) {
    return Invitation(
      id: id ?? (map['id']?.toString() ?? ''),
      workspaceId: map['workspaceId']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'member',
      invitedByUserId: map['invitedByUserId']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int ? map['createdAt'] as int : 0,
      ),
      acceptedAt: map['acceptedAt'] is int && (map['acceptedAt'] as int) > 0
          ? DateTime.fromMillisecondsSinceEpoch(map['acceptedAt'] as int)
          : null,
      revokedAt: map['revokedAt'] is int && (map['revokedAt'] as int) > 0
          ? DateTime.fromMillisecondsSinceEpoch(map['revokedAt'] as int)
          : null,
      token: map['token']?.toString(),
      isAccepted: (map['isAccepted'] as bool?) ?? false,
      isRevoked: (map['isRevoked'] as bool?) ?? false,
    );
  }

  final String id;
  final String workspaceId;
  final String email;
  final String role; // use WorkspaceRole.value when assigning
  final String invitedByUserId;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? revokedAt;
  final String? token; // optional acceptance token
  final bool isAccepted;
  final bool isRevoked;

  Invitation copyWith({
    String? id,
    String? workspaceId,
    String? email,
    String? role,
    String? invitedByUserId,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? token,
    bool? isAccepted,
    bool? isRevoked,
  }) {
    return Invitation(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      email: email ?? this.email,
      role: role ?? this.role,
      invitedByUserId: invitedByUserId ?? this.invitedByUserId,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      token: token ?? this.token,
      isAccepted: isAccepted ?? this.isAccepted,
      isRevoked: isRevoked ?? this.isRevoked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workspaceId': workspaceId,
      'email': email,
      'role': role,
      'invitedByUserId': invitedByUserId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'acceptedAt': acceptedAt?.millisecondsSinceEpoch ?? 0,
      'revokedAt': revokedAt?.millisecondsSinceEpoch ?? 0,
      'token': token,
      'isAccepted': isAccepted,
      'isRevoked': isRevoked,
    };
  }
}


