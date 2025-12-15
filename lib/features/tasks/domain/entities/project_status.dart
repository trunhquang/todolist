import 'package:todolist/core/constants/app_strings.dart';

/// Enum for project status with safe string conversion.
enum ProjectStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const ProjectStatus(this.value);
  final String value;

  String get displayText {
    switch (this) {
      case ProjectStatus.pending:
        return AppStrings.I.projectStatusPending;
      case ProjectStatus.inProgress:
        return AppStrings.I.statusInProgress;
      case ProjectStatus.completed:
        return AppStrings.I.projectStatusCompleted;
      case ProjectStatus.cancelled:
        return AppStrings.I.projectStatusCancelled;
    }
  }
  /// Convert string to [ProjectStatus] with backward compatibility.
  static ProjectStatus fromString(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'pending':
        return ProjectStatus.pending;
      case 'in_progress':
      case 'in progress':
      case 'active':
        return ProjectStatus.inProgress;
      case 'completed':
        return ProjectStatus.completed;
      case 'cancelled':
      case 'canceled':
      case 'closed':
        return ProjectStatus.cancelled;
      default:
        return ProjectStatus.pending;
    }
  }
}


