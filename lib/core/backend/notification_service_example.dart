import 'package:get/get.dart';
import 'package:todolist/core/backend/notification_service.dart';
import 'package:todolist/core/backend/api_gateway.dart';
import 'package:todolist/core/backend/backend_service.dart';
import 'package:todolist/core/backend/external_services_manager.dart';

import 'api_gateway_impl.dart';

/// Example usage of Notification Service
class NotificationServiceExample {
  static void setupDependencies() {
    // Register notification service as singleton
    Get.put<NotificationServiceImpl>(
      NotificationServiceImpl(),
      permanent: true,
    );

    // Register external services manager
    Get.put<ExternalServicesManager>(
      ExternalServicesManager(),
      permanent: true,
    );

    // Register backend service with notification service
    Get.put<BackendServiceImpl>(
      BackendServiceImpl(
        externalServices: Get.find<ExternalServicesManager>(),
        notificationService: Get.find<NotificationServiceImpl>(),
      ),
      permanent: true,
    );

    // Register API Gateway
    Get.put<BackendLayerInterface>(
      ApiGatewayImpl(
        backendService: Get.find<BackendServiceImpl>(),
      ),
      permanent: true,
    );
  }

  /// Example: Send notification to specific user
  static Future<void> sendNotificationToUserExample() async {
    try {
      final apiGateway = Get.find<BackendLayerInterface>();
      
      final request = SendNotificationToUserRequest(
        userId: 'user123',
        title: 'New Task Assigned',
        body: 'You have been assigned a new task: Complete project review',
        data: {
          'taskId': 'task456',
          'workspaceId': 'workspace789',
          'type': 'task_assignment',
        },
        clickAction: 'OPEN_TASK',
      );

      final response = await apiGateway.sendNotificationToUser(request);
      
      if (response.success) {
        print('Notification sent successfully: ${response.data}');
      } else {
        print('Failed to send notification: ${response.error}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  /// Example: Send notification to workspace members
  static Future<void> sendNotificationToWorkspaceExample() async {
    try {
      final apiGateway = Get.find<BackendLayerInterface>();
      
      final request = SendNotificationToWorkspaceRequest(
        workspaceId: 'workspace789',
        title: 'Team Update',
        body: 'New project milestone has been reached!',
        data: {
          'projectId': 'project123',
          'milestone': 'Phase 1 Complete',
          'type': 'team_update',
        },
        clickAction: 'OPEN_PROJECT',
      );

      final response = await apiGateway.sendNotificationToWorkspace(request);
      
      if (response.success) {
        print('Workspace notification sent successfully');
        print('Results: ${response.data}');
      } else {
        print('Failed to send workspace notification: ${response.error}');
      }
    } catch (e) {
      print('Error sending workspace notification: $e');
    }
  }

  /// Example: Direct notification service usage
  static Future<void> directNotificationServiceExample() async {
    try {
      final notificationService = Get.find<NotificationServiceImpl>();
      
      // Send notification to specific user
      final success = await notificationService.sendNotificationToUserID(
        userId: 'user123',
        title: 'Direct Notification',
        body: 'This is a direct notification from the service',
        data: {
          'source': 'direct_service',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (success) {
        print('Direct notification sent successfully');
      } else {
        print('Failed to send direct notification');
      }

      // Subscribe user to topic
      await notificationService.subscribeUserToTopic('user123', 'workspace_updates');
      print('User subscribed to workspace_updates topic');

      // Send notification to topic
      await notificationService.sendNotificationToTopic(
        topic: 'workspace_updates',
        title: 'Topic Notification',
        body: 'This is a notification sent to all subscribers',
        data: {
          'topic': 'workspace_updates',
          'type': 'broadcast',
        },
      );
      print('Topic notification sent');

    } catch (e) {
      print('Error in direct notification service example: $e');
    }
  }

  /// Example: Task-related notifications
  static Future<void> taskNotificationExamples() async {
    try {
      final apiGateway = Get.find<BackendLayerInterface>();
      
      // Task assignment notification
      await apiGateway.sendNotificationToUser(
        SendNotificationToUserRequest(
          userId: 'user123',
          title: 'New Task Assignment',
          body: 'You have been assigned: "Review project documentation"',
          data: {
            'taskId': 'task789',
            'priority': 'high',
            'deadline': '2024-01-15',
            'type': 'task_assignment',
          },
        ),
      );

      // Task deadline reminder
      await apiGateway.sendNotificationToUser(
        SendNotificationToUserRequest(
          userId: 'user123',
          title: 'Task Deadline Reminder',
          body: 'Task "Review project documentation" is due in 2 hours',
          data: {
            'taskId': 'task789',
            'type': 'deadline_reminder',
            'timeRemaining': '2 hours',
          },
        ),
      );

      // Task completion notification
      await apiGateway.sendNotificationToUser(
        SendNotificationToUserRequest(
          userId: 'user123',
          title: 'Task Completed',
          body: 'Great job! You completed "Review project documentation"',
          data: {
            'taskId': 'task789',
            'type': 'task_completion',
            'completedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      print('Task notifications sent successfully');
    } catch (e) {
      print('Error sending task notifications: $e');
    }
  }

  /// Example: Workspace-related notifications
  static Future<void> workspaceNotificationExamples() async {
    try {
      final apiGateway = Get.find<BackendLayerInterface>();
      
      // New member joined
      await apiGateway.sendNotificationToWorkspace(
        SendNotificationToWorkspaceRequest(
          workspaceId: 'workspace789',
          title: 'New Team Member',
          body: 'John Doe has joined the workspace',
          data: {
            'newMemberId': 'user456',
            'newMemberName': 'John Doe',
            'type': 'member_joined',
          },
        ),
      );

      // Project milestone reached
      await apiGateway.sendNotificationToWorkspace(
        SendNotificationToWorkspaceRequest(
          workspaceId: 'workspace789',
          title: 'Project Milestone',
          body: 'Project Alpha has reached 75% completion!',
          data: {
            'projectId': 'project123',
            'milestone': '75% Complete',
            'type': 'project_milestone',
          },
        ),
      );

      // Daily report reminder
      await apiGateway.sendNotificationToWorkspace(
        SendNotificationToWorkspaceRequest(
          workspaceId: 'workspace789',
          title: 'Daily Report Reminder',
          body: 'Don\'t forget to submit your daily report',
          data: {
            'type': 'daily_report_reminder',
            'dueTime': '17:00',
          },
        ),
      );

      print('Workspace notifications sent successfully');
    } catch (e) {
      print('Error sending workspace notifications: $e');
    }
  }
}
