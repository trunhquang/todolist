import 'package:meta/meta.dart';

/// Team group entity following V1 architecture
/// Represents a team group with members and lead group
@immutable
class TeamGroup {
  const TeamGroup({
    required this.id,
    required this.name,
    required this.workspaceId,
    required this.leadGroupUserId,
    required this.members,
    required this.createdBy,
    required this.createdAt,
    this.description,
    this.isActive = true,
  });

  /// Create from map
  factory TeamGroup.fromMap(Map<String, dynamic> map) {
    return TeamGroup(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      workspaceId: map['workspaceId']?.toString() ?? '',
      leadGroupUserId: map['leadGroupUserId']?.toString() ?? '',
      members: (map['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int ? map['createdAt'] as int : 0,
      ),
      description: map['description']?.toString(),
      isActive: (map['isActive'] as bool?) ?? true,
    );
  }

  final String id;
  final String name;
  final String workspaceId;
  final String leadGroupUserId;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt;
  final String? description;
  final bool isActive;

  /// Copy with method
  TeamGroup copyWith({
    String? id,
    String? name,
    String? workspaceId,
    String? leadGroupUserId,
    List<String>? members,
    String? createdBy,
    DateTime? createdAt,
    String? description,
    bool? isActive,
  }) {
    return TeamGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      workspaceId: workspaceId ?? this.workspaceId,
      leadGroupUserId: leadGroupUserId ?? this.leadGroupUserId,
      members: members ?? this.members,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workspaceId': workspaceId,
      'leadGroupUserId': leadGroupUserId,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'description': description,
      'isActive': isActive,
    };
  }

  /// Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamGroup &&
        other.id == id &&
        other.name == name &&
        other.workspaceId == workspaceId &&
        other.leadGroupUserId == leadGroupUserId &&
        other.members == members &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        workspaceId.hashCode ^
        leadGroupUserId.hashCode ^
        members.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'TeamGroup(id: $id, name: $name, workspaceId: $workspaceId, leadGroupUserId: $leadGroupUserId, members: $members, isActive: $isActive)';
  }

  /// Helper methods
  bool hasMember(String userId) {
    return members.contains(userId);
  }

  bool get isEmpty => members.isEmpty;

  int get memberCount => members.length;
}
