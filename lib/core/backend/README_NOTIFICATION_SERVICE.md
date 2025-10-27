# 🔔 Notification Service Layer

## 📋 Overview

The Notification Service Layer is part of the `core/backend` architecture and is responsible for handling push notifications through Firebase Cloud Messaging (FCM). It provides a clean interface for sending notifications to users, workspaces, and topics.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Notification Service Layer                   │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Interface     │    │   Implementation│    │   Models    │ │
│  │                 │    │                 │    │             │ │
│  │ • sendToUser    │    │ • Firebase      │    │ • Request   │ │
│  │ • sendToWorkspace│    │   Messaging    │    │ • Response  │ │
│  │ • sendToTopic   │    │ • Token Mgmt    │    │ • Notification│ │
│  │ • manageTokens  │    │ • Error Handling│    │             │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Backend Service Layer                       │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Business      │    │   Validation    │    │   Event     │ │
│  │   Logic         │    │   & Processing  │    │   Handling  │ │
│  │                 │    │                 │    │             │ │
│  │ • Permission    │    │ • Data          │    │ • Task      │ │
│  │   Checks        │    │   Validation    │    │   Events    │ │
│  │ • User          │    │ • Request       │    │ • Workspace │ │
│  │   Management    │    │   Processing    │    │   Events    │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API Gateway Layer                           │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Request       │    │   Response      │    │   Error     │ │
│  │   Handling      │    │   Formatting    │    │   Handling  │ │
│  │                 │    │                 │    │             │ │
│  │ • Validation    │    │ • Success       │    │ • Try-Catch │ │
│  │ • Routing       │    │   Response      │    │ • Error     │ │
│  │ • Authentication│    │ • Error         │    │   Messages  │ │
│  │                 │    │   Response      │    │ • Logging   │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 File Structure

```
lib/core/backend/
├── notification_service.dart           # Main notification service
├── notification_service_example.dart   # Usage examples
├── README_NOTIFICATION_SERVICE.md     # This documentation
├── api_gateway.dart                   # API Gateway with notification endpoints
├── api_gateway_impl.dart              # API Gateway implementation
├── backend_service.dart                # Backend service with notification logic
└── external_services_manager.dart     # External services integration
```

## 🚀 Quick Start

### 1. Setup Dependencies

```dart
import 'package:todolist/core/backend/notification_service_example.dart';

void main() {
  // Setup all dependencies
  NotificationServiceExample.setupDependencies();
  
  runApp(MyApp());
}
```

### 2. Send Notification to User

```dart
// Via API Gateway (Recommended)
final apiGateway = Get.find<BackendLayerInterface>();

final request = SendNotificationToUserRequest(
  userId: 'user123',
  title: 'New Task Assigned',
  body: 'You have been assigned a new task',
  data: {
    'taskId': 'task456',
    'type': 'task_assignment',
  },
);

final response = await apiGateway.sendNotificationToUser(request);
if (response.success) {
  print('Notification sent successfully');
}
```

### 3. Send Notification to Workspace

```dart
final request = SendNotificationToWorkspaceRequest(
  workspaceId: 'workspace789',
  title: 'Team Update',
  body: 'New project milestone reached!',
  data: {
    'projectId': 'project123',
    'type': 'team_update',
  },
);

final response = await apiGateway.sendNotificationToWorkspace(request);
if (response.success) {
  print('Workspace notification sent to ${response.data?.length} members');
}
```

## 🔧 API Reference

### NotificationServiceInterface

#### Methods

##### `sendNotificationToUserID`
```dart
Future<bool> sendNotificationToUserID({
  required String userId,
  required String title,
  required String body,
  Map<String, String>? data,
});
```

**Parameters:**
- `userId`: Target user ID
- `title`: Notification title
- `body`: Notification body text
- `data`: Additional data payload

**Returns:** `bool` - Success status

##### `sendNotificationToUsers`
```dart
Future<Map<String, bool>> sendNotificationToUsers({
  required List<String> userIds,
  required String title,
  required String body,
  Map<String, String>? data,
});
```

**Parameters:**
- `userIds`: List of target user IDs
- `title`: Notification title
- `body`: Notification body text
- `data`: Additional data payload

**Returns:** `Map<String, bool>` - Results per user ID

##### `sendNotificationToWorkspace`
```dart
Future<Map<String, bool>> sendNotificationToWorkspace({
  required String workspaceId,
  required String title,
  required String body,
  Map<String, String>? data,
});
```

**Parameters:**
- `workspaceId`: Target workspace ID
- `title`: Notification title
- `body`: Notification body text
- `data`: Additional data payload

**Returns:** `Map<String, bool>` - Results per member ID

##### `sendNotificationToTopic`
```dart
Future<bool> sendNotificationToTopic({
  required String topic,
  required String title,
  required String body,
  Map<String, String>? data,
});
```

**Parameters:**
- `topic`: Target topic name
- `title`: Notification title
- `body`: Notification body text
- `data`: Additional data payload

**Returns:** `bool` - Success status

### API Gateway Endpoints

#### `sendNotificationToUser`
```dart
Future<ApiResponse<bool>> sendNotificationToUser(SendNotificationToUserRequest request);
```

#### `sendNotificationToWorkspace`
```dart
Future<ApiResponse<Map<String, bool>>> sendNotificationToWorkspace(SendNotificationToWorkspaceRequest request);
```

## 📱 Usage Examples

### Task-Related Notifications

```dart
// Task assignment
await apiGateway.sendNotificationToUser(
  SendNotificationToUserRequest(
    userId: 'user123',
    title: 'New Task Assignment',
    body: 'You have been assigned: "Review project documentation"',
    data: {
      'taskId': 'task789',
      'priority': 'high',
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
    },
  ),
);
```

### Workspace-Related Notifications

```dart
// New member joined
await apiGateway.sendNotificationToWorkspace(
  SendNotificationToWorkspaceRequest(
    workspaceId: 'workspace789',
    title: 'New Team Member',
    body: 'John Doe has joined the workspace',
    data: {
      'newMemberId': 'user456',
      'type': 'member_joined',
    },
  ),
);

// Project milestone
await apiGateway.sendNotificationToWorkspace(
  SendNotificationToWorkspaceRequest(
    workspaceId: 'workspace789',
    title: 'Project Milestone',
    body: 'Project Alpha has reached 75% completion!',
    data: {
      'projectId': 'project123',
      'type': 'project_milestone',
    },
  ),
);
```

### Topic-Based Notifications

```dart
final notificationService = Get.find<NotificationServiceImpl>();

// Subscribe to topic
await notificationService.subscribeUserToTopic('user123', 'workspace_updates');

// Send to topic
await notificationService.sendNotificationToTopic(
  topic: 'workspace_updates',
  title: 'Workspace Update',
  body: 'New features have been added to your workspace',
  data: {
    'type': 'feature_update',
    'version': '1.2.0',
  },
);
```

## 🔐 Security & Permissions

### Permission Checks
The notification service integrates with the backend service layer to perform permission checks:

- **User Notifications**: Requires appropriate permissions to send notifications to specific users
- **Workspace Notifications**: Requires workspace membership and appropriate permissions
- **Topic Notifications**: Requires topic subscription permissions

### Data Validation
All notification requests are validated through the backend service layer:

- **Required Fields**: `userId`, `title`, `body` are mandatory
- **Data Sanitization**: All data payloads are sanitized and validated
- **Size Limits**: Notification payloads have size limits to prevent abuse

## 🚨 Error Handling

### Common Error Scenarios

1. **Invalid User ID**: User not found or doesn't exist
2. **Invalid Workspace ID**: Workspace not found or user not a member
3. **FCM Token Missing**: User hasn't registered for notifications
4. **Permission Denied**: Insufficient permissions to send notification
5. **Network Issues**: Firebase messaging service unavailable

### Error Response Format

```dart
ApiResponse.error('Failed to send notification: User not found')
```

### Retry Logic
The service includes built-in retry logic for transient failures:

- **FCM Token Refresh**: Automatically retries with refreshed tokens
- **Network Retries**: Retries failed network requests up to 3 times
- **Exponential Backoff**: Uses exponential backoff for retry attempts

## 🧪 Testing

### Unit Tests
```dart
// Test notification sending
test('should send notification to user successfully', () async {
  final notificationService = NotificationServiceImpl();
  final result = await notificationService.sendNotificationToUserID(
    userId: 'test_user',
    title: 'Test Title',
    body: 'Test Body',
  );
  expect(result, true);
});
```

### Integration Tests
```dart
// Test API Gateway integration
test('should send notification via API Gateway', () async {
  final apiGateway = ApiGatewayImpl(backendService: mockBackendService);
  final request = SendNotificationToUserRequest(
    userId: 'test_user',
    title: 'Test Title',
    body: 'Test Body',
  );
  
  final response = await apiGateway.sendNotificationToUser(request);
  expect(response.success, true);
});
```

## 📊 Monitoring & Analytics

### Logging
The service includes comprehensive logging:

- **Success Logs**: Successful notification sends
- **Error Logs**: Failed notification attempts with error details
- **Performance Logs**: Notification send times and performance metrics

### Metrics
Track important metrics:

- **Notification Success Rate**: Percentage of successful sends
- **Average Send Time**: Time taken to send notifications
- **Error Rates**: Frequency of different error types
- **User Engagement**: Notification open and click rates

## 🔄 Future Enhancements

### Planned Features
1. **Rich Notifications**: Support for images, actions, and custom layouts
2. **Scheduled Notifications**: Send notifications at specific times
3. **Notification Templates**: Predefined notification templates
4. **A/B Testing**: Test different notification content
5. **Analytics Dashboard**: Real-time notification analytics

### Server-Side Implementation
The current implementation is client-side with limitations. Future versions will include:

- **Firebase Admin SDK**: Server-side notification sending
- **Batch Notifications**: Send to multiple users efficiently
- **Notification Queuing**: Queue notifications for reliable delivery
- **Advanced Targeting**: Complex user segmentation and targeting

## 📚 Related Documentation

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Backend Service Architecture](../README.md)
- [API Gateway Documentation](api_gateway.dart)
- [External Services Manager](external_services_manager.dart)

---

**Note**: This notification service is designed to work within the existing backend architecture and follows the project's coding standards and patterns. For production use, consider implementing server-side notification sending using Firebase Admin SDK for better reliability and performance.
