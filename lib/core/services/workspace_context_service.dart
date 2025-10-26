import 'package:get/get.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';

/// WorkspaceContextService manages workspace context for Sprint 5
/// 
/// This service provides centralized workspace management including:
/// - Current workspace tracking
/// - Workspace members management
/// - Workspace projects management
/// - Workspace data filtering
class WorkspaceContextService extends GetxService {
  // Private observables
  final RxString _currentWorkspaceId = ''.obs;
  final RxList<User> _workspaceMembers = <User>[].obs;
  final RxList<Project> _workspaceProjects = <Project>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Public getters
  String get currentWorkspaceId => _currentWorkspaceId.value;
  List<User> get workspaceMembers => _workspaceMembers;
  List<Project> get workspaceProjects => _workspaceProjects;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  /// Set current workspace and load workspace data
  /// 
  /// [workspaceId] The workspace ID to set as current
  Future<void> setCurrentWorkspace(String workspaceId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      _currentWorkspaceId.value = workspaceId;
      await _loadWorkspaceData();
    } catch (e) {
      _errorMessage.value = 'Failed to set workspace: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load workspace data (members and projects)
  Future<void> _loadWorkspaceData() async {
    try {
      // Load workspace members
      await _loadWorkspaceMembers();
      
      // Load workspace projects
      await _loadWorkspaceProjects();
    } catch (e) {
      _errorMessage.value = 'Failed to load workspace data: $e';
    }
  }

  /// Load workspace members
  Future<void> _loadWorkspaceMembers() async {
    // TODO: Implement actual workspace members loading
    // This should call the appropriate service to get workspace members
    // For now, using empty list as placeholder
    _workspaceMembers.value = [];
  }

  /// Load workspace projects
  Future<void> _loadWorkspaceProjects() async {
    // TODO: Implement actual workspace projects loading
    // This should call the appropriate service to get workspace projects
    // For now, using empty list as placeholder
    _workspaceProjects.value = [];
  }

  /// Check if user is member of current workspace
  bool isWorkspaceMember(String userId) {
    return _workspaceMembers.any((user) => user.id == userId);
  }

  /// Get workspace member by ID
  User? getWorkspaceMember(String userId) {
    try {
      return _workspaceMembers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if project belongs to current workspace
  bool isWorkspaceProject(String projectId) {
    return _workspaceProjects.any((project) => project.id == projectId);
  }

  /// Get workspace project by ID
  Project? getWorkspaceProject(String projectId) {
    try {
      return _workspaceProjects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  /// Refresh workspace data
  Future<void> refreshWorkspaceData() async {
    if (_currentWorkspaceId.value.isNotEmpty) {
      await _loadWorkspaceData();
    }
  }

  /// Clear workspace context
  void clearWorkspaceContext() {
    _currentWorkspaceId.value = '';
    _workspaceMembers.clear();
    _workspaceProjects.clear();
    _errorMessage.value = '';
  }

  /// Validate workspace context
  bool get hasValidWorkspace => _currentWorkspaceId.value.isNotEmpty;

  /// Get workspace context info
  Map<String, dynamic> getWorkspaceContextInfo() {
    return {
      'workspaceId': _currentWorkspaceId.value,
      'memberCount': _workspaceMembers.length,
      'projectCount': _workspaceProjects.length,
      'isLoading': _isLoading.value,
      'hasError': _errorMessage.value.isNotEmpty,
    };
  }
}
