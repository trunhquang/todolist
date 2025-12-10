import 'package:todolist/core/constants/app_strings.dart';

/// Enum for project status with safe string conversion.
enum ProjectStatus {
  pending('pending', AppStrings.projectStatusPending),
  inProgress('in_progress', AppStrings.statusInProgress),
  completed('completed', AppStrings.projectStatusCompleted),
  cancelled('cancelled', AppStrings.projectStatusCancelled);

  const ProjectStatus(this.value, this.displayText);
  final String value;
  final String displayText;

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

