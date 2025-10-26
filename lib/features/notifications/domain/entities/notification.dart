import 'package:meta/meta.dart';

@immutable
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      data: map['data'] is Map<String, dynamic> 
          ? map['data'] as Map<String, dynamic>
          : <String, dynamic>{},
      isRead: (map['isRead'] as bool?) ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int ? map['createdAt'] as int : 0,
      ),
    );
  }

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationEntity &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.title == title &&
        other.message == message &&
        other.isRead == isRead &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        title.hashCode ^
        message.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'NotificationEntity(id: $id, userId: $userId, type: $type, title: $title, isRead: $isRead)';
  }
}
