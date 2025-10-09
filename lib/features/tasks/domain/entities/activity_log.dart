import 'package:meta/meta.dart';

/// Activity log entry for tracking changes and resolving conflicts
@immutable
class ActivityLog {
  const ActivityLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.userId,
    required this.timestamp,
    required this.data,
    this.previousData,
    this.conflictResolved = false,
  });

  factory ActivityLog.fromMap(Map<dynamic, dynamic> map) {
    return ActivityLog(
      id: (map['id'] as String?) ?? '',
      entityType: (map['entityType'] as String?) ?? '',
      entityId: (map['entityId'] as String?) ?? '',
      action: (map['action'] as String?) ?? '',
      userId: (map['userId'] as String?) ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (map['timestamp'] as int?) ?? 0,
      ),
      data: map['data'] as Map<String, dynamic>?,
      previousData: map['previousData'] as Map<String, dynamic>?,
      conflictResolved: (map['conflictResolved'] as bool?) ?? false,
    );
  }

  final String id;
  final String entityType; // 'task' | 'project'
  final String entityId;
  final String action; // 'create' | 'update' | 'delete'
  final String userId;
  final DateTime timestamp;
  final Map<String, dynamic>? data; // Current data
  final Map<String, dynamic>? previousData; // Previous data for updates
  final bool conflictResolved;

  ActivityLog copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? action,
    String? userId,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    Map<String, dynamic>? previousData,
    bool? conflictResolved,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      previousData: previousData ?? this.previousData,
      conflictResolved: conflictResolved ?? this.conflictResolved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'action': action,
      'userId': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'data': data,
      'previousData': previousData,
      'conflictResolved': conflictResolved,
    };
  }
}
