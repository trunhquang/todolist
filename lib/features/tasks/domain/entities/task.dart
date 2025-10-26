import 'package:meta/meta.dart';

@immutable
class RecurringConfig {

  const RecurringConfig({
    required this.isRecurring,
    this.frequency,
    this.interval,
    this.endDate,
  });

  factory RecurringConfig.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const RecurringConfig(isRecurring: false);
    }
    return RecurringConfig(
      isRecurring: (map['isRecurring'] as bool?) ?? false,
      frequency: map['frequency'] as String?,
      interval: map['interval'] as int?,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
    );
  }
  final bool isRecurring;
  final String? frequency; // daily | weekly | monthly
  final int? interval; // e.g., every 1,2,3 units of frequency
  final DateTime? endDate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isRecurring': isRecurring,
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }
}

@immutable
class TaskEntity { // soft delete

  const TaskEntity({
    required this.id,
    required this.title,
    required this.workspaceId, // MANDATORY: Workspace context for Sprint 5
    required this.taskType,
    required this.priority,
    required this.status,
    required this.assigner,
    required this.hasDeadline,
    required this.recurring,
    required this.createdAt,
    this.description,
    this.assignee,
    this.projectId,
    this.deadline,
    this.parentTaskId,
    this.stoppedByProjectClose,
    this.updatedAt,
    this.deletedAt,
  });

  factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
    return TaskEntity(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      description: map['description'] as String?,
      workspaceId: (map['workspaceId'] as String?) ?? '', // MANDATORY: Workspace context
      taskType: (map['taskType'] as String?) ?? 'daily',
      priority: (map['priority'] as String?) ?? 'medium',
      status: (map['status'] as String?) ?? 'pending',
      assignee: map['assignee'] as String?,
      assigner: (map['assigner'] as String?) ?? '',
      projectId: map['projectId'] as String?,
      hasDeadline: (map['hasDeadline'] as bool?) ?? false,
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int)
          : null,
      parentTaskId: map['parentTaskId'] as String?,
      stoppedByProjectClose: (map['stoppedByProjectClose'] as bool?) ?? false,
      recurring: RecurringConfig.fromMap(map['recurring'] as Map<dynamic, dynamic>?),
      createdAt: DateTime.fromMillisecondsSinceEpoch((map['createdAt'] as int?) ?? 0),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
          : null,
    );
  }
  final String id;
  final String title;
  final String? description;
  final String workspaceId; // MANDATORY: Workspace context for Sprint 5
  final String taskType; // daily | weekly | monthly | project
  final String priority; // low | medium | high | urgent
  final String status; // pending | in_progress | completed | cancelled
  final String? assignee; // userId
  final String assigner; // userId
  final String? projectId; // for project tasks
  final bool hasDeadline;
  final DateTime? deadline;
  final String? parentTaskId; // for generated instances of recurring tasks
  final bool? stoppedByProjectClose;
  final RecurringConfig recurring;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  /// Workspace validation method for Sprint 5
  bool isValidForWorkspace(String workspaceId) {
    return this.workspaceId == workspaceId;
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? workspaceId,
    String? taskType,
    String? priority,
    String? status,
    String? assignee,
    String? assigner,
    String? projectId,
    bool? hasDeadline,
    DateTime? deadline,
    String? parentTaskId,
    bool? stoppedByProjectClose,
    RecurringConfig? recurring,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      workspaceId: workspaceId ?? this.workspaceId,
      taskType: taskType ?? this.taskType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignee: assignee ?? this.assignee,
      assigner: assigner ?? this.assigner,
      projectId: projectId ?? this.projectId,
      hasDeadline: hasDeadline ?? this.hasDeadline,
      deadline: deadline ?? this.deadline,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      stoppedByProjectClose: stoppedByProjectClose ?? this.stoppedByProjectClose,
      recurring: recurring ?? this.recurring,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'workspaceId': workspaceId, // MANDATORY: Workspace context for Sprint 5
      'taskType': taskType,
      'priority': priority,
      'status': status,
      'assignee': assignee,
      'assigner': assigner,
      'projectId': projectId,
      'hasDeadline': hasDeadline,
      'deadline': deadline?.millisecondsSinceEpoch,
      'parentTaskId': parentTaskId,
      'stoppedByProjectClose': stoppedByProjectClose,
      'recurring': recurring.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }
}


