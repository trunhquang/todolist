import 'package:meta/meta.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';

@immutable
class Project { // soft delete support

  const Project({
    required this.id,
    required this.title,
    required this.workspaceId,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.description,
    this.deadline,
    this.memberIds = const <String>[],
    this.deletedAt,
  });

  factory Project.fromMap(Map<dynamic, dynamic> map) {
    return Project(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      description: map['description'] as String?,
      workspaceId: (map['workspaceId'] as String?) ?? '',
      status: ProjectStatus.fromString((map['status'] as String?) ?? ''),
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int)
          : null,
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['createdAt'] as int?) ?? 0),
      memberIds: (map['memberIds'] as List<dynamic>?)
              ?.map((dynamic id) => id as String)
              .toList() ??
          const <String>[],
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
          : null,
    );
  }
  final String id;
  final String title;
  final String? description;
  final String workspaceId;
  final ProjectStatus status;
  final DateTime? deadline; // null if no deadline
  final String createdBy;
  final DateTime createdAt;
  final List<String> memberIds;
  final DateTime? deletedAt;

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? workspaceId,
    ProjectStatus? status,
    DateTime? deadline,
    String? createdBy,
    DateTime? createdAt,
    List<String>? memberIds,
    DateTime? deletedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      workspaceId: workspaceId ?? this.workspaceId,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'workspaceId': workspaceId,
      'status': status.value,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'memberIds': memberIds,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }
}


