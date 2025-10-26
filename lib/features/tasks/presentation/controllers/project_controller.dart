import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
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
  // Dependencies
  final ProjectRepository _projectRepository;
  final CalculateProjectProgress _calculateProgress;
  final WorkspaceContextService _workspaceContext;
  final AuthController? _authController;

  // Private observables
  final _projects = <Project>[].obs;
  final _projectProgress = <String, ProjectProgressResult>{}.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Constructor
  ProjectController({
    required ProjectRepository projectRepository,
    required CalculateProjectProgress calculateProgress,
    required WorkspaceContextService workspaceContext,
    AuthController? authController, // Optional for testing
  }) : _projectRepository = projectRepository,
       _calculateProgress = calculateProgress,
       _workspaceContext = workspaceContext,
       _authController = authController;

  // Public getters
  List<Project> get projects => _projects.where((project) => 
    project.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();
  
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  Map<String, ProjectProgressResult> get projectProgress => _projectProgress;

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
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
        status: 'pending',
        createdBy: currentUser.id,
        createdAt: DateTime.now(),
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
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
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
      throw ProjectControllerException('Failed to get project statistics: ${e.toString()}');
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
      throw ProjectControllerException('Failed to search projects: ${e.toString()}');
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
  final String message;
  WorkspaceMismatchException(this.message);
  
  @override
  String toString() => 'WorkspaceMismatchException: $message';
}

class ProjectControllerException implements Exception {
  final String message;
  ProjectControllerException(this.message);
  
  @override
  String toString() => 'ProjectControllerException: $message';
}
