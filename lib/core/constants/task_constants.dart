class TaskConstants {
  // Task Types
  static const String daily = 'daily';
  static const String weekly = 'weekly';
  static const String monthly = 'monthly';
  static const String project = 'project';

  // Task Priorities
  static const String low = 'low';
  static const String medium = 'medium';
  static const String high = 'high';
  static const String urgent = 'urgent';

  // Task Status
  static const String pending = 'pending';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  // Recurring Frequencies
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyMonthly = 'monthly';

  // Task Type Display Names
  static const Map<String, String> taskTypeDisplayNames = {
    daily: 'Daily Task',
    weekly: 'Weekly Task',
    monthly: 'Monthly Task',
    project: 'Project Task',
  };

  // Priority Display Names
  static const Map<String, String> priorityDisplayNames = {
    low: 'Low Priority',
    medium: 'Medium Priority',
    high: 'High Priority',
    urgent: 'Urgent',
  };

  // Status Display Names
  static const Map<String, String> statusDisplayNames = {
    pending: 'Pending',
    inProgress: 'In Progress',
    completed: 'Completed',
    cancelled: 'Cancelled',
  };

  // Frequency Display Names
  static const Map<String, String> frequencyDisplayNames = {
    frequencyDaily: 'Daily',
    frequencyWeekly: 'Weekly',
    frequencyMonthly: 'Monthly',
  };

  // Task Type Icons
  static const Map<String, String> taskTypeIcons = {
    daily: 'calendar_today',
    weekly: 'date_range',
    monthly: 'event',
    project: 'work',
  };

  // Priority Icons
  static const Map<String, String> priorityIcons = {
    low: 'keyboard_arrow_down',
    medium: 'remove',
    high: 'keyboard_arrow_up',
    urgent: 'priority_high',
  };

  // Status Icons
  static const Map<String, String> statusIcons = {
    pending: 'schedule',
    inProgress: 'play_circle',
    completed: 'check_circle',
    cancelled: 'cancel',
  };

  // Default Values
  static const String defaultTaskType = daily;
  static const String defaultPriority = medium;
  static const String defaultStatus = pending;
  static const int defaultRecurringInterval = 1;
  static const bool defaultHasDeadline = false;
  static const bool defaultIsRecurring = false;

  // Validation
  static const int minTitleLength = 1;
  static const int maxTitleLength = 100;
  static const int minDescriptionLength = 0;
  static const int maxDescriptionLength = 500;
  static const int minRecurringInterval = 1;
  static const int maxRecurringInterval = 365;
}
