/// User role constants and permission management
/// 
/// This file contains all user role definitions and permission checking logic
/// for the TodoList application.
class UserRoles {
  // Private constructor to prevent instantiation
  UserRoles._();

  // ============================================================================
  // ROLE CONSTANTS
  // ============================================================================
  
  /// Admin role - Highest authority with full system access
  static const String admin = 'admin';
  
  /// Department Manager role - Department-level authority
  static const String departmentManager = 'user_level_0';
  
  /// Team Lead role - Team-level authority
  static const String teamLead = 'user_level_1';
  
  /// Regular User role - Individual contributor
  static const String regularUser = 'user_level_2';

  // ============================================================================
  // PERMISSION CONSTANTS
  // ============================================================================
  
  /// Company Management Permissions
  static const String manageCompany = 'manage_company';
  static const String manageDepartments = 'manage_departments';
  static const String manageUsers = 'manage_users';
  static const String assignRoles = 'assign_roles';
  
  /// Task Management Permissions
  static const String createTasks = 'create_tasks';
  static const String assignTasks = 'assign_tasks';
  static const String updateTaskStatus = 'update_task_status';
  static const String deleteTasks = 'delete_tasks';
  static const String setTaskPriority = 'set_task_priority';
  static const String setTaskDeadline = 'set_task_deadline';
  static const String closeTasks = 'close_tasks';
  
  /// Dashboard & Reports Permissions
  static const String viewCompanyDashboard = 'view_company_dashboard';
  static const String viewDepartmentDashboard = 'view_department_dashboard';
  static const String viewTeamDashboard = 'view_team_dashboard';
  static const String viewPersonalDashboard = 'view_personal_dashboard';
  static const String generateReports = 'generate_reports';
  static const String viewAnalytics = 'view_analytics';
  
  /// Data Access Permissions
  static const String viewAllData = 'view_all_data';
  static const String viewDepartmentData = 'view_department_data';
  static const String viewTeamData = 'view_team_data';
  static const String viewPersonalData = 'view_personal_data';
  
  /// Project Management Permissions
  static const String createProjects = 'create_projects';
  static const String manageProjects = 'manage_projects';
  static const String assignProjects = 'assign_projects';

  // ============================================================================
  // ROLE PERMISSIONS MAPPING
  // ============================================================================
  
  /// Admin permissions - Full access to everything
  static const List<String> adminPermissions = [
    // Company Management
    manageCompany,
    manageDepartments,
    manageUsers,
    assignRoles,
    
    // Task Management
    createTasks,
    assignTasks,
    updateTaskStatus,
    deleteTasks,
    setTaskPriority,
    setTaskDeadline,
    closeTasks,
    
    // Dashboard & Reports
    viewCompanyDashboard,
    viewDepartmentDashboard,
    viewTeamDashboard,
    viewPersonalDashboard,
    generateReports,
    viewAnalytics,
    
    // Data Access
    viewAllData,
    viewDepartmentData,
    viewTeamData,
    viewPersonalData,
    
    // Project Management
    createProjects,
    manageProjects,
    assignProjects,
  ];
  
  /// Department Manager permissions
  static const List<String> departmentManagerPermissions = [
    // Task Management
    createTasks,
    assignTasks,
    updateTaskStatus,
    closeTasks,
    setTaskPriority,
    setTaskDeadline,
    
    // Dashboard & Reports
    viewDepartmentDashboard,
    viewTeamDashboard,
    viewPersonalDashboard,
    generateReports,
    
    // Data Access
    viewDepartmentData,
    viewTeamData,
    viewPersonalData,
    
    // Project Management
    createProjects,
    manageProjects,
    assignProjects,
  ];
  
  /// Team Lead permissions
  static const List<String> teamLeadPermissions = [
    // Task Management
    createTasks,
    assignTasks,
    updateTaskStatus,
    closeTasks,
    setTaskPriority,
    setTaskDeadline,
    
    // Dashboard & Reports
    viewTeamDashboard,
    viewPersonalDashboard,
    generateReports,
    
    // Data Access
    viewTeamData,
    viewPersonalData,
    
    // Project Management
    createProjects,
    assignProjects,
  ];
  
  /// Regular User permissions
  static const List<String> regularUserPermissions = [
    // Task Management
    createTasks,
    updateTaskStatus,
    closeTasks,
    
    // Dashboard & Reports
    viewPersonalDashboard,
    
    // Data Access
    viewPersonalData,
  ];

  // ============================================================================
  // PERMISSION CHECKING METHODS
  // ============================================================================
  
  /// Check if a role has a specific permission
  static bool hasPermission(String role, String permission) {
    switch (role) {
      case admin:
        return adminPermissions.contains(permission);
      case departmentManager:
        return departmentManagerPermissions.contains(permission);
      case teamLead:
        return teamLeadPermissions.contains(permission);
      case regularUser:
        return regularUserPermissions.contains(permission);
      default:
        return false;
    }
  }
  
  /// Get all permissions for a role
  static List<String> getPermissions(String role) {
    switch (role) {
      case admin:
        return List.from(adminPermissions);
      case departmentManager:
        return List.from(departmentManagerPermissions);
      case teamLead:
        return List.from(teamLeadPermissions);
      case regularUser:
        return List.from(regularUserPermissions);
      default:
        return [];
    }
  }
  
  /// Check if a role can manage another role
  static bool canManageRole(String managerRole, String targetRole) {
    switch (managerRole) {
      case admin:
        return true; // Admin can manage all roles
      case departmentManager:
        return targetRole == teamLead || targetRole == regularUser;
      case teamLead:
        return targetRole == regularUser;
      case regularUser:
        return false; // Regular users cannot manage other roles
      default:
        return false;
    }
  }
  
  /// Get role hierarchy level (higher number = higher authority)
  static int getRoleLevel(String role) {
    switch (role) {
      case admin:
        return 4;
      case departmentManager:
        return 3;
      case teamLead:
        return 2;
      case regularUser:
        return 1;
      default:
        return 0;
    }
  }
  
  /// Check if a role has higher authority than another
  static bool hasHigherAuthority(String role1, String role2) {
    return getRoleLevel(role1) > getRoleLevel(role2);
  }
  
  /// Get role display name
  static String getRoleDisplayName(String role) {
    switch (role) {
      case admin:
        return 'Admin';
      case departmentManager:
        return 'Department Manager';
      case teamLead:
        return 'Team Lead';
      case regularUser:
        return 'Regular User';
      default:
        return 'Unknown Role';
    }
  }
  
  /// Get role description
  static String getRoleDescription(String role) {
    switch (role) {
      case admin:
        return 'Full system access and company management';
      case departmentManager:
        return 'Department-level management and task assignment';
      case teamLead:
        return 'Team-level task management and coordination';
      case regularUser:
        return 'Personal task management and completion';
      default:
        return 'Unknown role';
    }
  }
  
  /// Get all available roles
  static List<String> getAllRoles() {
    return [admin, departmentManager, teamLead, regularUser];
  }
  
  /// Validate if a role is valid
  static bool isValidRole(String role) {
    return getAllRoles().contains(role);
  }
}
