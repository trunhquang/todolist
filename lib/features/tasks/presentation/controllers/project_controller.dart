import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';

/// ProjectController manages project operations with workspace context for Sprint 6
/// 
/// This controller handles:
/// - Project creation and management
/// - Project progress tracking
/// - Project statistics
/// - Workspace-specific project filtering
class ProjectController extends GetxController {

  // Constructor
  ProjectController({
    required ProjectRepository projectRepository,
    required CalculateProjectProgress calculateProgress,
    required WorkspaceContextService workspaceContext,
    PermissionService? permissionService,
    AuthController? authController, // Optional for testing
  }) : _projectRepository = projectRepository,
       _calculateProgress = calculateProgress,
       _workspaceContext = workspaceContext,
       _permissionService = permissionService ?? Get.find<PermissionService>(),
       _authController = authController;
  // Dependencies
  final ProjectRepository _projectRepository;
  final CalculateProjectProgress _calculateProgress;
  final WorkspaceContextService _workspaceContext;
  final PermissionService _permissionService;
  final AuthController? _authController;

  // Private observables
  final RxList<Project> _projects = <Project>[].obs;
  final RxMap<String, ProjectProgressResult> _projectProgress = <String, ProjectProgressResult>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Public getters
  List<Project> get projects => _projects.where((project) => 
    project.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();
  
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  Map<String, ProjectProgressResult> get projectProgress => _projectProgress;
  List<User> getProjectMembers(String projectId) {
    final project = _findProject(projectId);
    if (project == null) return <User>[];
    return project.memberIds
        .map(_workspaceContext.getWorkspaceMember)
        .whereType<User>()
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadProjects();
  }

  /// Load projects for current workspace
  Future<void> _loadProjects() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }

      final projects = await _projectRepository.getProjects(
        workspaceId: _workspaceContext.currentWorkspaceId,
      );

      _projects.value = projects;

      // Calculate progress for each project
      await _calculateAllProjectProgress();
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new project with workspace context
  Future<void> createProject({
    required String title,
    String? description,
    DateTime? deadline,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate workspace context
      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }

      // Get current user
      final authController = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
      if (authController == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'Auth controller not found');
        return;
      }

      final currentUser = authController.currentUser;
      if (currentUser == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'User not logged in');
        return;
      }

      // Create project entity
      final project = Project(
        id: _generateProjectId(),
        title: title,
        description: description,
        workspaceId: _workspaceContext.currentWorkspaceId,
        status: ProjectStatus.pending,
        createdBy: currentUser.id,
        createdAt: DateTime.now(),
        memberIds: <String>[currentUser.id],
        deadline: deadline,
      );

      // Save project
      final createdProject = await _projectRepository.createProject(
        workspaceId: _workspaceContext.currentWorkspaceId,
        project: project,
      );

      _projects.add(createdProject);

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: 'Project created successfully',
      );
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update project
  Future<void> updateProject(Project project) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate workspace context
      if (project.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException('Project does not belong to current workspace');
      }

      // Permission check: owner or workspace permission to manage projects
      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }
      final canManage = await _canManageProject(project, currentUser.id);
      if (!canManage) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }

      // Update project
      final updatedProject = await _projectRepository.updateProject(
        workspaceId: _workspaceContext.currentWorkspaceId,
        project: project,
      );

      // Update in local list
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = updatedProject;
      }

      // Recalculate progress
      await _calculateProjectProgress(project.id);

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: 'Project updated successfully',
      );
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete project
  Future<void> deleteProject(String projectId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Find project
      final project = _projects.firstWhere((p) => p.id == projectId);

      // Validate workspace context
      if (project.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException('Project does not belong to current workspace');
      }

      // Permission check: owner or workspace permission to manage projects
      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }
      final canManage = await _canManageProject(project, currentUser.id);
      if (!canManage) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }

      // Delete project
      await _projectRepository.deleteProject(
        workspaceId: _workspaceContext.currentWorkspaceId,
        projectId: projectId,
      );

      // Remove from local list
      _projects.removeWhere((p) => p.id == projectId);
      _projectProgress.remove(projectId);

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: 'Project deleted successfully',
      );
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Add member to project with workspace validation
  Future<void> addProjectMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }
      final project = _findProject(projectId);
      if (project == null) {
        _errorMessage.value = 'Project not found';
        return;
      }
      if (!_workspaceContext.isWorkspaceMember(userId)) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        return;
      }

      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }
      final canManage = await _canManageProject(project, currentUser.id);
      if (!canManage) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }

      final updated = await _projectRepository.addMember(
        workspaceId: _workspaceContext.currentWorkspaceId,
        projectId: projectId,
        userId: userId,
      );

      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = updated;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(title: AppStrings.error, message: e.toString());
    }
  }

  /// Remove member from project with workspace validation
  Future<void> removeProjectMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }
      final project = _findProject(projectId);
      if (project == null) {
        _errorMessage.value = 'Project not found';
        return;
      }

      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }
      final canManage = await _canManageProject(project, currentUser.id);
      if (!canManage) {
        SnackbarService().showError(title: AppStrings.error, message: AppStrings.permissionDenied);
        return;
      }

      final updated = await _projectRepository.removeMember(
        workspaceId: _workspaceContext.currentWorkspaceId,
        projectId: projectId,
        userId: userId,
      );

      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = updated;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(title: AppStrings.error, message: e.toString());
    }
  }

  Future<bool> _canManageProject(Project project, String userId) async {
    if (project.createdBy == userId) return true;
    return _permissionService.canManageProject(userId, project.workspaceId);
  }

  User? _getCurrentUser() {
    final controller = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
    return controller?.currentUser;
  }

  Project? _findProject(String projectId) {
    try {
      return _projects.firstWhere((p) => p.id == projectId);
    } catch (_) {
      return null;
    }
  }

  /// Calculate progress for all projects
  Future<void> _calculateAllProjectProgress() async {
    for (final project in _projects) {
      await _calculateProjectProgress(project.id);
    }
  }

  /// Calculate progress for a specific project
  Future<void> _calculateProjectProgress(String projectId) async {
    try {
      final result = await _calculateProgress.call(
        workspaceId: _workspaceContext.currentWorkspaceId,
        projectId: projectId,
      );

      if (result.isSuccess) {
        _projectProgress[projectId] = result;
      }
    } catch (e) {
      // Handle error silently for progress calculation
      print('Failed to calculate progress for project $projectId: $e');
    }
  }

  /// Get project progress
  ProjectProgressResult? getProjectProgress(String projectId) {
    return _projectProgress[projectId];
  }

  /// Get project statistics
  Future<ProjectStatistics> getProjectStatistics(String projectId) async {
    try {
      return await _projectRepository.getProjectStatistics(
        workspaceId: _workspaceContext.currentWorkspaceId,
        projectId: projectId,
      );
    } catch (e) {
      throw ProjectControllerException('Failed to get project statistics: $e');
    }
  }

  /// Search projects
  Future<List<Project>> searchProjects(String query) async {
    try {
      return await _projectRepository.searchProjects(
        workspaceId: _workspaceContext.currentWorkspaceId,
        query: query,
      );
    } catch (e) {
      throw ProjectControllerException('Failed to search projects: $e');
    }
  }

  /// Refresh projects
  Future<void> refreshProjects() async {
    await _loadProjects();
  }

  /// Generate unique project ID
  String _generateProjectId() {
    return 'project_${DateTime.now().millisecondsSinceEpoch}_${_projects.length}';
  }

  /// Test helper method to add projects directly (for testing only)
  void addProjectForTest(Project project) {
    _projects.add(project);
  }

  /// Test helper method to add multiple projects directly (for testing only)
  void addProjectsForTest(List<Project> projects) {
    _projects.addAll(projects);
  }
}

/// Custom exceptions for Sprint 6
class WorkspaceMismatchException implements Exception {
  WorkspaceMismatchException(this.message);
  final String message;
  
  @override
  String toString() => 'WorkspaceMismatchException: $message';
}

class ProjectControllerException implements Exception {
  ProjectControllerException(this.message);
  final String message;
  
  @override
  String toString() => 'ProjectControllerException: $message';
}
