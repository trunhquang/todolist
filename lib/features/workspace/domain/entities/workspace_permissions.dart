/// Workspace permissions constants following V1 architecture
/// Permission-based access control system
class WorkspacePermissions {
  // Workspace Management
  static const String manageWorkspace = 'manage_workspace';
  static const String manageUsers = 'manage_users';
  static const String assignPermissions = 'assign_permissions';

  // Task Management
  static const String createTasks = 'create_tasks';
  static const String assignTasks = 'assign_tasks';
  static const String updateTaskStatus = 'update_task_status';
  static const String deleteTasks = 'delete_tasks';
  static const String setTaskPriority = 'set_task_priority';
  static const String setTaskDeadline = 'set_task_deadline';

  // Project Management
  static const String createProjects = 'create_projects';
  static const String manageProjects = 'manage_projects';
  static const String assignProjects = 'assign_projects';

  // Data Access
  static const String viewAllData = 'view_all_data';
  static const String viewTeamData = 'view_team_data';
  static const String viewPersonalData = 'view_personal_data';

  // Reports & Analytics
  static const String generateReports = 'generate_reports';
  static const String viewAnalytics = 'view_analytics';

  // Invitations
  static const String inviteUsers = 'invite_users';
  static const String removeUsers = 'remove_users';

  /// Get all available permissions
  static List<String> get allPermissions => [
        manageWorkspace,
        manageUsers,
        assignPermissions,
        createTasks,
        assignTasks,
        updateTaskStatus,
        deleteTasks,
        setTaskPriority,
        setTaskDeadline,
        createProjects,
        manageProjects,
        assignProjects,
        viewAllData,
        viewTeamData,
        viewPersonalData,
        generateReports,
        viewAnalytics,
        inviteUsers,
        removeUsers,
      ];

  /// Get permission display name
  static String getDisplayName(String permission) {
    switch (permission) {
      case manageWorkspace:
        return 'Manage Workspace';
      case manageUsers:
        return 'Manage Users';
      case assignPermissions:
        return 'Assign Permissions';
      case createTasks:
        return 'Create Tasks';
      case assignTasks:
        return 'Assign Tasks';
      case updateTaskStatus:
        return 'Update Task Status';
      case deleteTasks:
        return 'Delete Tasks';
      case setTaskPriority:
        return 'Set Task Priority';
      case setTaskDeadline:
        return 'Set Task Deadline';
      case createProjects:
        return 'Create Projects';
      case manageProjects:
        return 'Manage Projects';
      case assignProjects:
        return 'Assign Projects';
      case viewAllData:
        return 'View All Data';
      case viewTeamData:
        return 'View Team Data';
      case viewPersonalData:
        return 'View Personal Data';
      case generateReports:
        return 'Generate Reports';
      case viewAnalytics:
        return 'View Analytics';
      case inviteUsers:
        return 'Invite Users';
      case removeUsers:
        return 'Remove Users';
      default:
        return permission;
    }
  }

  /// Get permission description
  static String getDescription(String permission) {
    switch (permission) {
      case manageWorkspace:
        return 'Can modify workspace settings and configuration';
      case manageUsers:
        return 'Can add, remove, and manage workspace members';
      case assignPermissions:
        return 'Can assign and modify user permissions';
      case createTasks:
        return 'Can create new tasks in the workspace';
      case assignTasks:
        return 'Can assign tasks to other users';
      case updateTaskStatus:
        return 'Can update task status and progress';
      case deleteTasks:
        return 'Can delete tasks from the workspace';
      case setTaskPriority:
        return 'Can set task priority levels';
      case setTaskDeadline:
        return 'Can set task deadlines';
      case createProjects:
        return 'Can create new projects in the workspace';
      case manageProjects:
        return 'Can manage and modify projects';
      case assignProjects:
        return 'Can assign projects to team members';
      case viewAllData:
        return 'Can view all workspace data';
      case viewTeamData:
        return 'Can view team member data';
      case viewPersonalData:
        return 'Can view personal data only';
      case generateReports:
        return 'Can generate workspace reports';
      case viewAnalytics:
        return 'Can view workspace analytics';
      case inviteUsers:
        return 'Can invite new users to the workspace';
      case removeUsers:
        return 'Can remove users from the workspace';
      default:
        return 'Custom permission';
    }
  }
}

/// Default permission sets for different roles
class DefaultPermissionSets {
  // Account Holder permissions
  static const List<String> accountHolderPermissions = [
    WorkspacePermissions.manageWorkspace,
    WorkspacePermissions.manageUsers,
    WorkspacePermissions.assignPermissions,
    WorkspacePermissions.createTasks,
    WorkspacePermissions.assignTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.assignProjects,
    WorkspacePermissions.viewAllData,
    WorkspacePermissions.viewTeamData,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
    WorkspacePermissions.viewAnalytics,
    WorkspacePermissions.inviteUsers,
    WorkspacePermissions.removeUsers,
  ];

  // Admin permissions (customizable)
  static const List<String> defaultAdminPermissions = [
    WorkspacePermissions.manageUsers,
    WorkspacePermissions.createTasks,
    WorkspacePermissions.assignTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.assignProjects,
    WorkspacePermissions.viewAllData,
    WorkspacePermissions.viewTeamData,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
    WorkspacePermissions.viewAnalytics,
    WorkspacePermissions.inviteUsers,
  ];

  // Member permissions (customizable)
  static const List<String> defaultMemberPermissions = [
    WorkspacePermissions.createTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.viewPersonalData,
  ];

  // Personal user permissions
  static const List<String> personalUserPermissions = [
    WorkspacePermissions.createTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
  ];

  /// Get default permissions for a role
  static List<String> getDefaultPermissions(String role) {
    switch (role.toLowerCase()) {
      case 'account_holder':
        return List.from(accountHolderPermissions);
      case 'admin':
        return List.from(defaultAdminPermissions);
      case 'member':
        return List.from(defaultMemberPermissions);
      case 'personal':
        return List.from(personalUserPermissions);
      default:
        return List.from(defaultMemberPermissions);
    }
  }
}
