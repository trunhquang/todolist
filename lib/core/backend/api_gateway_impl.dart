import 'package:todolist/core/backend/api_gateway.dart';
import 'package:todolist/core/backend/backend_service.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';

/// API Gateway Implementation
class ApiGatewayImpl implements BackendLayerInterface {
  final BackendServiceImpl _backendService;

  ApiGatewayImpl({
    required BackendServiceImpl backendService,
  }) : _backendService = backendService;

  @override
  Future<ApiResponse<TaskEntity>> createTask(CreateTaskRequest request) async {
    try {
      final task = await _backendService.processCreateTask(request);
      return ApiResponse.success(task);
    } catch (e) {
      return ApiResponse.error('Failed to create task: $e');
    }
  }

  @override
  Future<ApiResponse<List<TaskEntity>>> getTasks(GetTasksRequest request) async {
    try {
      final tasks = await _backendService.processGetTasks(request);
      return ApiResponse.success(tasks);
    } catch (e) {
      return ApiResponse.error('Failed to get tasks: $e');
    }
  }

  @override
  Future<ApiResponse<TaskEntity>> updateTask(UpdateTaskRequest request) async {
    try {
      final task = await _backendService.processUpdateTask(request);
      return ApiResponse.success(task);
    } catch (e) {
      return ApiResponse.error('Failed to update task: $e');
    }
  }

  @override
  Future<ApiResponse<void>> deleteTask(DeleteTaskRequest request) async {
    try {
      await _backendService.processDeleteTask(request);
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to delete task: $e');
    }
  }

  @override
  Future<ApiResponse<User>> createUser(CreateUserRequest request) async {
    try {
      final user = await _backendService.processCreateUser(request);
      return ApiResponse.success(user);
    } catch (e) {
      return ApiResponse.error('Failed to create user: $e');
    }
  }

  @override
  Future<ApiResponse<List<User>>> getUsers(GetUsersRequest request) async {
    try {
      final users = await _backendService.processGetUsers(request);
      return ApiResponse.success(users);
    } catch (e) {
      return ApiResponse.error('Failed to get users: $e');
    }
  }

  @override
  Future<ApiResponse<User>> updateUser(UpdateUserRequest request) async {
    try {
      final user = await _backendService.processUpdateUser(request);
      return ApiResponse.success(user);
    } catch (e) {
      return ApiResponse.error('Failed to update user: $e');
    }
  }

  @override
  Future<ApiResponse<Workspace>> createWorkspace(CreateWorkspaceRequest request) async {
    try {
      final workspace = await _backendService.processCreateWorkspace(request);
      return ApiResponse.success(workspace);
    } catch (e) {
      return ApiResponse.error('Failed to create workspace: $e');
    }
  }

  @override
  Future<ApiResponse<List<Workspace>>> getWorkspaces(GetWorkspacesRequest request) async {
    try {
      final workspaces = await _backendService.processGetWorkspaces(request);
      return ApiResponse.success(workspaces);
    } catch (e) {
      return ApiResponse.error('Failed to get workspaces: $e');
    }
  }

  @override
  Future<ApiResponse<void>> switchWorkspace(SwitchWorkspaceRequest request) async {
    try {
      await _backendService.processSwitchWorkspace(request);
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to switch workspace: $e');
    }
  }

  @override
  Future<ApiResponse<ReportEntity>> generateReport(GenerateReportRequest request) async {
    try {
      // TODO: Implement report generation
      throw UnimplementedError('Report generation not yet implemented');
    } catch (e) {
      return ApiResponse.error('Failed to generate report: $e');
    }
  }

  @override
  Future<ApiResponse<List<ReportEntity>>> getReports(GetReportsRequest request) async {
    try {
      // TODO: Implement get reports
      throw UnimplementedError('Get reports not yet implemented');
    } catch (e) {
      return ApiResponse.error('Failed to get reports: $e');
    }
  }
}
