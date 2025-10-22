/// Centralized string management for the application
/// 
/// This file contains all hardcoded strings used throughout the app.
/// All UI text, error messages, and labels should be defined here.
/// 
/// Usage:
/// ```dart
/// import 'package:todolist/core/constants/app_strings.dart';
/// 
/// Text(AppStrings.welcomeMessage)
/// ```
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // ============================================================================
  // AUTHENTICATION STRINGS
  // ============================================================================
  
  /// Authentication related strings
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmYourPassword = 'Confirm your password';
  static const String pleaseConfirmPassword = 'Please confirm your password';
  static const String forgotPassword = 'Forgot Password?';
  static const String rememberMe = 'Remember Me';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signInWithApple = 'Sign in with Apple';
  static const String createAccount = 'Create Account';
  static const String createAccountDescription = 'Create your account to get started';
  static const String fullName = 'Full Name';
  static const String enterFullName = 'Enter your full name';
  static const String pleaseEnterFullName = 'Please enter your full name';
  static const String nameMinLength = 'Name must be at least 2 characters';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String welcomeBack = 'Welcome Back';
  static const String welcomeMessage = 'Welcome to TodoList';
  static const String getStarted = 'Get Started';
  static const String retry = 'Retry';
  static const String checkConnection = 'Check Connection';
  static const String requestPermission = 'Request Permission';
  static const String fixIssues = 'Fix Issues';
  
  // Authentication Error Messages
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String loginFailed = 'Login failed. Please try again.';
  static const String registrationFailed = 'Registration failed. Please try again.';
  static const String userNotFound = 'User not found';
  static const String wrongPassword = 'Wrong password';
  static const String emailAlreadyInUse = 'Email is already in use';
  static const String weakPassword = 'Password is too weak';
  static const String invalidCredentials = 'Invalid credentials';
  static const String accountDisabled = 'This account has been disabled';
  static const String tooManyRequests = 'Too many requests. Please try again later.';
  static const String networkError = 'Network error. Please check your connection.';

  // Authentication Error Messages (VI)
  static const String viAuthInvalidEmail = 'Email không hợp lệ';
  static const String viAuthUserDisabled = 'Tài khoản đã bị vô hiệu hóa';
  static const String viAuthUserNotFound = 'Không tìm thấy tài khoản với email này';
  static const String viAuthWrongPassword = 'Mật khẩu không chính xác';
  static const String viAuthEmailAlreadyInUse = 'Email đã được sử dụng cho tài khoản khác';
  static const String viAuthWeakPassword = 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn';
  static const String viAuthOperationNotAllowed = 'Phương thức đăng nhập này đang bị vô hiệu hóa';
  static const String viAuthAccountExistsWithDifferentCredential = 'Email đã tồn tại với phương thức đăng nhập khác';
  static const String viAuthInvalidCredential = 'Thông tin đăng nhập không hợp lệ';
  static const String viAuthNetworkRequestFailed = 'Không thể kết nối mạng. Vui lòng kiểm tra lại internet';
  static const String viAuthTooManyRequests = 'Thao tác bị chặn do thử quá nhiều lần. Vui lòng thử lại sau';
  static const String viAuthSigninCanceled = 'Quá trình đăng nhập đã bị hủy';
  static const String viAuthLoginFailed = 'Đăng nhập thất bại';
  static const String viAuthSignupFailed = 'Tạo tài khoản thất bại';
  static const String viAuthGoogleSigninFailed = 'Đăng nhập Google thất bại';
  static const String viAuthAppleSigninFailed = 'Đăng nhập Apple thất bại';
  static const String viAuthLogoutFailed = 'Đăng xuất thất bại';

  // Authentication Success Messages (VI)
  static const String viAuthLoginSuccess = 'Đăng nhập thành công';
  static const String viAuthSignupSuccess = 'Tạo tài khoản thành công';
  static const String viAuthGoogleSigninSuccess = 'Đăng nhập Google thành công';
  static const String viAuthAppleSigninSuccess = 'Đăng nhập Apple thành công';
  static const String viAuthLogoutSuccess = 'Đăng xuất thành công';
  static const String viAuthPasswordResetEmailSent = 'Đã gửi email đặt lại mật khẩu';

  // ============================================================================
  // NAVIGATION STRINGS
  // ============================================================================
  
  /// Navigation related strings
  static const String home = 'Home';
  static const String tasks = 'Tasks';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String projects = 'Projects';
  static const String dashboard = 'Dashboard';
  static const String reports = 'Reports';
  static const String calendar = 'Calendar';
  static const String notifications = 'Notifications';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String done = 'Done';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String add = 'Add';
  static const String create = 'Create';
  static const String update = 'Update';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  // duplicate removed

  // Backup/Export
  static const String backup = 'Backup';
  static const String backupToOneDrive = 'Backup to OneDrive';
  static const String backupComplete = 'Backup Complete';
  static const String backupFailed = 'Backup Failed';
  static const String exportingDataToOneDrive = 'Exporting data to OneDrive...';
  static const String dataExportedToOneDriveSuccessfully = 'Data exported to OneDrive successfully';
  static const String restore = 'Restore';
  static const String restoreComplete = 'Restore Complete';
  static const String restoreFailed = 'Restore Failed';
  static const String backupAndRestore = 'Backup & Restore';
  static const String backupAndRestoreSubtitle = 'Export and restore backups';
  static const String sizeLabel = 'Size';
  static const String manageProjects = 'Manage projects';
  static const String manageTasks = 'Manage tasks';
  static const String export = 'Export';
  static const String exportReports = 'Export Reports';
  static const String exportingReports = 'Exporting reports to OneDrive...';
  static const String exportComplete = 'Export Complete';
  static const String exportFailed = 'Export Failed';
  static const String reportsExported = 'Reports exported to OneDrive successfully';
  static const String powerBi = 'Power BI';
  static const String openPowerBiDashboard = 'Open Power BI Dashboard';
  static const String dataRestoredPreview = 'Data restored successfully';
  static const String taskStatistics = 'Task Statistics';
  static const String overview = 'Overview';
  static const String totalTasks = 'Total Tasks';
  static const String byStatus = 'By Status';
  static const String statusDistribution = 'Task status distribution';
  static const String completionTrend = 'Completion Trend';
  static const String tasksCompletedOverTime = 'Tasks completed over time';
  static const String taskStatisticsSubtitle = 'Task statistics & insights';

  // ============================================================================
  // TASK MANAGEMENT STRINGS
  // ============================================================================
  
  /// Task related strings
  static const String task = 'Task';
  static const String newTask = 'New Task';
  static const String addTask = 'Add Task';
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Task Description';
  static const String taskPriority = 'Priority';
  static const String taskStatus = 'Status';
  static const String taskDueDate = 'Due Date';
  static const String taskCategory = 'Category';
  static const String taskTags = 'Tags';
  static const String taskAssignee = 'Assignee';
  static const String taskCreated = 'Created';
  static const String taskUpdated = 'Updated';
  static const String taskCompleted = 'Completed';
  
  // Task Status
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';
  static const String statusOnHold = 'On Hold';
  
  // Task Priority
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';
  static const String priorityUrgent = 'Urgent';
  
  // Task Categories
  static const String categoryWork = 'Work';
  static const String categoryPersonal = 'Personal';
  static const String categoryShopping = 'Shopping';
  static const String categoryHealth = 'Health';
  static const String categoryFinance = 'Finance';
  static const String categoryEducation = 'Education';
  static const String categoryTravel = 'Travel';
  static const String categoryOther = 'Other';

  // Task Type Display Text
  static const String taskTypeDaily = 'Daily';
  static const String taskTypeProject = 'Project';

  // Project Status Display Text
  static const String projectStatusActive = 'Active';
  static const String projectStatusPending = 'Pending';
  static const String projectStatusCompleted = 'Completed';
  static const String projectStatusCancelled = 'Cancelled';
  static const String projectStatusOnHold = 'On Hold';

  // Task Frequency Display Text
  static const String frequencyDaily = 'Daily';
  static const String frequencyWeekly = 'Weekly';
  static const String frequencyMonthly = 'Monthly';
  static const String frequencyYearly = 'Yearly';

  // Error Messages for Missing Data
  static const String noCompanyIdFound = 'No company ID found';
  static const String failedToLoadTasks = 'Failed to load tasks';
  static const String failedToLoadProjects = 'Failed to load projects';
  static const String noReportsFound = 'No reports found';
  static const String noReportsForDate = 'No reports were submitted for this date';
  static const String createNewReport = 'Create New Report';

  // ============================================================================
  // COMPANY SETUP STRINGS
  // ============================================================================
  
  /// Company setup related strings
  static const String companySetup = 'Company Setup';
  static const String companySetupDescription = 'Create your company and first department to get started';
  static const String companyName = 'Company Name';
  static const String companyDescription = 'Company Description';
  static const String companyAddress = 'Company Address';
  static const String companyPhone = 'Company Phone';
  static const String companyEmail = 'Company Email';
  static const String companyWebsite = 'Company Website';
  static const String companyLogo = 'Company Logo';
  static const String setupCompany = 'Setup Company';
  static const String completeSetup = 'Complete Setup';
  static const String skipForNow = 'Skip for Now';
  static const String departmentName = 'Department Name';
  static const String enterDepartmentName = 'Enter your department name';
  static const String companySetupComplete = 'Company setup completed successfully';
  static const String companySetupFailed = 'Company setup failed. Please try again.';
  static const String companyNameRequired = 'Company name is required';
  static const String companyDescriptionRequired = 'Company description is required';
  static const String pleaseEnterCompanyName = 'Please enter your company name';
  
  // Workspace strings
  static const String personalWorkspaceDefault = 'Personal workspace';
  static const String workspaceSuffix = 'Workspace';
  
  // Utility: format personal workspace name from owner name
  static String personalWorkspaceNameFor(String ownerName) {
    return "${ownerName}'s ${workspaceSuffix}";
  }
  static const String pleaseEnterDepartmentName = 'Please enter your department name';
  static const String companyNameMinLength = 'Company name must be at least 2 characters';
  static const String departmentNameMinLength = 'Department name must be at least 2 characters';

  // ============================================================================
  // VALIDATION STRINGS
  // ============================================================================
  
  /// Form validation strings
  static const String fieldRequired = 'This field is required';
  static const String invalidInput = 'Invalid input';
  static const String minLength = 'Minimum length is {min} characters';
  static const String maxLength = 'Maximum length is {max} characters';
  static const String invalidFormat = 'Invalid format';
  static const String mustBeNumber = 'Must be a number';
  static const String mustBeEmail = 'Must be a valid email address';
  static const String mustBePhone = 'Must be a valid phone number';
  static const String mustBeUrl = 'Must be a valid URL';
  static const String mustBeDate = 'Must be a valid date';
  static const String mustBeTime = 'Must be a valid time';
  static const String mustBePositive = 'Must be a positive number';
  static const String mustBeInteger = 'Must be an integer';
  static const String mustBeDecimal = 'Must be a decimal number';

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================
  
  /// Success messages
  static const String success = 'Success';
  static const String info = 'Info';
  static const String operationSuccessful = 'Operation completed successfully';
  static const String dataSaved = 'Data saved successfully';
  static const String dataUpdated = 'Data updated successfully';
  static const String dataDeleted = 'Data deleted successfully';
  static const String taskDeleted = 'Task deleted successfully';
  static const String profileUpdated = 'Profile updated successfully';
  static const String settingsSaved = 'Settings saved successfully';
  static const String passwordChanged = 'Password changed successfully';
  static const String emailSent = 'Email sent successfully';
  static const String notificationSent = 'Notification sent successfully';

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================
  
  /// Error messages
  static const String error = 'Error';
  static const String errorOccurred = 'An error occurred';
  static const String operationFailed = 'Operation failed';
  static const String dataNotSaved = 'Data could not be saved';
  static const String dataNotUpdated = 'Data could not be updated';
  static const String dataNotDeleted = 'Data could not be deleted';
  static const String taskNotCreated = 'Task could not be created';
  static const String taskNotUpdated = 'Task could not be updated';
  static const String taskNotDeleted = 'Task could not be deleted';
  static const String profileNotUpdated = 'Profile could not be updated';
  static const String settingsNotSaved = 'Settings could not be saved';
  static const String passwordNotChanged = 'Password could not be changed';
  static const String emailNotSent = 'Email could not be sent';
  static const String notificationNotSent = 'Notification could not be sent';
  static const String connectionError = 'Connection error';
  static const String serverError = 'Server error';
  static const String timeoutError = 'Request timeout';
  static const String unknownError = 'Unknown error occurred';
  static const String permissionDenied = 'Permission denied';
  static const String fileNotFound = 'File not found';
  static const String invalidFile = 'Invalid file';
  static const String fileTooLarge = 'File is too large';
  static const String unsupportedFormat = 'Unsupported file format';

  // ============================================================================
  // CONFIRMATION MESSAGES
  // ============================================================================
  
  /// Confirmation messages
  static const String confirm = 'Confirm';
  static const String confirmDelete = 'Are you sure you want to delete this item?';
  static const String confirmLogout = 'Are you sure you want to logout?';
  static const String confirmCancel = 'Are you sure you want to cancel?';
  static const String confirmSave = 'Are you sure you want to save?';
  static const String confirmUpdate = 'Are you sure you want to update?';
  static const String confirmReset = 'Are you sure you want to reset?';
  static const String confirmClear = 'Are you sure you want to clear?';
  static const String confirmRemove = 'Are you sure you want to remove?';
  static const String confirmExit = 'Are you sure you want to exit?';
  static const String unsavedChanges = 'You have unsaved changes. Are you sure you want to leave?';
  static const String dataWillBeLost = 'All data will be lost. Are you sure?';

  // ============================================================================
  // PLACEHOLDER STRINGS
  // ============================================================================
  
  /// Placeholder strings
  static const String enterEmail = 'Enter your email';
  static const String enterPassword = 'Enter your password';
  static const String enterTaskTitle = 'Enter task title';
  static const String enterTaskDescription = 'Enter task description';
  static const String enterCompanyName = 'Enter company name';
  static const String enterCompanyDescription = 'Enter company description';
  static const String enterSearchTerm = 'Enter search term';
  static const String selectDate = 'Select date';
  static const String selectTime = 'Select time';
  static const String selectCategory = 'Select category';
  static const String selectPriority = 'Select priority';
  static const String selectStatus = 'Select status';
  static const String selectAssignee = 'Select assignee';
  static const String noTasksFound = 'No tasks found';
  static const String noDataAvailable = 'No data available';
  static const String noResultsFound = 'No results found';
  static const String noInternetConnection = 'No internet connection';
  static const String tryAgain = 'Try again';
  static const String pullToRefresh = 'Pull to refresh';
  static const String swipeToDelete = 'Swipe to delete';
  static const String tapToEdit = 'Tap to edit';
  static const String longPressForOptions = 'Long press for options';

  // ============================================================================
  // DATE AND TIME STRINGS
  // ============================================================================
  
  /// Date and time related strings
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String tomorrow = 'Tomorrow';
  static const String thisWeek = 'This Week';
  static const String lastWeek = 'Last Week';
  static const String nextWeek = 'Next Week';
  static const String thisMonth = 'This Month';
  static const String lastMonth = 'Last Month';
  static const String nextMonth = 'Next Month';
  static const String thisYear = 'This Year';
  static const String lastYear = 'Last Year';
  static const String nextYear = 'Next Year';
  static const String overdue = 'Overdue';
  static const String dueToday = 'Due Today';
  static const String dueTomorrow = 'Due Tomorrow';
  static const String dueThisWeek = 'Due This Week';
  static const String dueNextWeek = 'Due Next Week';
  static const String dueThisMonth = 'Due This Month';
  static const String dueNextMonth = 'Due Next Month';
  static const String noDueDate = 'No Due Date';
  static const String customDate = 'Custom Date';
  static const String allTime = 'All Time';

  // ============================================================================
  // SETTINGS STRINGS
  // ============================================================================
  
  /// Settings related strings
  static const String general = 'General';
  static const String appearance = 'Appearance';
  static const String privacy = 'Privacy';
  static const String security = 'Security';
  static const String account = 'Account';
  static const String about = 'About';
  static const String help = 'Help';
  static const String support = 'Support';
  static const String feedback = 'Feedback';
  static const String rateApp = 'Rate App';
  static const String shareApp = 'Share App';
  static const String version = 'Version';
  static const String buildNumber = 'Build Number';
  static const String lastUpdated = 'Last Updated';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';
  static const String license = 'License';
  static const String credits = 'Credits';
  static const String acknowledgments = 'Acknowledgments';

  // ============================================================================
  // THEME STRINGS
  // ============================================================================
  
  /// Theme related strings
  static const String lightTheme = 'Light Theme';
  static const String darkTheme = 'Dark Theme';
  static const String systemTheme = 'System Theme';
  static const String autoTheme = 'Auto Theme';
  static const String theme = 'Theme';
  static const String colorScheme = 'Color Scheme';
  static const String primaryColor = 'Primary Color';
  static const String accentColor = 'Accent Color';
  static const String backgroundColor = 'Background Color';
  static const String textColor = 'Text Color';
  static const String fontSize = 'Font Size';
  static const String fontFamily = 'Font Family';

  // ============================================================================
  // WORKSPACE STRINGS (Selector UI)
  // ============================================================================
  static const String workspace = 'Workspace';
  static const String currentWorkspace = 'Current Workspace';
  static const String selectWorkspace = 'Select Workspace';
  static const String switchWorkspace = 'Switch Workspace';
  static const String noWorkspacesFound = 'No workspaces found';
  static const String personal = 'Personal';
  static const String company = 'Company';
  static const String createWorkspace = 'Create Workspace';
  static const String createCompanyWorkspace = 'Create Company Workspace';
  static const String workspaceName = 'Workspace Name';
  static const String workspaceDescription = 'Workspace Description';
  static const String enterWorkspaceName = 'Enter workspace name';
  static const String enterWorkspaceDescription = 'Enter workspace description (optional)';
  static const String pleaseEnterWorkspaceName = 'Please enter workspace name';
  static const String workspaceNameMinLength = 'Workspace name must be at least 2 characters';
  static const String workspaceCreatedSuccessfully = 'Workspace created successfully';
  static const String workspaceCreationFailed = 'Failed to create workspace';
  static const String workspaceSettings = 'Workspace Settings';
  static const String manageWorkspace = 'Manage Workspace';
  static const String workspaceMembers = 'Workspace Members';
  static const String workspaceType = 'Workspace Type';
  static const String personalWorkspace = 'Personal Workspace';
  static const String companyWorkspace = 'Company Workspace';
  static const String workspaceCreatedAt = 'Created At';
  static const String workspaceUpdatedAt = 'Updated At';
  static const String workspaceOwner = 'Workspace Owner';
  static const String editWorkspace = 'Edit Workspace';
  static const String deleteWorkspace = 'Delete Workspace';
  static const String confirmDeleteWorkspace = 'Are you sure you want to delete this workspace?';
  static const String workspaceDeletedSuccessfully = 'Workspace deleted successfully';
  static const String workspaceDeletionFailed = 'Failed to delete workspace';
  static const String updateWorkspace = 'Update Workspace';
  static const String workspaceUpdatedSuccessfully = 'Workspace updated successfully';
  static const String workspaceUpdateFailed = 'Failed to update workspace';
  static const String workspaceInformation = 'Workspace Information';
  static const String workspaceLogoUrl = 'Logo URL';
  static const String enterLogoUrl = 'Enter logo URL (optional)';
  static const String pleaseEnterValidUrl = 'Please enter a valid URL';
  static const String dangerZone = 'Danger Zone';
  static const String saveChanges = 'Save Changes';
  static const String workspaceSettingsUpdated = 'Workspace settings updated';
  static const String failedToUpdateSettings = 'Failed to update settings';
  static const String deleteWorkspaceConfirmation = 'Do you really want to delete this workspace?';
  static const String workspaceDeleted = 'Workspace deleted';
  static const String failedToDeleteWorkspace = 'Failed to delete workspace';
  static const String createFirstWorkspaceMessage = 'Create your first workspace to get started';
  static const String createWorkspaceComingSoon = 'Create workspace functionality coming soon';
  static const String personalWorkspaceDescription = 'For personal use and individual tasks';
  static const String companyWorkspaceDescription = 'For team collaboration and company projects';

  // User management / permissions
  static const String userManagement = 'User Management';
  static const String inviteUser = 'Invite User';
  static const String searchUsers = 'Search users';
  static const String noUsersFound = 'No users found';
  static const String inviteUsersToGetStarted = 'Invite users to get started';
  static const String emailAddress = 'Email Address';
  static const String enterEmailAddress = 'Enter email address';
  static const String pleaseEnterEmail = 'Please enter email';
  static const String pleaseEnterValidEmail = 'Please enter a valid email';
  static const String sendInvitation = 'Send Invitation';
  static const String invitationSent = 'Invitation sent';
  static const String failedToSendInvitation = 'Failed to send invitation';
  static const String invitationEmailSubject = 'You are invited to join a workspace';
  static const String invitationEmailBody = 'You have been invited to join a workspace. Follow the link to accept the invitation.';
  static const String editRole = 'Edit Role';
  static const String removeUser = 'Remove User';
  static const String removeUserConfirmation = 'Remove user';
  static const String remove = 'Remove';
  static const String userRemoved = 'User removed';
  static const String failedToRemoveUser = 'Failed to remove user';
  static const String selectRole = 'Select Role';
  static const String userRoleUpdated = 'User role updated';
  static const String failedToUpdateRole = 'Failed to update role';

  // Permission management
  static const String permissionManagement = 'Permission Management';
  static const String permissions = 'Permissions';
  static const String permissionGranted = 'Permission granted';
  static const String permissionRevoked = 'Permission revoked';
  static const String failedToUpdatePermission = 'Failed to update permission';
  static const String createTaskPermissionDescription = 'Allow creating tasks';
  static const String editTaskPermissionDescription = 'Allow editing tasks';
  static const String deleteTaskPermissionDescription = 'Allow deleting tasks';
  static const String viewTasksPermissionDescription = 'Allow viewing tasks';
  static const String manageUsersPermissionDescription = 'Allow managing users';
  static const String manageWorkspacePermissionDescription = 'Allow managing workspace';
  static const String viewAnalyticsPermissionDescription = 'Allow viewing analytics';
  static const String managePermissionsPermissionDescription = 'Allow managing permissions';
  static const String managePermissions = 'Manage Permissions';
  static const String viewTasks = 'View Tasks';
  static const String manageUsers = 'Manage Users';
  static const String createTask = 'Create Task';
  static const String viewAnalytics = 'View Analytics';
  static const String addUsersToManagePermissions = 'Add users to manage permissions';
  static const String user = 'User';
  static const String language = 'Language';
  static const String locale = 'Locale';
  static const String timezone = 'Timezone';
  static const String dateFormat = 'Date Format';
  static const String timeFormat = 'Time Format';
  static const String currency = 'Currency';
  static const String units = 'Units';

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Utility methods for string formatting
  static String formatMinLength(int min) => minLength.replaceAll('{min}', min.toString());
  static String formatMaxLength(int max) => maxLength.replaceAll('{max}', max.toString());
  
  /// Get task status display text
  static String getTaskStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'in_progress':
        return statusInProgress;
      case 'completed':
        return statusCompleted;
      case 'cancelled':
        return statusCancelled;
      case 'on_hold':
        return statusOnHold;
      default:
        return status;
    }
  }
  
  /// Get task priority display text
  static String getTaskPriorityText(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      case 'urgent':
        return priorityUrgent;
      default:
        return priority;
    }
  }
  
  /// Get task category display text
  static String getTaskCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return categoryWork;
      case 'personal':
        return categoryPersonal;
      case 'shopping':
        return categoryShopping;
      case 'health':
        return categoryHealth;
      case 'finance':
        return categoryFinance;
      case 'education':
        return categoryEducation;
      case 'travel':
        return categoryTravel;
      case 'other':
        return categoryOther;
      default:
        return category;
    }
  }
}
