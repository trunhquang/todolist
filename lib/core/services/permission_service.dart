import 'package:get/get.dart';

/// WorkspacePermissions defines all available permissions for Sprint 5
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
}

/// DefaultPermissionSets defines default permission sets for different roles
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
}

/// PermissionService manages user permissions for Sprint 5
/// 
/// This service provides permission checking for all task operations:
/// - Task creation permissions
/// - Task assignment permissions
/// - Task status update permissions
/// - Workspace access permissions
class PermissionService extends GetxService {
  // Private observables
  final RxMap<String, List<String>> _userPermissions = <String, List<String>>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Public getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  /// Check if user has specific permission in workspace
  /// 
  /// [userId] The user ID to check permissions for
  /// [workspaceId] The workspace ID to check permissions in
  /// [permission] The permission to check
  Future<bool> hasPermission(String userId, String workspaceId, String permission) async {
    try {
      final permissions = await _getUserPermissions(userId, workspaceId);
      return permissions.contains(permission);
    } catch (e) {
      _errorMessage.value = 'Failed to check permission: $e';
      return false;
    }
  }

  /// Check if user can create tasks in workspace
  Future<bool> canCreateTask(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.createTasks);
  }

  /// Check if user can assign tasks in workspace
  Future<bool> canAssignTask(String userId, String workspaceId, String assigneeId) async {
    // First check if user has assign permission
    final canAssign = await hasPermission(userId, workspaceId, WorkspacePermissions.assignTasks);
    if (!canAssign) {
      return false;
    }

    // TODO: Check if assignee is in same workspace
    // This should validate that assignee is a member of the workspace
    return true;
  }

  /// Check if user can update task status in workspace
  Future<bool> canUpdateTaskStatus(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.updateTaskStatus);
  }

  /// Check if user can delete tasks in workspace
  Future<bool> canDeleteTask(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.deleteTasks);
  }

  /// Check if user can set task priority in workspace
  Future<bool> canSetTaskPriority(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.setTaskPriority);
  }

  /// Check if user can set task deadline in workspace
  Future<bool> canSetTaskDeadline(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.setTaskDeadline);
  }

  /// Check if user can create projects in workspace
  Future<bool> canCreateProject(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.createProjects);
  }

  /// Check if user can manage projects in workspace
  Future<bool> canManageProject(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.manageProjects);
  }

  /// Check if user can view all data in workspace
  Future<bool> canViewAllData(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.viewAllData);
  }

  /// Check if user can view team data in workspace
  Future<bool> canViewTeamData(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.viewTeamData);
  }

  /// Check if user can manage users in workspace
  Future<bool> canManageUsers(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.manageUsers);
  }

  /// Check if user can invite users to workspace
  Future<bool> canInviteUsers(String userId, String workspaceId) async {
    return hasPermission(userId, workspaceId, WorkspacePermissions.inviteUsers);
  }

  /// Get user permissions for workspace
  Future<List<String>> _getUserPermissions(String userId, String workspaceId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Check if permissions are cached
      final cacheKey = '${userId}_$workspaceId';
      if (_userPermissions.containsKey(cacheKey)) {
        return _userPermissions[cacheKey]!;
      }

      // TODO: Implement actual permission loading from Firebase
      // This should call the appropriate service to get user permissions
      // For now, returning default permissions based on user role
      final permissions = await _loadUserPermissions(userId, workspaceId);
      
      // Cache permissions
      _userPermissions[cacheKey] = permissions;
      
      return permissions;
    } catch (e) {
      _errorMessage.value = 'Failed to get user permissions: $e';
      return [];
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load user permissions from data source
  Future<List<String>> _loadUserPermissions(String userId, String workspaceId) async {
    // TODO: Implement actual permission loading
    // This should:
    // 1. Get user role in workspace
    // 2. Get role-based permissions
    // 3. Get custom permissions
    // 4. Merge and return final permissions
    
    // For now, returning default member permissions as placeholder
    return DefaultPermissionSets.defaultMemberPermissions;
  }

  /// Clear cached permissions for user
  void clearUserPermissions(String userId, String workspaceId) {
    final cacheKey = '${userId}_$workspaceId';
    _userPermissions.remove(cacheKey);
  }

  /// Clear all cached permissions
  void clearAllPermissions() {
    _userPermissions.clear();
  }

  /// Get permission display text
  String getPermissionDisplayText(String permission) {
    switch (permission) {
      case WorkspacePermissions.manageWorkspace:
        return 'Manage Workspace';
      case WorkspacePermissions.manageUsers:
        return 'Manage Users';
      case WorkspacePermissions.assignPermissions:
        return 'Assign Permissions';
      case WorkspacePermissions.createTasks:
        return 'Create Tasks';
      case WorkspacePermissions.assignTasks:
        return 'Assign Tasks';
      case WorkspacePermissions.updateTaskStatus:
        return 'Update Task Status';
      case WorkspacePermissions.deleteTasks:
        return 'Delete Tasks';
      case WorkspacePermissions.setTaskPriority:
        return 'Set Task Priority';
      case WorkspacePermissions.setTaskDeadline:
        return 'Set Task Deadline';
      case WorkspacePermissions.createProjects:
        return 'Create Projects';
      case WorkspacePermissions.manageProjects:
        return 'Manage Projects';
      case WorkspacePermissions.assignProjects:
        return 'Assign Projects';
      case WorkspacePermissions.viewAllData:
        return 'View All Data';
      case WorkspacePermissions.viewTeamData:
        return 'View Team Data';
      case WorkspacePermissions.viewPersonalData:
        return 'View Personal Data';
      case WorkspacePermissions.generateReports:
        return 'Generate Reports';
      case WorkspacePermissions.viewAnalytics:
        return 'View Analytics';
      case WorkspacePermissions.inviteUsers:
        return 'Invite Users';
      case WorkspacePermissions.removeUsers:
        return 'Remove Users';
      default:
        return permission;
    }
  }
}
