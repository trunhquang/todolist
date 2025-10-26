import 'package:meta/meta.dart';

/// Workspace member entity following V1 architecture
/// Represents a user's membership in a workspace with role and permissions
@immutable
class WorkspaceMember {
  const WorkspaceMember({
    required this.userId,
    required this.workspaceId,
    required this.role,
    required this.permissions,
    required this.assignedBy,
    required this.assignedAt,
    this.managerUserId,
    this.isActive = true,
    this.name,
    this.email,
  });

  /// Create from map
  factory WorkspaceMember.fromMap(Map<String, dynamic> map) {
    return WorkspaceMember(
      userId: map['userId']?.toString() ?? '',
      workspaceId: map['workspaceId']?.toString() ?? '',
      role: WorkspaceRole.fromString(map['role']?.toString() ?? 'member'),
      permissions: (map['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      assignedBy: map['assignedBy']?.toString() ?? '',
      assignedAt: DateTime.fromMillisecondsSinceEpoch(
        map['assignedAt'] is int ? map['assignedAt'] as int : 0,
      ),
      managerUserId: map['managerUserId']?.toString(),
      isActive: (map['isActive'] as bool?) ?? true,
      name: map['name']?.toString(),
      email: map['email']?.toString(),
    );
  }

  final String userId;
  final String workspaceId;
  final WorkspaceRole role;
  final List<String> permissions;
  final String assignedBy;
  final DateTime assignedAt;
  final String? managerUserId;
  final bool isActive;
  final String? name;
  final String? email;

  /// Copy with method
  WorkspaceMember copyWith({
    String? userId,
    String? workspaceId,
    WorkspaceRole? role,
    List<String>? permissions,
    String? assignedBy,
    DateTime? assignedAt,
    String? managerUserId,
    bool? isActive,
    String? name,
    String? email,
  }) {
    return WorkspaceMember(
      userId: userId ?? this.userId,
      workspaceId: workspaceId ?? this.workspaceId,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
      managerUserId: managerUserId ?? this.managerUserId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'workspaceId': workspaceId,
      'role': role.value,
      'permissions': permissions,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.millisecondsSinceEpoch,
      'managerUserId': managerUserId,
      'isActive': isActive,
      'name': name,
      'email': email,
    };
  }

  /// Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkspaceMember &&
        other.userId == userId &&
        other.workspaceId == workspaceId &&
        other.role == role &&
        other.assignedBy == assignedBy &&
        other.assignedAt == assignedAt &&
        other.managerUserId == managerUserId &&
        other.isActive == isActive &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        workspaceId.hashCode ^
        role.hashCode ^
        assignedBy.hashCode ^
        assignedAt.hashCode ^
        managerUserId.hashCode ^
        isActive.hashCode ^
        name.hashCode ^
        email.hashCode;
  }

  @override
  String toString() {
    return 'WorkspaceMember(userId: $userId, workspaceId: $workspaceId, role: $role, isActive: $isActive, name: $name, email: $email)';
  }

  /// Helper methods
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  bool get isAccountHolder => role == WorkspaceRole.accountHolder;

  bool get isAdmin => role == WorkspaceRole.admin;

  bool get isMember => role == WorkspaceRole.member;

  bool get hasManager => managerUserId != null && managerUserId!.isNotEmpty;

  /// Get display name, fallback to email or userId
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (email != null && email!.isNotEmpty) return email!;
    return userId;
  }
}

/// Workspace role enum
enum WorkspaceRole {
  accountHolder('account_holder'),
  admin('admin'),
  member('member');

  const WorkspaceRole(this.value);

  final String value;

  static WorkspaceRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'account_holder':
        return WorkspaceRole.accountHolder;
      case 'admin':
        return WorkspaceRole.admin;
      case 'member':
        return WorkspaceRole.member;
      default:
        return WorkspaceRole.member;
    }
  }

  String get displayName {
    switch (this) {
      case WorkspaceRole.accountHolder:
        return 'Account Holder';
      case WorkspaceRole.admin:
        return 'Admin';
      case WorkspaceRole.member:
        return 'Member';
    }
  }
}
