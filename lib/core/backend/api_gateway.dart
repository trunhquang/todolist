import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';

/// API Response wrapper for all backend responses
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
    this.metadata,
  });

  factory ApiResponse.success(T data, {int? statusCode, Map<String, dynamic>? metadata}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      statusCode: statusCode ?? 200,
      metadata: metadata,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      error: error,
      statusCode: statusCode ?? 500,
    );
  }
}

/// Request/Response models for API Gateway
class CreateTaskRequest {
  final String title;
  final String? description;
  final String? assigneeId;
  final String? projectId;
  final String priority;
  final String status;
  final String taskType;
  final DateTime? deadline;
  final Map<String, dynamic>? recurringConfig;
  final String workspaceId;

  const CreateTaskRequest({
    required this.title,
    this.description,
    this.assigneeId,
    this.projectId,
    required this.priority,
    required this.status,
    required this.taskType,
    this.deadline,
    this.recurringConfig,
    required this.workspaceId,
  });
}

class GetTasksRequest {
  final String workspaceId;
  final int page;
  final int pageSize;
  final String? status;
  final String? priority;
  final String? taskType;
  final String? assigneeId;
  final String? projectId;
  final String? searchQuery;

  const GetTasksRequest({
    required this.workspaceId,
    this.page = 1,
    this.pageSize = 20,
    this.status,
    this.priority,
    this.taskType,
    this.assigneeId,
    this.projectId,
    this.searchQuery,
  });
}

class UpdateTaskRequest {
  final String taskId;
  final String? title;
  final String? description;
  final String? assigneeId;
  final String? projectId;
  final String? priority;
  final String? status;
  final String? taskType;
  final DateTime? deadline;
  final Map<String, dynamic>? recurringConfig;
  final String workspaceId;

  const UpdateTaskRequest({
    required this.taskId,
    this.title,
    this.description,
    this.assigneeId,
    this.projectId,
    this.priority,
    this.status,
    this.taskType,
    this.deadline,
    this.recurringConfig,
    required this.workspaceId,
  });
}

class DeleteTaskRequest {
  final String taskId;
  final String workspaceId;

  const DeleteTaskRequest({
    required this.taskId,
    required this.workspaceId,
  });
}

class CreateUserRequest {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final bool mustChangePassword;

  const CreateUserRequest({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.mustChangePassword = false,
  });
}

class GetUsersRequest {
  final String workspaceId;
  final int page;
  final int pageSize;
  final String? searchQuery;

  const GetUsersRequest({
    required this.workspaceId,
    this.page = 1,
    this.pageSize = 20,
    this.searchQuery,
  });
}

class UpdateUserRequest {
  final String userId;
  final String? name;
  final String? profileImageUrl;
  final String? workspaceId;

  const UpdateUserRequest({
    required this.userId,
    this.name,
    this.profileImageUrl,
    this.workspaceId,
  });
}

class CreateWorkspaceRequest {
  final String name;
  final String type;
  final String? description;
  final String createdBy;
  final Map<String, dynamic>? settings;

  const CreateWorkspaceRequest({
    required this.name,
    required this.type,
    this.description,
    required this.createdBy,
    this.settings,
  });
}

class GetWorkspacesRequest {
  final String userId;
  final int page;
  final int pageSize;

  const GetWorkspacesRequest({
    required this.userId,
    this.page = 1,
    this.pageSize = 20,
  });
}

class SwitchWorkspaceRequest {
  final String userId;
  final String workspaceId;

  const SwitchWorkspaceRequest({
    required this.userId,
    required this.workspaceId,
  });
}

class GenerateReportRequest {
  final String userId;
  final String workspaceId;
  final DateTime startDate;
  final DateTime endDate;
  final String reportType;

  const GenerateReportRequest({
    required this.userId,
    required this.workspaceId,
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });
}

class GetReportsRequest {
  final String userId;
  final String workspaceId;
  final int page;
  final int pageSize;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetReportsRequest({
    required this.userId,
    required this.workspaceId,
    this.page = 1,
    this.pageSize = 20,
    this.startDate,
    this.endDate,
  });
}

class SendNotificationToUserRequest {
  final String userId;
  final String title;
  final String body;
  final Map<String, String>? data;
  final String? imageUrl;
  final String? clickAction;

  const SendNotificationToUserRequest({
    required this.userId,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.clickAction,
  });
}

class SendNotificationToWorkspaceRequest {
  final String workspaceId;
  final String title;
  final String body;
  final Map<String, String>? data;
  final String? imageUrl;
  final String? clickAction;

  const SendNotificationToWorkspaceRequest({
    required this.workspaceId,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.clickAction,
  });
}

/// Backend Layer (API Gateway) Interface
abstract class BackendLayerInterface {
  // Task Management
  Future<ApiResponse<TaskEntity>> createTask(CreateTaskRequest request);
  Future<ApiResponse<List<TaskEntity>>> getTasks(GetTasksRequest request);
  Future<ApiResponse<TaskEntity>> updateTask(UpdateTaskRequest request);
  Future<ApiResponse<void>> deleteTask(DeleteTaskRequest request);
  
  // User Management
  Future<ApiResponse<User>> createUser(CreateUserRequest request);
  Future<ApiResponse<List<User>>> getUsers(GetUsersRequest request);
  Future<ApiResponse<User>> updateUser(UpdateUserRequest request);
  
  // Workspace Management
  Future<ApiResponse<Workspace>> createWorkspace(CreateWorkspaceRequest request);
  Future<ApiResponse<List<Workspace>>> getWorkspaces(GetWorkspacesRequest request);
  Future<ApiResponse<void>> switchWorkspace(SwitchWorkspaceRequest request);
  
  // Reports
  Future<ApiResponse<ReportEntity>> generateReport(GenerateReportRequest request);
  Future<ApiResponse<List<ReportEntity>>> getReports(GetReportsRequest request);
  
  // Notifications
  Future<ApiResponse<bool>> sendNotificationToUser(SendNotificationToUserRequest request);
  Future<ApiResponse<Map<String, bool>>> sendNotificationToWorkspace(SendNotificationToWorkspaceRequest request);
}
