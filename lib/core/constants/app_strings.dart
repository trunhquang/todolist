import 'app_strings_vi.dart';

abstract class AppStrings {
  static late AppStrings I = AppStringsVi();

  String get login;

  String get register;
  String get logout;
  String get email;
  String get password;
  String get confirmPassword;
  String get confirmYourPassword;
  String get pleaseConfirmPassword;
  String get forgotPassword;
  String get resetPassword;
  String get resetPasswordDescription;
  String get sendResetLink;
  String get backToLogin;
  String get checkYourEmail;
  String get resetLinkSent;
  String get didntReceiveEmail;
  String get resendEmail;
  String get enterEmailToReset;
  String get pleaseEnterEmailToReset;
  String get rememberMe;
  String get signInWithGoogle;
  String get signInWithApple;
  String get createAccount;
  String get createAccountDescription;
  String get fullName;
  String get enterFullName;
  String get pleaseEnterFullName;
  String get nameMinLength;
  String get alreadyHaveAccount;
  String get dontHaveAccount;
  String get welcomeBack;
  String get welcomeMessage;
  String get getStarted;
  String get retry;
  String get checkConnection;
  String get requestPermission;
  String get fixIssues;

  // Authentication Error Messages
  String get invalidEmail;
  String get emailNotVerified;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
  String get emailRequired;
  String get passwordRequired;
  String get loginFailed;
  String get registrationFailed;
  String get userNotFound;
  String get wrongPassword;
  String get emailAlreadyInUse;
  String get weakPassword;
  String get invalidCredentials;
  String get accountDisabled;
  String get tooManyRequests;
  String get networkError;

  // Authentication Error Messages (VI)
  String get viAuthInvalidEmail;
  String get viAuthUserDisabled;
  String get viAuthUserNotFound;
  String get viAuthWrongPassword;
  String get viAuthEmailAlreadyInUse;
  String get viAuthWeakPassword;
  String get viAuthOperationNotAllowed;
  String get viAuthAccountExistsWithDifferentCredential;
  String get viAuthInvalidCredential;
  String get viAuthNetworkRequestFailed;
  String get viAuthTooManyRequests;
  String get viAuthSigninCanceled;
  String get viAuthLoginFailed;
  String get viAuthSignupFailed;
  String get viAuthGoogleSigninFailed;
  String get viAuthAppleSigninFailed;
  String get viAuthLogoutFailed;

  // Authentication Success Messages (VI)
  String get viAuthLoginSuccess;
  String get viAuthSignupSuccess;
  String get viAuthGoogleSigninSuccess;
  String get viAuthAppleSigninSuccess;
  String get viAuthLogoutSuccess;
  String get viAuthPasswordResetEmailSent;
  String get viAuthPasswordResetEmailSentTitle;
  String get viAuthPasswordResetEmailSentMessage;
  String get viAuthPasswordResetFailed;
  String get viAuthPasswordResetFailedTitle;
  String get viAuthPasswordResetFailedMessage;
  String get viAuthInvalidEmailForReset;
  String get viAuthTooManyPasswordResetRequests;

  // ============================================================================
  // NAVIGATION STRINGS
  // ============================================================================

  /// Navigation related strings
  String get home;
  String get tasks;
  String get profile;
  String get settings;
  String get projects;
  String get dashboard;
  String get reports;
  String get tasksByProject;
  String get tasksByStatus;
  String get tasksByPriority;
  String get calendar;
  String get notifications;
  String get back;
  String get next;
  String get previous;
  String get done;
  String get cancel;
  String get save;
  String get edit;
  String get delete;
  String get add;
  String get create;
  String get update;
  String get search;
  String get filter;
  String get sort;
  String get refresh;
  String get loading;
  String get searchProjects;
  String get anyStatus;
  // duplicate removed

  // Backup/Export
  String get backup;
  String get backupToOneDrive;
  String get backupComplete;
  String get backupFailed;
  String get exportingDataToOneDrive;
  String get dataExportedToOneDriveSuccessfully;
  String get restore;
  String get restoreComplete;
  String get restoreFailed;
  String get backupAndRestore;
  String get backupAndRestoreSubtitle;
  String get sizeLabel;
  String get manageProjects;
  String get manageTasks;
  String get export;
  String get exportReports;
  String get exportingReports;
  String get exportComplete;
  String get exportFailed;
  String get reportsExported;
  String get powerBi;
  String get openPowerBiDashboard;
  String get dataRestoredPreview;
  String get taskStatistics;
  String get overview;
  String get totalTasks;
  String get byStatus;
  String get statusDistribution;
  String get completionTrend;
  String get tasksCompletedOverTime;
  String get taskStatisticsSubtitle;

  // ============================================================================
  // TASK MANAGEMENT STRINGS
  // ============================================================================

  /// Task related strings
  String get task;
  String get newTask;
  String get addTask;
  String get editTask;
  String get deleteTask;
  String get taskTitle;
  String get taskDescription;
  String get taskPriority;
  String get taskStatus;
  String get taskDueDate;
  String get taskCategory;
  String get taskTags;
  String get taskAssignee;
  String get taskCreated;
  String get taskUpdated;
  String get taskCompleted;

  // Task Status
  String get statusPending;
  String get statusInProgress;
  String get statusCompleted;
  String get statusCancelled;
  String get statusOnHold;

  // Task Priority
  String get priorityLow;
  String get priorityMedium;
  String get priorityHigh;
  String get priorityUrgent;

  // Task Categories
  String get categoryWork;
  String get categoryPersonal;
  String get categoryShopping;
  String get categoryHealth;
  String get categoryFinance;
  String get categoryEducation;
  String get categoryTravel;
  String get categoryOther;

  // Task Type Display Text
  String get taskTypeDaily;
  String get taskTypeProject;

  // Project Status Display Text
  String get projectStatusActive;
  String get projectStatusPending;
  String get projectStatusCompleted;
  String get projectStatusCancelled;
  String get projectStatusOnHold;
  String get projectMembers;
  String get addMember;

  // Task Frequency Display Text
  String get frequencyDaily;
  String get frequencyWeekly;
  String get frequencyMonthly;
  String get frequencyYearly;

  // Error Messages for Missing Data
  String get noworkspaceIdFound;
  String get failedToLoadTasks;
  String get failedToLoadProjects;
  String get noReportsFound;
  String get noReportsForDate;
  String get createNewReport;

  // ============================================================================
  // COMPANY SETUP STRINGS
  // ============================================================================

  /// Company setup related strings
  String get companySetup;
  String get companySetupDescription;
  String get companyName;
  String get companyDescription;
  String get companyAddress;
  String get companyPhone;
  String get companyEmail;
  String get companyWebsite;
  String get companyLogo;
  String get setupCompany;
  String get completeSetup;
  String get skipForNow;
  String get departmentName;
  String get enterDepartmentName;
  String get companySetupComplete;
  String get companySetupFailed;
  String get companyNameRequired;
  String get companyDescriptionRequired;
  String get pleaseEnterCompanyName;

  // Workspace strings
  String get personalWorkspaceDefault;
  String get workspaceSuffix;

  // Utility: format personal workspace name from owner name
  static String personalWorkspaceNameFor(String ownerName) {
    return "$ownerName's ${I.workspaceSuffix}";
  }
  String get pleaseEnterDepartmentName;
  String get companyNameMinLength;
  String get departmentNameMinLength;

  // ============================================================================
  // VALIDATION STRINGS
  // ============================================================================

  /// Form validation strings
  String get fieldRequired;
  String get invalidInput;
  static const String minLength = 'Minimum length is {min} characters';
  static const String maxLength = 'Maximum length is {max} characters';
  String get invalidFormat;
  String get mustBeNumber;
  String get mustBeEmail;
  String get mustBePhone;
  String get mustBeUrl;
  String get mustBeDate;
  String get mustBeTime;
  String get mustBePositive;
  String get mustBeInteger;
  String get mustBeDecimal;

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================

  /// Success messages
  String get success;
  String get info;
  String get operationSuccessful;
  String get dataSaved;
  String get dataUpdated;
  String get dataDeleted;
  String get taskDeleted;
  String get profileUpdated;
  String get settingsSaved;
  String get passwordChanged;
  String get emailSent;
  String get notificationSent;

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================

  /// Error messages
  String get error;
  String get errorOccurred;
  String get operationFailed;
  String get dataNotSaved;
  String get dataNotUpdated;
  String get dataNotDeleted;
  String get taskNotCreated;
  String get taskNotUpdated;
  String get taskNotDeleted;
  String get profileNotUpdated;
  String get settingsNotSaved;
  String get passwordNotChanged;
  String get emailNotSent;
  String get notificationNotSent;
  String get connectionError;
  String get serverError;
  String get timeoutError;
  String get unknownError;
  String get permissionDenied;
  String get fileNotFound;
  String get invalidFile;
  String get fileTooLarge;
  String get unsupportedFormat;

  // ============================================================================
  // PROFILE STRINGS
  // ============================================================================

  /// Profile related strings
  String get editProfile;
  String get appVersion;
  String get userID;
  String get created;
  String get lastLogin;
  String get status;
  String get active;
  String get inactive;
  String get editProfileFeatureComingSoon;
  String get appVersionNumber;

  // ============================================================================
  // CONFIRMATION MESSAGES
  // ============================================================================

  /// Confirmation messages
  String get confirm;
  String get confirmDelete;
  String get confirmLogout;
  String get confirmCancel;
  String get confirmSave;
  String get confirmUpdate;
  String get confirmReset;
  String get confirmClear;
  String get confirmRemove;
  String get confirmExit;
  String get unsavedChanges;
  String get dataWillBeLost;

  // ============================================================================
  // PLACEHOLDER STRINGS
  // ============================================================================

  /// Placeholder strings
  String get enterEmail;
  String get enterPassword;
  String get enterTaskTitle;
  String get enterTaskDescription;
  String get enterCompanyName;
  String get enterCompanyDescription;
  String get enterSearchTerm;
  String get selectDate;
  String get selectTime;
  String get selectCategory;
  String get selectPriority;
  String get selectStatus;
  String get selectAssignee;
  String get noTasksFound;
  String get createFirstTask;
  String get noDataAvailable;
  String get noResultsFound;
  String get noInternetConnection;
  String get tryAgain;
  String get pullToRefresh;
  String get swipeToDelete;
  String get tapToEdit;
  String get longPressForOptions;

  // ============================================================================
  // DATE AND TIME STRINGS
  // ============================================================================

  /// Date and time related strings
  String get today;
  String get yesterday;
  String get tomorrow;
  String get thisWeek;
  String get lastWeek;
  String get nextWeek;
  String get thisMonth;
  String get lastMonth;
  String get nextMonth;
  String get thisYear;
  String get lastYear;
  String get nextYear;
  String get overdue;
  String get dueToday;
  String get dueTomorrow;
  String get dueThisWeek;
  String get dueNextWeek;
  String get dueThisMonth;
  String get dueNextMonth;
  String get noDueDate;
  String get customDate;
  String get allTime;
  // Date helpers (formatters)
  static String formatDaysAgo(int days) => '$days days ago';

  // ============================================================================
  // SETTINGS STRINGS
  // ============================================================================

  /// Settings related strings
  String get general;
  String get appearance;
  String get privacy;
  String get security;
  String get account;
  String get about;
  String get help;
  String get support;
  String get feedback;
  String get rateApp;
  String get shareApp;
  String get version;
  String get buildNumber;
  String get lastUpdated;
  String get termsOfService;
  String get privacyPolicy;
  String get license;
  String get credits;
  String get acknowledgments;

  // ============================================================================
  // THEME STRINGS
  // ============================================================================

  /// Theme related strings
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get autoTheme;
  String get theme;
  String get colorScheme;
  String get primaryColor;
  String get accentColor;
  String get backgroundColor;
  String get textColor;
  String get fontSize;
  String get fontFamily;

  // ============================================================================
  // WORKSPACE STRINGS (Selector UI)
  // ============================================================================
  String get workspace;
  String get currentWorkspace;
  String get selectWorkspace;
  String get switchWorkspace;
  String get noWorkspacesFound;
  String get personal;
  String get company;
  String get createWorkspace;
  String get createCompanyWorkspace;
  String get workspaceName;
  String get workspaceDescription;
  String get enterWorkspaceName;
  String get enterWorkspaceDescription;
  String get pleaseEnterWorkspaceName;
  String get workspaceNameMinLength;
  String get workspaceNameAlreadyExists;
  String get workspaceCreatedSuccessfully;
  String get workspaceCreationFailed;
  String get workspaceSettings;
  String get manageWorkspace;
  String get workspaceMembers;
  String get workspaceType;
  String get personalWorkspace;
  String get companyWorkspace;
  String get workspaceCreatedAt;
  String get workspaceUpdatedAt;
  String get workspaceOwner;
  String get editWorkspace;
  String get deleteWorkspace;
  String get confirmDeleteWorkspace;
  String get workspaceDeletedSuccessfully;
  String get workspaceDeletionFailed;
  String get updateWorkspace;
  String get workspaceUpdatedSuccessfully;
  String get workspaceUpdateFailed;
  String get workspaceInformation;
  String get workspaceLogoUrl;
  String get enterLogoUrl;
  String get pleaseEnterValidUrl;
  String get dangerZone;
  String get saveChanges;
  String get workspaceSettingsUpdated;
  String get failedToUpdateSettings;
  String get deleteWorkspaceConfirmation;
  String get workspaceDeleted;
  String get failedToDeleteWorkspace;
  String get createFirstWorkspaceMessage;
  String get createWorkspaceComingSoon;
  String get personalWorkspaceDescription;
  String get companyWorkspaceDescription;

  // Workspace Management Navigation
  String get workspaceManagement;
  String get manageWorkspaceSettings;
  String get manageWorkspaceMember;
  String get manageTeamMembers;
  String get manageUserPermissions;
  String get workspaceAdminTools;
  String get teamManagement;
  String get onlyAccountHolderCanDelete;
  String get onlyAccountHolderAndAdminCanEdit;
  String get onlyAccountHolderAndAdminCanInvite;

  // User management / permissions
  String get userManagement;
  String get workspaceMemberInfoRequired;
  String get workspaceMemberInfoMissingPrompt;
  String get workspaceMemberNameRequired;
  String get workspaceMemberEmailRequired;
  String get inviteUser;
  String get searchUsers;
  String get noUsersFound;
  String get inviteUsersToGetStarted;
  String get emailAddress;
  String get enterEmailAddress;
  String get pleaseEnterEmail;
  String get pleaseEnterValidEmail;
  String get sendInvitation;
  String get invitationSent;
  String get failedToSendInvitation;
  String get invitationEmailSubject;
  String get invitationEmailBody;
  String get invitationNotificationTitle;
  String get invitationNotificationMessage;
  String get invitationAccepted;
  String get invitationDeclined;
  String get noNotifications;
  String get accept;
  String get decline;
  String get changePassword;
  String get changePasswordRequired;
  String get changePasswordDescription;
  String get newPassword;
  String get pleaseEnterNewPassword;
  String get userNotAuthenticated;
  String get passwordChangedSuccessfully;
  String get editRole;
  String get removeUser;
  String get removeUserConfirmation;
  String get remove;
  String get userRemoved;
  String get failedToRemoveUser;
  String get selectRole;
  String get roleLabel;
  String get userRoleUpdated;
  String get failedToUpdateRole;
  // Invitation management (UI labels/status)
  String get revokeInvitation;
  String get invitationRevoked;
  String get invitationWaiting;
  String get invitationAcceptedStatus;
  String get invitationDenied;
  String get invitedPrefix;

  // Permission management
  String get permissionManagement;
  String get permissions;
  String get permissionGranted;
  String get permissionRevoked;
  String get failedToUpdatePermission;
  String get createTaskPermissionDescription;
  String get editTaskPermissionDescription;
  String get deleteTaskPermissionDescription;
  String get viewTasksPermissionDescription;
  String get manageUsersPermissionDescription;
  String get manageWorkspacePermissionDescription;
  String get viewAnalyticsPermissionDescription;
  String get managePermissionsPermissionDescription;
  String get managePermissions;
  String get viewTasks;
  String get manageUsers;
  String get createTask;
  String get updateTask;

  String get viewAnalytics;
  String get addUsersToManagePermissions;
  String get cannotModifyAdminPermissions;
  String get user;

  // Workspace Invitation Strings
  String get workspaceInvitation;
  String get youHaveBeenInvited;
  String get byUser;
  String get acceptInvitation;
  String get declineInvitation;
  String get invitationAcceptedMessage;
  String get invitationDeclinedMessage;
  String get invitationAcceptedNotification;
  String get invitationDeclinedNotification;
  String get noPendingInvitations;
  String get createWorkspaceInstead;
  String get language;
  String get locale;
  String get timezone;
  String get dateFormat;
  String get timeFormat;
  String get currency;
  String get units;

//tasks
  String get statisticsTitle;

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
        return I.statusPending;
      case 'in_progress':
        return I.statusInProgress;
      case 'completed':
        return I.statusCompleted;
      case 'cancelled':
        return I.statusCancelled;
      case 'on_hold':
        return I.statusOnHold;
      default:
        return status;
    }
  }

  /// Get task priority display text
  static String getTaskPriorityText(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return I.priorityLow;
      case 'medium':
        return I.priorityMedium;
      case 'high':
        return I.priorityHigh;
      case 'urgent':
        return I.priorityUrgent;
      default:
        return priority;
    }
  }

  /// Get task category display text
  static String getTaskCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return I.categoryWork;
      case 'personal':
        return I.categoryPersonal;
      case 'shopping':
        return I.categoryShopping;
      case 'health':
        return I.categoryHealth;
      case 'finance':
        return I.categoryFinance;
      case 'education':
        return I.categoryEducation;
      case 'travel':
        return I.categoryTravel;
      case 'other':
        return I.categoryOther;
      default:
        return category;
    }
  }

  // ============================================================================
  // PROJECT MANAGEMENT STRINGS
  // ============================================================================

  /// Project management related strings
  String get createProject;
  String get noProjectsFound;
  String get projectTitle;
  String get enterProjectTitle;
  String get projectDescription;
  String get enterProjectDescription;
  String get projectDeadline;
}
