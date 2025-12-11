import 'package:get/get.dart';

import '../../features/workspace/domain/entities/workspace_member.dart';
import '../../features/workspace/domain/entities/workspace_permissions.dart';
import '../../features/workspace/domain/repositories/workspace_repository.dart';
import '../errors/failures.dart';


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

    // Validate assignee belongs to the same workspace and is active
    try {
      final workspaceRepository = Get.find<WorkspaceRepository>();
      final memberResult =
          await workspaceRepository.getUserWorkspaceRole(assigneeId, workspaceId);

      return memberResult.fold(
        (Failure failure) {
          _errorMessage.value = failure.message;
          return false;
        },
        (WorkspaceMember? member) {
          if (member == null || !member.isActive) {
            return false;
          }
          // Assignee is a valid member in the workspace
          return true;
        },
      );
    } catch (e) {
      _errorMessage.value = 'Failed to validate assignee membership: $e';
      return false;
    }
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
    // Basic validation
    if (userId.isEmpty || workspaceId.isEmpty) {
      _errorMessage.value = 'Missing user or workspace identifier';
      return <String>[];
    }

    try {
      // Resolve repository lazily to avoid constructor injection changes
      final workspaceRepository = Get.find<WorkspaceRepository>();

      // Fetch member info (role + custom permissions)
      final memberResult =
          await workspaceRepository.getUserWorkspaceRole(userId, workspaceId);

      return memberResult.fold(
        (Failure failure) {
          _errorMessage.value = failure.message;
          return <String>[];
        },
        (WorkspaceMember? member) {
          if (member == null || !member.isActive) {
            return <String>[];
          }

          // Default permissions by role
          final rolePermissions =
              DefaultPermissionSets.getDefaultPermissions(member.role.value);

          // Merge role-based and custom permissions, remove duplicates
          final mergedPermissions = <String>{
            ...rolePermissions,
            ...member.permissions,
          }.toList();

          return mergedPermissions;
        },
      );
    } catch (e) {
      _errorMessage.value = 'Failed to load user permissions: $e';
      return <String>[];
    }
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
