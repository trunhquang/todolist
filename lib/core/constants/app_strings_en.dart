import 'app_strings.dart';

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

class AppStringEns implements AppStrings{
  // Private constructor to prevent instantiation

  // ============================================================================
  // AUTHENTICATION STRINGS
  // ============================================================================
  
  /// Authentication related strings

  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get logout => 'Logout';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get confirmYourPassword => 'Confirm your password';
  @override
  String get pleaseConfirmPassword => 'Please confirm your password';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get resetPassword => 'Reset Password';
  @override
  String get resetPasswordDescription => 'Enter your email address and we\'ll send you a link to reset your password';
  @override
  String get sendResetLink => 'Send Reset Link';
  @override
  String get backToLogin => 'Back to Login';
  @override
  String get checkYourEmail => 'Check Your Email';
  @override
  String get resetLinkSent => 'Reset link sent to your email';
  @override
  String get didntReceiveEmail => 'Didn\'t receive the email?';
  @override
  String get resendEmail => 'Resend Email';
  @override
  String get enterEmailToReset => 'Enter your email to reset password';
  @override
  String get pleaseEnterEmailToReset => 'Please enter your email address to receive password reset instructions';
  @override
  String get rememberMe => 'Remember Me';
  @override
  String get signInWithGoogle => 'Sign in with Google';
  @override
  String get signInWithApple => 'Sign in with Apple';
  @override
  String get createAccount => 'Create Account';
  @override
  String get createAccountDescription => 'Create your account to get started';
  @override
  String get fullName => 'Full Name';
  @override
  String get enterFullName => 'Enter your full name';
  @override
  String get pleaseEnterFullName => 'Please enter your full name';
  @override
  String get nameMinLength => 'Name must be at least 2 characters';
  @override
  String get alreadyHaveAccount => 'Already have an account?';
  @override
  String get dontHaveAccount => "Don't have an account?";
  @override
  String get welcomeBack => 'Welcome Back';
  @override
  String get welcomeMessage => 'Welcome to TodoList';
  @override
  String get getStarted => 'Get Started';
  @override
  String get retry => 'Retry';
  @override
  String get checkConnection => 'Check Connection';
  @override
  String get requestPermission => 'Request Permission';
  @override
  String get fixIssues => 'Fix Issues';

  // Authentication Error Messages
  @override
  String get invalidEmail => 'Please enter a valid email address';
  @override
  String get emailNotVerified => 'Please verify your email before resetting password';
  @override
  String get passwordTooShort => 'Password must be at least 6 characters';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get emailRequired => 'Email is required';
  @override
  String get passwordRequired => 'Password is required';
  @override
  String get loginFailed => 'Login failed. Please try again.';
  @override
  String get registrationFailed => 'Registration failed. Please try again.';
  @override
  String get userNotFound => 'User not found';
  @override
  String get wrongPassword => 'Wrong password';
  @override
  String get emailAlreadyInUse => 'Email is already in use';
  @override
  String get weakPassword => 'Password is too weak';
  @override
  String get invalidCredentials => 'Invalid credentials';
  @override
  String get accountDisabled => 'This account has been disabled';
  @override
  String get tooManyRequests => 'Too many requests. Please try again later.';
  @override
  String get networkError => 'Network error. Please check your connection.';

  // Authentication Error Messages (VI)
  @override
  String get viAuthInvalidEmail => 'Email không hợp lệ';
  @override
  String get viAuthUserDisabled => 'Tài khoản đã bị vô hiệu hóa';
  @override
  String get viAuthUserNotFound => 'Không tìm thấy tài khoản với email này';
  @override
  String get viAuthWrongPassword => 'Mật khẩu không chính xác';
  @override
  String get viAuthEmailAlreadyInUse => 'Email đã được sử dụng cho tài khoản khác';
  @override
  String get viAuthWeakPassword => 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn';
  @override
  String get viAuthOperationNotAllowed => 'Phương thức đăng nhập này đang bị vô hiệu hóa';
  @override
  String get viAuthAccountExistsWithDifferentCredential => 'Email đã tồn tại với phương thức đăng nhập khác';
  @override
  String get viAuthInvalidCredential => 'Thông tin đăng nhập không hợp lệ';
  @override
  String get viAuthNetworkRequestFailed => 'Không thể kết nối mạng. Vui lòng kiểm tra lại internet';
  @override
  String get viAuthTooManyRequests => 'Thao tác bị chặn do thử quá nhiều lần. Vui lòng thử lại sau';
  @override
  String get viAuthSigninCanceled => 'Quá trình đăng nhập đã bị hủy';
  @override
  String get viAuthLoginFailed => 'Đăng nhập thất bại';
  @override
  String get viAuthSignupFailed => 'Tạo tài khoản thất bại';
  @override
  String get viAuthGoogleSigninFailed => 'Đăng nhập Google thất bại';
  @override
  String get viAuthAppleSigninFailed => 'Đăng nhập Apple thất bại';
  @override
  String get viAuthLogoutFailed => 'Đăng xuất thất bại';

  // Authentication Success Messages (VI)
  @override
  String get viAuthLoginSuccess => 'Đăng nhập thành công';
  @override
  String get viAuthSignupSuccess => 'Tạo tài khoản thành công';
  @override
  String get viAuthGoogleSigninSuccess => 'Đăng nhập Google thành công';
  @override
  String get viAuthAppleSigninSuccess => 'Đăng nhập Apple thành công';
  @override
  String get viAuthLogoutSuccess => 'Đăng xuất thành công';
  @override
  String get viAuthPasswordResetEmailSent => 'Đã gửi email đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetEmailSentTitle => 'Email đã được gửi';
  @override
  String get viAuthPasswordResetEmailSentMessage => 'Vui lòng kiểm tra email của bạn và làm theo hướng dẫn để đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetFailed => 'Không thể gửi email đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetFailedTitle => 'Gửi email thất bại';
  @override
  String get viAuthPasswordResetFailedMessage => 'Đã xảy ra lỗi khi gửi email. Vui lòng thử lại sau';
  @override
  String get viAuthInvalidEmailForReset => 'Email không hợp lệ';
  @override
  String get viAuthTooManyPasswordResetRequests => 'Bạn đã yêu cầu đặt lại mật khẩu quá nhiều lần. Vui lòng thử lại sau';

  // ============================================================================
  // NAVIGATION STRINGS
  // ============================================================================

  /// Navigation related strings
  @override
  String get home => 'Home';
  @override
  String get tasks => 'Tasks';
  @override
  String get profile => 'Profile';
  @override
  String get settings => 'Settings';
  @override
  String get projects => 'Projects';
  @override
  String get dashboard => 'Dashboard';
  @override
  String get reports => 'Reports';
  @override
  String get calendar => 'Calendar';
  @override
  String get notifications => 'Notifications';
  @override
  String get back => 'Back';
  @override
  String get next => 'Next';
  @override
  String get previous => 'Previous';
  @override
  String get done => 'Done';
  @override
  String get cancel => 'Cancel';
  @override
  String get save => 'Save';
  @override
  String get edit => 'Edit';
  @override
  String get delete => 'Delete';
  @override
  String get add => 'Add';
  @override
  String get create => 'Create';
  @override
  String get update => 'Update';
  @override
  String get search => 'Search';
  @override
  String get filter => 'Filter';
  @override
  String get sort => 'Sort';
  @override
  String get refresh => 'Refresh';
  @override
  String get loading => 'Loading...';
  @override
  String get searchProjects => 'Search projects';
  @override
  String get anyStatus => 'Any status';
  // duplicate removed

  // Backup/Export
  @override
  String get backup => 'Backup';
  @override
  String get backupToOneDrive => 'Backup to OneDrive';
  @override
  String get backupComplete => 'Backup Complete';
  @override
  String get backupFailed => 'Backup Failed';
  @override
  String get exportingDataToOneDrive => 'Exporting data to OneDrive...';
  @override
  String get dataExportedToOneDriveSuccessfully => 'Data exported to OneDrive successfully';
  @override
  String get restore => 'Restore';
  @override
  String get restoreComplete => 'Restore Complete';
  @override
  String get restoreFailed => 'Restore Failed';
  @override
  String get backupAndRestore => 'Backup & Restore';
  @override
  String get backupAndRestoreSubtitle => 'Export and restore backups';
  @override
  String get sizeLabel => 'Size';
  @override
  String get manageProjects => 'Manage projects';
  @override
  String get manageTasks => 'Manage tasks';
  @override
  String get export => 'Export';
  @override
  String get exportReports => 'Export Reports';
  @override
  String get exportingReports => 'Exporting reports to OneDrive...';
  @override
  String get exportComplete => 'Export Complete';
  @override
  String get exportFailed => 'Export Failed';
  @override
  String get reportsExported => 'Reports exported to OneDrive successfully';
  @override
  String get powerBi => 'Power BI';
  @override
  String get openPowerBiDashboard => 'Open Power BI Dashboard';
  @override
  String get dataRestoredPreview => 'Data restored successfully';
  @override
  String get taskStatistics => 'Task Statistics';
  @override
  String get overview => 'Overview';
  @override
  String get totalTasks => 'Total Tasks';
  @override
  String get byStatus => 'By Status';
  @override
  String get statusDistribution => 'Task status distribution';
  @override
  String get completionTrend => 'Completion Trend';
  @override
  String get tasksCompletedOverTime => 'Tasks completed over time';
  @override
  String get taskStatisticsSubtitle => 'Task statistics & insights';

  // ============================================================================
  // TASK MANAGEMENT STRINGS
  // ============================================================================

  /// Task related strings
  @override
  String get task => 'Task';
  @override
  String get newTask => 'New Task';
  @override
  String get addTask => 'Add Task';
  @override
  String get editTask => 'Edit Task';
  @override
  String get deleteTask => 'Delete Task';
  @override
  String get taskTitle => 'Task Title';
  @override
  String get taskDescription => 'Task Description';
  @override
  String get taskPriority => 'Priority';
  @override
  String get taskStatus => 'Status';
  @override
  String get taskDueDate => 'Due Date';
  @override
  String get taskCategory => 'Category';
  @override
  String get taskTags => 'Tags';
  @override
  String get taskAssignee => 'Assignee';
  @override
  String get taskCreated => 'Created';
  @override
  String get taskUpdated => 'Updated';
  @override
  String get taskCompleted => 'Completed';

  // Task Status
  @override
  String get statusPending => 'Pending';
  @override
  String get statusInProgress => 'In Progress';
  @override
  String get statusCompleted => 'Completed';
  @override
  String get statusCancelled => 'Cancelled';
  @override
  String get statusOnHold => 'On Hold';

  // Task Priority
  @override
  String get priorityLow => 'Low';
  @override
  String get priorityMedium => 'Medium';
  @override
  String get priorityHigh => 'High';
  @override
  String get priorityUrgent => 'Urgent';

  // Task Categories
  @override
  String get categoryWork => 'Work';
  @override
  String get categoryPersonal => 'Personal';
  @override
  String get categoryShopping => 'Shopping';
  @override
  String get categoryHealth => 'Health';
  @override
  String get categoryFinance => 'Finance';
  @override
  String get categoryEducation => 'Education';
  @override
  String get categoryTravel => 'Travel';
  @override
  String get categoryOther => 'Other';

  // Task Type Display Text
  @override
  String get taskTypeDaily => 'Daily';
  @override
  String get taskTypeProject => 'Project';

  // Project Status Display Text
  @override
  String get projectStatusActive => 'Active';
  @override
  String get projectStatusPending => 'Pending';
  @override
  String get projectStatusCompleted => 'Completed';
  @override
  String get projectStatusCancelled => 'Cancelled';
  @override
  String get projectStatusOnHold => 'On Hold';
  @override
  String get projectMembers => 'Members';
  @override
  String get addMember => 'Add Member';

  // Task Frequency Display Text
  @override
  String get frequencyDaily => 'Daily';
  @override
  String get frequencyWeekly => 'Weekly';
  @override
  String get frequencyMonthly => 'Monthly';
  @override
  String get frequencyYearly => 'Yearly';

  // Error Messages for Missing Data
  @override
  String get noworkspaceIdFound => 'No company ID found';
  @override
  String get failedToLoadTasks => 'Failed to load tasks';
  @override
  String get failedToLoadProjects => 'Failed to load projects';
  @override
  String get noReportsFound => 'No reports found';
  @override
  String get noReportsForDate => 'No reports were submitted for this date';
  @override
  String get createNewReport => 'Create New Report';

  // ============================================================================
  // COMPANY SETUP STRINGS
  // ============================================================================

  /// Company setup related strings
  @override
  String get companySetup => 'Company Setup';
  @override
  String get companySetupDescription => 'Create your company and first department to get started';
  @override
  String get companyName => 'Company Name';
  @override
  String get companyDescription => 'Company Description';
  @override
  String get companyAddress => 'Company Address';
  @override
  String get companyPhone => 'Company Phone';
  @override
  String get companyEmail => 'Company Email';
  @override
  String get companyWebsite => 'Company Website';
  @override
  String get companyLogo => 'Company Logo';
  @override
  String get setupCompany => 'Setup Company';
  @override
  String get completeSetup => 'Complete Setup';
  @override
  String get skipForNow => 'Skip for Now';
  @override
  String get departmentName => 'Department Name';
  @override
  String get enterDepartmentName => 'Enter your department name';
  @override
  String get companySetupComplete => 'Company setup completed successfully';
  @override
  String get companySetupFailed => 'Company setup failed. Please try again.';
  @override
  String get companyNameRequired => 'Company name is required';
  @override
  String get companyDescriptionRequired => 'Company description is required';
  @override
  String get pleaseEnterCompanyName => 'Please enter your company name';

  // Workspace strings
  @override
  String get personalWorkspaceDefault => 'Personal workspace';
  @override
  String get workspaceSuffix => 'Workspace';

  @override
  String get pleaseEnterDepartmentName => 'Please enter your department name';
  @override
  String get companyNameMinLength => 'Company name must be at least 2 characters';
  @override
  String get departmentNameMinLength => 'Department name must be at least 2 characters';

  // ============================================================================
  // VALIDATION STRINGS
  // ============================================================================

  /// Form validation strings
  @override
  String get fieldRequired => 'This field is required';
  @override
  String get invalidInput => 'Invalid input';
  @override
  String get invalidFormat => 'Invalid format';
  @override
  String get mustBeNumber => 'Must be a number';
  @override
  String get mustBeEmail => 'Must be a valid email address';
  @override
  String get mustBePhone => 'Must be a valid phone number';
  @override
  String get mustBeUrl => 'Must be a valid URL';
  @override
  String get mustBeDate => 'Must be a valid date';
  @override
  String get mustBeTime => 'Must be a valid time';
  @override
  String get mustBePositive => 'Must be a positive number';
  @override
  String get mustBeInteger => 'Must be an integer';
  @override
  String get mustBeDecimal => 'Must be a decimal number';

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================

  /// Success messages
  @override
  String get success => 'Success';
  @override
  String get info => 'Info';
  @override
  String get operationSuccessful => 'Operation completed successfully';
  @override
  String get dataSaved => 'Data saved successfully';
  @override
  String get dataUpdated => 'Data updated successfully';
  @override
  String get dataDeleted => 'Data deleted successfully';
  @override
  String get taskDeleted => 'Task deleted successfully';
  @override
  String get profileUpdated => 'Profile updated successfully';
  @override
  String get settingsSaved => 'Settings saved successfully';
  @override
  String get passwordChanged => 'Password changed successfully';
  @override
  String get emailSent => 'Email sent successfully';
  @override
  String get notificationSent => 'Notification sent successfully';

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================

  /// Error messages
  @override
  String get error => 'Error';
  @override
  String get errorOccurred => 'An error occurred';
  @override
  String get operationFailed => 'Operation failed';
  @override
  String get dataNotSaved => 'Data could not be saved';
  @override
  String get dataNotUpdated => 'Data could not be updated';
  @override
  String get dataNotDeleted => 'Data could not be deleted';
  @override
  String get taskNotCreated => 'Task could not be created';
  @override
  String get taskNotUpdated => 'Task could not be updated';
  @override
  String get taskNotDeleted => 'Task could not be deleted';
  @override
  String get profileNotUpdated => 'Profile could not be updated';
  @override
  String get settingsNotSaved => 'Settings could not be saved';
  @override
  String get passwordNotChanged => 'Password could not be changed';
  @override
  String get emailNotSent => 'Email could not be sent';
  @override
  String get notificationNotSent => 'Notification could not be sent';
  @override
  String get connectionError => 'Connection error';
  @override
  String get serverError => 'Server error';
  @override
  String get timeoutError => 'Request timeout';
  @override
  String get unknownError => 'Unknown error occurred';
  @override
  String get permissionDenied => 'Permission denied';
  @override
  String get fileNotFound => 'File not found';
  @override
  String get invalidFile => 'Invalid file';
  @override
  String get fileTooLarge => 'File is too large';
  @override
  String get unsupportedFormat => 'Unsupported file format';

  // ============================================================================
  // PROFILE STRINGS
  // ============================================================================

  /// Profile related strings
  @override
  String get editProfile => 'Edit Profile';
  @override
  String get appVersion => 'App Version';
  @override
  String get userID => 'User ID';
  @override
  String get created => 'Created';
  @override
  String get lastLogin => 'Last Login';
  @override
  String get status => 'Status';
  @override
  String get active => 'Active';
  @override
  String get inactive => 'Inactive';
  @override
  String get editProfileFeatureComingSoon => 'Edit profile feature coming soon';
  @override
  String get appVersionNumber => '1.0.0';

  // ============================================================================
  // CONFIRMATION MESSAGES
  // ============================================================================

  /// Confirmation messages
  @override
  String get confirm => 'Confirm';
  @override
  String get confirmDelete => 'Are you sure you want to delete this item?';
  @override
  String get confirmLogout => 'Are you sure you want to logout?';
  @override
  String get confirmCancel => 'Are you sure you want to cancel?';
  @override
  String get confirmSave => 'Are you sure you want to save?';
  @override
  String get confirmUpdate => 'Are you sure you want to update?';
  @override
  String get confirmReset => 'Are you sure you want to reset?';
  @override
  String get confirmClear => 'Are you sure you want to clear?';
  @override
  String get confirmRemove => 'Are you sure you want to remove?';
  @override
  String get confirmExit => 'Are you sure you want to exit?';
  @override
  String get unsavedChanges => 'You have unsaved changes. Are you sure you want to leave?';
  @override
  String get dataWillBeLost => 'All data will be lost. Are you sure?';

  // ============================================================================
  // PLACEHOLDER STRINGS
  // ============================================================================

  /// Placeholder strings
  @override
  String get enterEmail => 'Enter your email';
  @override
  String get enterPassword => 'Enter your password';
  @override
  String get enterTaskTitle => 'Enter task title';
  @override
  String get enterTaskDescription => 'Enter task description';
  @override
  String get enterCompanyName => 'Enter company name';
  @override
  String get enterCompanyDescription => 'Enter company description';
  @override
  String get enterSearchTerm => 'Enter search term';
  @override
  String get selectDate => 'Select date';
  @override
  String get selectTime => 'Select time';
  @override
  String get selectCategory => 'Select category';
  @override
  String get selectPriority => 'Select priority';
  @override
  String get selectStatus => 'Select status';
  @override
  String get selectAssignee => 'Select assignee';
  @override
  String get noTasksFound => 'No tasks found';
  @override
  String get createFirstTask => 'Create your first task';
  @override
  String get noDataAvailable => 'No data available';
  @override
  String get noResultsFound => 'No results found';
  @override
  String get noInternetConnection => 'No internet connection';
  @override
  String get tryAgain => 'Try again';
  @override
  String get pullToRefresh => 'Pull to refresh';
  @override
  String get swipeToDelete => 'Swipe to delete';
  @override
  String get tapToEdit => 'Tap to edit';
  @override
  String get longPressForOptions => 'Long press for options';

  // ============================================================================
  // DATE AND TIME STRINGS
  // ============================================================================

  /// Date and time related strings
  @override
  String get today => 'Today';
  @override
  String get yesterday => 'Yesterday';
  @override
  String get tomorrow => 'Tomorrow';
  @override
  String get thisWeek => 'This Week';
  @override
  String get lastWeek => 'Last Week';
  @override
  String get nextWeek => 'Next Week';
  @override
  String get thisMonth => 'This Month';
  @override
  String get lastMonth => 'Last Month';
  @override
  String get nextMonth => 'Next Month';
  @override
  String get thisYear => 'This Year';
  @override
  String get lastYear => 'Last Year';
  @override
  String get nextYear => 'Next Year';
  @override
  String get overdue => 'Overdue';
  @override
  String get dueToday => 'Due Today';
  @override
  String get dueTomorrow => 'Due Tomorrow';
  @override
  String get dueThisWeek => 'Due This Week';
  @override
  String get dueNextWeek => 'Due Next Week';
  @override
  String get dueThisMonth => 'Due This Month';
  @override
  String get dueNextMonth => 'Due Next Month';
  @override
  String get noDueDate => 'No Due Date';
  @override
  String get customDate => 'Custom Date';
  @override
  String get allTime => 'All Time';
  // Date helpers (formatters)
  static String formatDaysAgo(int days) => '$days days ago';

  // ============================================================================
  // SETTINGS STRINGS
  // ============================================================================

  /// Settings related strings
  @override
  String get general => 'General';
  @override
  String get appearance => 'Appearance';
  @override
  String get privacy => 'Privacy';
  @override
  String get security => 'Security';
  @override
  String get account => 'Account';
  @override
  String get about => 'About';
  @override
  String get help => 'Help';
  @override
  String get support => 'Support';
  @override
  String get feedback => 'Feedback';
  @override
  String get rateApp => 'Rate App';
  @override
  String get shareApp => 'Share App';
  @override
  String get version => 'Version';
  @override
  String get buildNumber => 'Build Number';
  @override
  String get lastUpdated => 'Last Updated';
  @override
  String get termsOfService => 'Terms of Service';
  @override
  String get privacyPolicy => 'Privacy Policy';
  @override
  String get license => 'License';
  @override
  String get credits => 'Credits';
  @override
  String get acknowledgments => 'Acknowledgments';

  // ============================================================================
  // THEME STRINGS
  // ============================================================================

  /// Theme related strings
  @override
  String get lightTheme => 'Light Theme';
  @override
  String get darkTheme => 'Dark Theme';
  @override
  String get systemTheme => 'System Theme';
  @override
  String get autoTheme => 'Auto Theme';
  @override
  String get theme => 'Theme';
  @override
  String get colorScheme => 'Color Scheme';
  @override
  String get primaryColor => 'Primary Color';
  @override
  String get accentColor => 'Accent Color';
  @override
  String get backgroundColor => 'Background Color';
  @override
  String get textColor => 'Text Color';
  @override
  String get fontSize => 'Font Size';
  @override
  String get fontFamily => 'Font Family';

  // ============================================================================
  // WORKSPACE STRINGS (Selector UI)
  // ============================================================================
  @override
  String get workspace => 'Workspace';
  @override
  String get currentWorkspace => 'Current Workspace';
  @override
  String get selectWorkspace => 'Select Workspace';
  @override
  String get switchWorkspace => 'Switch Workspace';
  @override
  String get noWorkspacesFound => 'No workspaces found';
  @override
  String get personal => 'Personal';
  @override
  String get company => 'Company';
  @override
  String get createWorkspace => 'Create Workspace';
  @override
  String get createCompanyWorkspace => 'Create Company Workspace';
  @override
  String get workspaceName => 'Workspace Name';
  @override
  String get workspaceDescription => 'Workspace Description';
  @override
  String get enterWorkspaceName => 'Enter workspace name';
  @override
  String get enterWorkspaceDescription => 'Enter workspace description (optional)';
  @override
  String get pleaseEnterWorkspaceName => 'Please enter workspace name';
  @override
  String get workspaceNameMinLength => 'Workspace name must be at least 2 characters';
  @override
  String get workspaceNameAlreadyExists => 'A workspace with this name already exists. Please choose a different name.';
  @override
  String get workspaceCreatedSuccessfully => 'Workspace created successfully';
  @override
  String get workspaceCreationFailed => 'Failed to create workspace';
  @override
  String get workspaceSettings => 'Workspace Settings';
  @override
  String get manageWorkspace => 'Manage Workspace';
  @override
  String get workspaceMembers => 'Workspace Members';
  @override
  String get workspaceType => 'Workspace Type';
  @override
  String get personalWorkspace => 'Personal Workspace';
  @override
  String get companyWorkspace => 'Company Workspace';
  @override
  String get workspaceCreatedAt => 'Created At';
  @override
  String get workspaceUpdatedAt => 'Updated At';
  @override
  String get workspaceOwner => 'Workspace Owner';
  @override
  String get editWorkspace => 'Edit Workspace';
  @override
  String get deleteWorkspace => 'Delete Workspace';
  @override
  String get confirmDeleteWorkspace => 'Are you sure you want to delete this workspace?';
  @override
  String get workspaceDeletedSuccessfully => 'Workspace deleted successfully';
  @override
  String get workspaceDeletionFailed => 'Failed to delete workspace';
  @override
  String get updateWorkspace => 'Update Workspace';
  @override
  String get workspaceUpdatedSuccessfully => 'Workspace updated successfully';
  @override
  String get workspaceUpdateFailed => 'Failed to update workspace';
  @override
  String get workspaceInformation => 'Workspace Information';
  @override
  String get workspaceLogoUrl => 'Logo URL';
  @override
  String get enterLogoUrl => 'Enter logo URL (optional)';
  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL';
  @override
  String get dangerZone => 'Danger Zone';
  @override
  String get saveChanges => 'Save Changes';
  @override
  String get workspaceSettingsUpdated => 'Workspace settings updated';
  @override
  String get failedToUpdateSettings => 'Failed to update settings';
  @override
  String get deleteWorkspaceConfirmation => 'Do you really want to delete this workspace?';
  @override
  String get workspaceDeleted => 'Workspace deleted';
  @override
  String get failedToDeleteWorkspace => 'Failed to delete workspace';
  @override
  String get createFirstWorkspaceMessage => 'Create your first workspace to get started';
  @override
  String get createWorkspaceComingSoon => 'Create workspace functionality coming soon';
  @override
  String get personalWorkspaceDescription => 'For personal use and individual tasks';
  @override
  String get companyWorkspaceDescription => 'For team collaboration and company projects';

  // Workspace Management Navigation
  @override
  String get workspaceManagement => 'Workspace Management';
  @override
  String get manageWorkspaceSettings => 'Manage Workspace Settings';
  @override
  String get manageWorkspaceMember => 'Manage Workspace Members';
  @override
  String get manageTeamMembers => 'Manage Team Members';
  @override
  String get manageUserPermissions => 'Manage User Permissions';
  @override
  String get workspaceAdminTools => 'Workspace Admin Tools';
  @override
  String get teamManagement => 'Team Management';
  @override
  String get onlyAccountHolderCanDelete => 'Only account holder can delete workspace';
  @override
  String get onlyAccountHolderAndAdminCanEdit => 'Only account holder and admin can edit workspace';
  @override
  String get onlyAccountHolderAndAdminCanInvite => 'Only account holder and admin can invite users';

  // User management / permissions
  @override
  String get userManagement => 'User Management';
  @override
  String get workspaceMemberInfoRequired => 'Name and email are required for workspace members';
  @override
  String get workspaceMemberInfoMissingPrompt => 'Please enter member name and email to continue';
  @override
  String get workspaceMemberNameRequired => 'Member name is required';
  @override
  String get workspaceMemberEmailRequired => 'Member email is required';
  @override
  String get inviteUser => 'Invite User';
  @override
  String get searchUsers => 'Search users';
  @override
  String get noUsersFound => 'No users found';
  @override
  String get inviteUsersToGetStarted => 'Invite users to get started';
  @override
  String get emailAddress => 'Email Address';
  @override
  String get enterEmailAddress => 'Enter email address';
  @override
  String get pleaseEnterEmail => 'Please enter email';
  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';
  @override
  String get sendInvitation => 'Send Invitation';
  @override
  String get invitationSent => 'Invitation sent';
  @override
  String get failedToSendInvitation => 'Failed to send invitation';
  @override
  String get invitationEmailSubject => 'You are invited to join a workspace';
  @override
  String get invitationEmailBody => 'You have been invited to join a workspace. Follow the link to accept the invitation.';
  @override
  String get invitationNotificationTitle => 'Workspace Invitation';
  @override
  String get invitationNotificationMessage => 'You have been invited to join a workspace. Tap to accept or decline.';
  @override
  String get invitationAccepted => 'Invitation accepted successfully';
  @override
  String get invitationDeclined => 'Invitation declined';
  @override
  String get noNotifications => 'No notifications';
  @override
  String get accept => 'Accept';
  @override
  String get decline => 'Decline';
  @override
  String get changePassword => 'Change Password';
  @override
  String get changePasswordRequired => 'Password Change Required';
  @override
  String get changePasswordDescription => 'For security reasons, you must change your password before continuing.';
  @override
  String get newPassword => 'New Password';
  @override
  String get pleaseEnterNewPassword => 'Please enter new password';
  @override
  String get userNotAuthenticated => 'User not authenticated';
  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';
  @override
  String get editRole => 'Edit Role';
  @override
  String get removeUser => 'Remove User';
  @override
  String get removeUserConfirmation => 'Remove user';
  @override
  String get remove => 'Remove';
  @override
  String get userRemoved => 'User removed';
  @override
  String get failedToRemoveUser => 'Failed to remove user';
  @override
  String get selectRole => 'Select Role';
  @override
  String get roleLabel => 'Role';
  @override
  String get userRoleUpdated => 'User role updated';
  @override
  String get failedToUpdateRole => 'Failed to update role';
  // Invitation management (UI labels/status)
  @override
  String get revokeInvitation => 'Revoke Invitation';
  @override
  String get invitationRevoked => 'Revoked';
  @override
  String get invitationWaiting => 'Waiting';
  @override
  String get invitationAcceptedStatus => 'Accepted';
  @override
  String get invitationDenied => 'Denied';
  @override
  String get invitedPrefix => 'Invited';

  // Permission management
  @override
  String get permissionManagement => 'Permission Management';
  @override
  String get permissions => 'Permissions';
  @override
  String get permissionGranted => 'Permission granted';
  @override
  String get permissionRevoked => 'Permission revoked';
  @override
  String get failedToUpdatePermission => 'Failed to update permission';
  @override
  String get createTaskPermissionDescription => 'Allow creating tasks';
  @override
  String get editTaskPermissionDescription => 'Allow editing tasks';
  @override
  String get deleteTaskPermissionDescription => 'Allow deleting tasks';
  @override
  String get viewTasksPermissionDescription => 'Allow viewing tasks';
  @override
  String get manageUsersPermissionDescription => 'Allow managing users';
  @override
  String get manageWorkspacePermissionDescription => 'Allow managing workspace';
  @override
  String get viewAnalyticsPermissionDescription => 'Allow viewing analytics';
  @override
  String get managePermissionsPermissionDescription => 'Allow managing permissions';
  @override
  String get managePermissions => 'Manage Permissions';
  @override
  String get viewTasks => 'View Tasks';
  @override
  String get manageUsers => 'Manage Users';
  @override
  String get createTask => 'Create Task';
  @override
  String get updateTask => 'Update Task';

  @override
  String get viewAnalytics => 'View Analytics';
  @override
  String get addUsersToManagePermissions => 'Add users to manage permissions';
  @override
  String get cannotModifyAdminPermissions => 'Cannot modify permissions for Account Holder and Admin roles';
  @override
  String get user => 'User';

  // Workspace Invitation Strings
  @override
  String get workspaceInvitation => 'Workspace Invitation';
  @override
  String get youHaveBeenInvited => 'You have been invited to join';
  @override
  String get byUser => 'by';
  @override
  String get acceptInvitation => 'Accept';
  @override
  String get declineInvitation => 'Decline';
  @override
  String get invitationAcceptedMessage => 'You have been added to the workspace';
  @override
  String get invitationDeclinedMessage => 'You have declined the invitation';
  @override
  String get invitationAcceptedNotification => 'User accepted your invitation';
  @override
  String get invitationDeclinedNotification => 'User declined your invitation';
  @override
  String get noPendingInvitations => 'No pending invitations';
  @override
  String get createWorkspaceInstead => 'Create Workspace Instead';
  @override
  String get language => 'Language';
  @override
  String get locale => 'Locale';
  @override
  String get timezone => 'Timezone';
  @override
  String get dateFormat => 'Date Format';
  @override
  String get timeFormat => 'Time Format';
  @override
  String get currency => 'Currency';
  @override
  String get units => 'Units';

//tasks
  @override
  String get statisticsTitle => 'Thống kê';

  // ============================================================================
  // PROJECT MANAGEMENT STRINGS
  // ============================================================================

  /// Project management related strings
  @override
  String get createProject => 'Create Project';
  @override
  String get noProjectsFound => 'No Projects Found';
  @override
  String get projectTitle => 'Project Title';
  @override
  String get enterProjectTitle => 'Enter project title';
  @override
  String get projectDescription => 'Project Description';
  @override
  String get enterProjectDescription => 'Enter project description';
  @override
  String get projectDeadline => 'Project Deadline';
}
