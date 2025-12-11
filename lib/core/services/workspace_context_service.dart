import 'package:get/get.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// WorkspaceContextService manages workspace context for Sprint 5
/// 
/// This service provides centralized workspace management including:
/// - Current workspace tracking
/// - Workspace members management
/// - Workspace projects management
/// - Workspace data filtering
/// 
/// **Singleton Pattern**: This service is initialized once in AppInitializer
/// and remains persistent throughout the app lifecycle to ensure data consistency.
class WorkspaceContextService extends GetxService {
  // Private observables
  final RxString _currentWorkspaceId = ''.obs;
  final RxList<User> _workspaceMembers = <User>[].obs;
  final RxList<Project> _workspaceProjects = <Project>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Dependencies (lazy loaded to avoid circular dependencies)
  FirebaseDatabaseService? _databaseService;
  StorageService? _storageService;

  // Public getters
  String get currentWorkspaceId => _currentWorkspaceId.value;
  List<User> get workspaceMembers => _workspaceMembers;
  List<Project> get workspaceProjects => _workspaceProjects;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _syncWithWorkspaceController();
    _initializeFromStorage();
  }

  /// Initialize dependencies (lazy to avoid circular dependencies)
  void _initializeDependencies() {
    if (Get.isRegistered<FirebaseDatabaseService>()) {
      _databaseService = Get.find<FirebaseDatabaseService>();
    }
    if (Get.isRegistered<StorageService>()) {
      _storageService = Get.find<StorageService>();
    }
  }

  /// Initialize from storage if available
  Future<void> _initializeFromStorage() async {
    try {
      final storage = _storageService ?? Get.find<StorageService>();
      final workspaceId = storage.getWorkspaceId();
      if (workspaceId != null && workspaceId.isNotEmpty) {
        await setCurrentWorkspace(workspaceId);
      }
    } catch (e) {
      // Service might not be initialized yet, ignore
    }
  }

  /// Sync with WorkspaceController to auto-update when workspace changes
  void _syncWithWorkspaceController() {
    // Use async to avoid blocking initialization
    Future.microtask(() {
      if (Get.isRegistered<WorkspaceController>()) {
        final workspaceController = Get.find<WorkspaceController>();
        ever(workspaceController.currentWorkspace, (workspace) {
          if (workspace != null && workspace.id != _currentWorkspaceId.value) {
            setCurrentWorkspace(workspace.id);
          }
        });
      }
    });
  }

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

  /// Load workspace members from Firebase
  Future<void> _loadWorkspaceMembers() async {
    try {
      if (_currentWorkspaceId.value.isEmpty) {
        _workspaceMembers.value = [];
        return;
      }

      final database = _databaseService ?? Get.find<FirebaseDatabaseService>();
      
      // Load workspace members from Firebase
      final members = await database.listUsersByCompany(_currentWorkspaceId.value);
      
      _workspaceMembers.value = members;
    } catch (e) {
      _errorMessage.value = 'Failed to load workspace members: $e';
      _workspaceMembers.value = [];
    }
  }

  /// Load workspace projects from Firebase
  Future<void> _loadWorkspaceProjects() async {
    try {
      if (_currentWorkspaceId.value.isEmpty) {
        _workspaceProjects.value = [];
        return;
      }

      final database = _databaseService ?? Get.find<FirebaseDatabaseService>();
      
      // Load workspace projects from Firebase
      final projects = await database.listProjects(
        workspaceId: _currentWorkspaceId.value,
      );
      
      _workspaceProjects.value = projects;
    } catch (e) {
      _errorMessage.value = 'Failed to load workspace projects: $e';
      _workspaceProjects.value = [];
    }
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
