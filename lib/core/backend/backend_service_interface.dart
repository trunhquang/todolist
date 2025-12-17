import '../../features/auth/domain/entities/user.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/workspace/domain/entities/workspace.dart';
import 'api_gateway.dart';

class Event {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? userId;
  final String? workspaceId;

  const Event({
    required this.type,
    required this.data,
    required this.timestamp,
    this.userId,
    this.workspaceId,
  });
}

abstract class BackendServiceInterface {
  // Task Business Logic
  Future<TaskEntity> processCreateTask(CreateTaskRequest request);
  Future<List<TaskEntity>> processGetTasks(GetTasksRequest request);
  Future<TaskEntity> processUpdateTask(UpdateTaskRequest request);
  Future<void> processDeleteTask(DeleteTaskRequest request);

  // User Business Logic
  Future<User> processCreateUser(CreateUserRequest request);
  Future<List<User>> processGetUsers(GetUsersRequest request);
  Future<User> processUpdateUser(UpdateUserRequest request);

  // Workspace Business Logic
  Future<Workspace> processCreateWorkspace(CreateWorkspaceRequest request);
  Future<List<Workspace>> processGetWorkspaces(GetWorkspacesRequest request);
  Future<void> processSwitchWorkspace(SwitchWorkspaceRequest request);

  // Permission Logic
  Future<bool> checkPermission(String userId, String permission, String workspaceId);
  Future<List<String>> getUserPermissions(String userId, String workspaceId);

  // Data Processing
  Future<void> processDataValidation(dynamic data);
  Future<dynamic> processDataTransformation(dynamic data);
  Future<void> processEventHandling(Event event);

  // Notification Business Logic
  Future<bool> sendNotificationToUserID({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  });
  Future<Map<String, bool>> sendNotificationToWorkspace({
    required String workspaceId,
    required String title,
    required String body,
    Map<String, String>? data,
  });
}
