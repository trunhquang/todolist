import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
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


  final RxMap<String, ProjectProgressResult> _projectProgress = <String, ProjectProgressResult>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  Map<String, ProjectProgressResult> get projectProgress => _projectProgress;

  late Project project;

  List<User> getProjectMembers(String projectId) {
    return project.memberIds
        .map(_workspaceContext.getWorkspaceMember)
        .whereType<User>()
        .toList();
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

      project = updated;
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

      project = updated;
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
