/// Enums for task-related constants to replace hardcoded strings
///
/// This file contains all enums used for task status, priority, type, and frequency.
/// Using enums provides type safety and prevents typos in string values.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// Task status enumeration
enum TaskStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  onHold('on_hold');

  const TaskStatus(this.value);

  final String value;

  /// Get TaskStatus from string value
  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.pending,
    );
  }

  /// Get display text for the status
  String get displayText {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.onHold:
        return 'On Hold';
    }
  }
}

/// Task priority enumeration
enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');

  const TaskPriority(this.value);

  final String value;

  /// Get TaskPriority from string value
  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }

  /// Get display text for the priority
  String get displayText {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}

/// Task type enumeration
enum TaskType {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  project('project');

  const TaskType(this.value);

  final String value;

  /// Get TaskType from string value
  static TaskType fromString(String value) {
    return TaskType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TaskType.daily,
    );
  }

  /// Get display text for the type
  String get displayText {
    switch (this) {
      case TaskType.daily:
        return 'Daily';
      case TaskType.weekly:
        return 'weekly';
      case TaskType.monthly:
        return 'Daily';
      case TaskType.project:
        return 'Project';
    }
  }

  Color get color {
    switch (this) {
      case TaskType.daily:
      // Màu xanh dương: Nhẹ nhàng, phù hợp cho công việc thường nhật
        return Colors.blue;

      case TaskType.weekly:
      // Màu cam: Nổi bật, tạo sự chú ý cho kế hoạch tuần
        return Colors.orange;

      case TaskType.monthly:
      // Màu tím: Trầm ổn, phù hợp cho chu kỳ dài
        return Colors.purple;

      case TaskType.project:
      // Màu xanh ngọc: Khác biệt hẳn so với các màu thời gian ở trên
        return Colors.teal;
    }
  }
}

/// Project status enumeration
enum ProjectStatus {
  pending('pending'),
  active('active'),
  completed('completed'),
  cancelled('cancelled'),
  onHold('on_hold');

  const ProjectStatus(this.value);

  final String value;

  /// Get ProjectStatus from string value
  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ProjectStatus.pending,
    );
  }

  /// Get display text for the status
  String get displayText {
    switch (this) {
      case ProjectStatus.pending:
        return 'Pending';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
      case ProjectStatus.onHold:
        return 'On Hold';
    }
  }
}

/// Entity type enumeration for activity logs
enum EntityType {
  task('task'),
  project('project');

  const EntityType(this.value);

  final String value;

  /// Get EntityType from string value
  static EntityType fromString(String value) {
    return EntityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => EntityType.task,
    );
  }

  /// Get display text for the type
  String get displayText {
    switch (this) {
      case EntityType.task:
        return 'Task';
      case EntityType.project:
        return 'Project';
    }
  }
}
