class AppConstants {
  // App Information
  static const String appName = 'TodoList';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Company Todo List & Daily Reports';

  // Firebase Configuration
  static const String firebaseProjectId = 'todolist-kingnguyen';
  static const String firebaseStorageBucket = 'todolist-kingnguyen.firebasestorage.app';

  // OneDrive Configuration
  static const String oneDriveClientId = 'your-client-id';
  static const String oneDriveTenantId = 'common';
  static const String oneDriveScope = 'https://graph.microsoft.com/Files.ReadWrite';

  // Local Storage Keys
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';
  static const String tasksBoxName = 'tasks_box';
  static const String reportsBoxName = 'reports_box';

  // SharedPreferences Keys
  static const String isFirstLaunch = 'is_first_launch';
  static const String userToken = 'user_token';
  static const String companyId = 'company_id';
  static const String departmentId = 'department_id';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';

  // Task Types
  static const String taskTypeDaily = 'daily';
  static const String taskTypeWeekly = 'weekly';
  static const String taskTypeMonthly = 'monthly';
  static const String taskTypeProject = 'project';

  // Task Priorities
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityUrgent = 'urgent';

  // Task Status
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // User Roles
  static const String roleCompanyAdmin = 'company_admin';
  static const String roleDepartmentAdmin = 'department_admin';
  static const String roleUser = 'user';

  // Recurring Frequencies
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyMonthly = 'monthly';

  // Notification Types
  static const String notificationTaskAssigned = 'task_assigned';
  static const String notificationTaskDeadline = 'task_deadline';
  static const String notificationReportSubmitted = 'report_submitted';
  static const String notificationProjectUpdate = 'project_update';

  // API Endpoints
  static const String baseUrl = 'https://api.todolist.com';
  static const String authEndpoint = '/auth';
  static const String tasksEndpoint = '/tasks';
  static const String reportsEndpoint = '/reports';
  static const String companiesEndpoint = '/companies';
  static const String departmentsEndpoint = '/departments';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxTaskTitleLength = 100;
  static const int maxTaskDescriptionLength = 500;
  static const int maxReportNotesLength = 1000;

  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int connectionTimeoutSeconds = 10;

  // Cache Duration
  static const int cacheExpirationHours = 24;
  static const int offlineDataRetentionDays = 7;
}
