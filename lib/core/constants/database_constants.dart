class DatabaseConstants {
  // Firebase Database Paths
  static const String companiesPath = 'companies';
  static const String departmentsPath = 'departments';
  static const String projectsPath = 'projects';
  static const String tasksPath = 'tasks';
  static const String reportsPath = 'reports';
  static const String usersPath = 'users';

  // Company Fields
  static const String companyId = 'id';
  static const String companyName = 'name';
  static const String companyCreatedBy = 'createdBy';
  static const String companyCreatedAt = 'createdAt';
  static const String companyInfo = 'info';

  // Department Fields
  static const String departmentId = 'id';
  static const String departmentName = 'name';
  static const String departmentAdmins = 'admins';
  static const String departmentUsers = 'users';
  static const String departmentCreatedAt = 'createdAt';

  // Project Fields
  static const String projectId = 'id';
  static const String projectTitle = 'title';
  static const String projectDescription = 'description';
  static const String projectDeadline = 'deadline';
  static const String projectDepartmentId = 'departmentId';
  static const String projectStatus = 'status';
  static const String projectCreatedBy = 'createdBy';
  static const String projectCreatedAt = 'createdAt';

  // Task Fields
  static const String taskId = 'id';
  static const String taskTitle = 'title';
  static const String taskDescription = 'description';
  static const String taskAssignee = 'assignee';
  static const String taskAssigner = 'assigner';
  static const String taskStatus = 'status';
  static const String taskPriority = 'priority';
  static const String taskType = 'taskType';
  static const String taskProjectId = 'projectId';
  static const String taskDepartmentId = 'departmentId';
  static const String taskDeadline = 'deadline';
  static const String taskHasDeadline = 'hasDeadline';
  static const String taskRecurring = 'recurring';
  static const String taskCreatedAt = 'createdAt';
  static const String taskUpdatedAt = 'updatedAt';

  // Recurring Task Fields
  static const String recurringIsRecurring = 'isRecurring';
  static const String recurringFrequency = 'frequency';
  static const String recurringInterval = 'interval';
  static const String recurringEndDate = 'endDate';

  // Report Fields
  static const String reportUserId = 'userId';
  static const String reportDate = 'date';
  static const String reportCompletedTasks = 'completedTasks';
  static const String reportPendingTasks = 'pendingTasks';
  static const String reportNotes = 'notes';
  static const String reportSubmittedAt = 'submittedAt';

  // User Fields
  static const String userId = 'id';
  static const String userEmail = 'email';
  static const String userName = 'name';
  static const String userRole = 'role';
  static const String userCompanyId = 'companyId';
  static const String userDepartmentId = 'departmentId';
  static const String userCreatedAt = 'createdAt';
  static const String userLastLoginAt = 'lastLoginAt';

  // Timestamp Fields
  static const String timestamp = 'timestamp';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
