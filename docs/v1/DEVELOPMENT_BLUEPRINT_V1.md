# 📋 Development Blueprint V1 - Multi-Workspace Todo List Application

## 🎯 Project Overview

**Application Name**: Multi-Workspace Todo List & Daily Reports  
**Platform**: Flutter (Cross-platform Mobile)  
**Architecture**: Serverless (Firebase + OneDrive)  
**Target Users**: Personal users + Companies with multiple departments and employees  

## 🏗️ System Architecture V1 - Serverless Edge Hybrid

### Core Components
```
┌─────────────────────────────────────────────────────────────────┐
│                    Flutter Device (Mobile)                     │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Frontend      │◄──►│   Backend       │◄──►│   Local     │ │
│  │   (UI Layer)    │    │   Layer         │    │   Storage   │ │
│  │                 │    │   (API Gateway) │    │   (Hive)    │ │
│  │ • Multi-Workspace│    │ • API Interface │    │ • Cache     │ │
│  │ • Task Management│    │ • Request       │    │ • Offline   │ │
│  │ • Daily Reports │    │   Routing       │    │ • Sync Queue│ │
│  │ • Notifications │    │ • Response      │    │ • Backup    │ │
│  │ • UI Components │    │   Handling      │    │   History   │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Backend Service Layer                       │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Business      │    │   Data          │    │   External  │ │
│  │   Logic         │    │   Processing    │    │   Services  │ │
│  │   Engine        │    │   Engine        │    │   Manager   │ │
│  │                 │    │                 │    │             │ │
│  │ • Task Logic    │    │ • Data          │    │ • Firebase  │ │
│  │ • User Logic    │    │   Validation    │    │   Connector │ │
│  │ • Workspace     │    │ • Data          │    │ • OneDrive  │ │
│  │   Logic         │    │   Transformation│    │   Connector │ │
│  │ • Permission    │    │ • Event         │    │ • Service   │ │
│  │   Logic         │    │   Processing    │    │   Mediator  │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Firebase Cloud Brain                        │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Auth          │    │   Realtime DB   │    │   Cloud     │ │
│  │   Service       │    │   (Sync Layer)  │    │   Messaging │ │
│  │                 │    │                 │    │             │ │
│  │ • User Auth     │    │ • Data Sync     │    │ • Push      │ │
│  │ • Workspace     │    │ • Event Stream  │    │   Notifications│ │
│  │   Management    │    │ • Conflict      │    │ • Real-time │ │
│  │ • Permission    │    │   Resolution    │    │   Updates   │ │
│  │   Validation    │    │ • Multi-device  │    │ • Event     │ │
│  │                 │    │   Coordination  │    │   Broadcasting│ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                ▲
                                │
                                │
                    Backend Service Layer
                    (Service Mediator)
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OneDrive Backup Layer                       │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Account       │    │   Backup        │    │   Version   │ │
│  │   Holder        │    │   Management    │    │   Control   │ │
│  │   Access        │    │                 │    │             │ │
│  │                 │    │ • JSON Export   │    │ • Historical│ │
│  │ • Login Required│    │ • Scheduled     │    │   Versions  │ │
│  │ • Admin Only    │    │   Backup        │    │ • Restore   │ │
│  │ • API Access    │    │ • Data Archive  │    │   Function  │ │
│  │                 │    │ • Workspace     │    │ • Rollback  │ │
│  │                 │    │   Isolation     │    │   Support   │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow - Serverless Edge Hybrid with Backend Service Layer as Mediator
1. **User Actions** → Frontend (Flutter UI) → Backend Layer (API Gateway)
2. **API Routing** → Backend Layer routes requests → Backend Service Layer
3. **Business Logic** → Backend Service Layer processes → Updates Local Storage
4. **Firebase Sync** → Backend Service Layer → Firebase Cloud Brain (Auth, Realtime DB, FCM)
5. **OneDrive Backup** → Backend Service Layer → OneDrive Backup Layer (Account Holder/Admin only)
6. **Cross-Service Communication** → Backend Service Layer mediates between Firebase & OneDrive
7. **Data Sync** → Backend Service Layer syncs with Firebase Realtime Database
8. **Event Broadcasting** → Firebase Cloud Messaging → Other devices
9. **Backup Operations** → Backend Service Layer manages OneDrive backup/restore operations
10. **Service Coordination** → Backend Service Layer coordinates Firebase & OneDrive operations
11. **Offline Mode** → Backend Service Layer continues processing → Local Storage
12. **Conflict Resolution** → Firebase handles multi-device conflicts
13. **Workspace Switching** → Backend Service Layer filters data → Frontend updates UI

## 🏗️ Backend Service Layer Architecture

### Layer Separation Benefits
- **Modularity**: Tách biệt business logic khỏi API interface
- **Scalability**: Dễ dàng migrate lên server thật trong tương lai
- **Maintainability**: Dễ dàng maintain và test từng layer riêng biệt
- **Flexibility**: Có thể thay đổi implementation mà không ảnh hưởng đến Frontend
- **Service Mediation**: Backend Service Layer làm trung gian giữa Firebase và OneDrive
- **Centralized Control**: Tất cả tương tác giữa các external services được quản lý tập trung
- **Error Handling**: Xử lý lỗi và retry logic tập trung tại Backend Service Layer
- **Data Consistency**: Đảm bảo tính nhất quán dữ liệu giữa Firebase và OneDrive

### Backend Layer (API Gateway)
```dart
// API Gateway Interface
abstract class BackendLayerInterface {
  // Task Management
  Future<ApiResponse<Task>> createTask(CreateTaskRequest request);
  Future<ApiResponse<List<Task>>> getTasks(GetTasksRequest request);
  Future<ApiResponse<Task>> updateTask(UpdateTaskRequest request);
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
  Future<ApiResponse<Report>> generateReport(GenerateReportRequest request);
  Future<ApiResponse<List<Report>>> getReports(GetReportsRequest request);
}
```

### Backend Service Layer (Business Logic)
```dart
// Business Logic Engine
abstract class BackendServiceInterface {
  // Task Business Logic
  Future<Task> processCreateTask(CreateTaskRequest request);
  Future<List<Task>> processGetTasks(GetTasksRequest request);
  Future<Task> processUpdateTask(UpdateTaskRequest request);
  Future<void> processDeleteTask(DeleteTaskRequest request);
  
  // User Business Logic
  Future<User> processCreateUser(CreateUserRequest request);
  Future<List<User>> processGetUsers(GetUsersRequest request);
  Future<User> processUpdateUser(UpdateUserRequest request);
  
  // Workspace Business Logic
  Future<Workspace> processCreateWorkspace(CreateWorkspaceRequest request);
  Future<List<Workspace>> processGetWorkspaces(GetUsersRequest request);
  Future<void> processSwitchWorkspace(SwitchWorkspaceRequest request);
  
  // Permission Logic
  Future<bool> checkPermission(String userId, String permission, String workspaceId);
  Future<List<String>> getUserPermissions(String userId, String workspaceId);
  
  // Data Processing
  Future<void> processDataValidation(dynamic data);
  Future<dynamic> processDataTransformation(dynamic data);
  Future<void> processEventHandling(Event event);
}
```

### External Services Manager
```dart
// External Services Manager
abstract class ExternalServicesInterface {
  // Firebase Connector
  Future<void> connectToFirebase();
  Future<void> syncWithFirebase(dynamic data);
  Future<dynamic> getFromFirebase(String path);
  Future<void> updateFirebase(String path, dynamic data);
  Future<void> deleteFromFirebase(String path);
  
  // OneDrive Connector (Direct connection from Backend Service Layer)
  Future<void> connectToOneDrive(String userId);
  Future<void> backupToOneDrive(dynamic data, String workspaceId);
  Future<dynamic> restoreFromOneDrive(String workspaceId, String version);
  Future<List<String>> getOneDriveVersions(String workspaceId);
  Future<void> deleteOneDriveBackup(String workspaceId, String version);
  Future<bool> validateOneDriveAccess(String userId, String workspaceId);
  Future<void> scheduleOneDriveBackup(String workspaceId, String schedule);
  
  // Service Mediation (Firebase ↔ OneDrive)
  Future<void> syncFirebaseToOneDrive(String workspaceId);
  Future<void> syncOneDriveToFirebase(String workspaceId, String version);
  Future<bool> validateDataConsistency(String workspaceId);
  Future<void> resolveDataConflicts(String workspaceId);
  Future<void> coordinateBackupAndSync(String workspaceId);
  
  // API Gateway
  Future<ApiResponse<T>> makeApiCall<T>(ApiRequest request);
  Future<void> handleApiError(ApiError error);
  Future<void> retryApiCall<T>(ApiRequest request);
}
```

### Migration Strategy to Real Server
```dart
// Future Server Implementation
class ServerBackendService implements BackendServiceInterface {
  // Same interface, different implementation
  // Can be deployed to cloud server (AWS, GCP, Azure)
  // Frontend code remains unchanged
}

class ServerExternalServices implements ExternalServicesInterface {
  // Server-hosted Firebase connections
  // Server-hosted OneDrive connections (direct from server to OneDrive)
  // Better performance and reliability
  // Enhanced service mediation capabilities
  // Centralized data consistency management
  // Improved error handling and retry logic
}
```

## 📊 Data Model V1

### Firebase Database Structure
```json
{
  "users": {
    "userId": {
      "id": "userId",
      "email": "user@example.com",
      "name": "User Name",
      "profileImageUrl": "url",
      "createdAt": "timestamp",
      "lastLoginAt": "timestamp",
      "mustChangePassword": false,
      "isActive": true,
      "preferences": {
        "currentWorkspaceId": "workspaceId",
        "theme": "light|dark",
        "notifications": true
      }
    }
  },
  "workspaces": {
    "workspaceId": {
      "id": "workspaceId",
      "name": "Workspace Name",
      "type": "personal|company",
      "createdBy": "userId",
      "createdAt": "timestamp",
      "isActive": true,
      "settings": {
        "description": "Workspace description",
        "logoUrl": "url",
        "timezone": "UTC+7"
      }
    }
  },
  "workspace_members": {
    "workspaceId": {
      "userId": {
        "userId": "userId",
        "workspaceId": "workspaceId",
        "role": "account_holder|admin|member",
        "permissions": ["permission1", "permission2"],
        "assignedBy": "userId",
        "assignedAt": "timestamp",
        "isActive": true,
        "managerUserId": "userId|null" // For hierarchy
      }
    }
  },
  "workspace_data": {
    "workspaceId": {
      "projects": {
        "projectId": {
          "id": "projectId",
          "title": "Project Title",
          "description": "Project Description",
          "deadline": "2025-10-15|null",
          "status": "active|completed|closed",
          "createdBy": "userId",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
        }
      },
      "tasks": {
        "taskId": {
          "id": "taskId",
          "title": "Task Title",
          "description": "Task Description",
          "assignee": "userId",
          "assigner": "userId",
          "status": "pending|in_progress|completed|cancelled",
          "priority": "low|medium|high|urgent",
          "taskType": "daily|weekly|monthly|project",
          "projectId": "projectId|null",
          "deadline": "2025-10-15|null",
          "hasDeadline": "true|false",
          "recurring": {
            "isRecurring": "true|false",
            "frequency": "daily|weekly|monthly",
            "interval": "1|2|3...",
            "endDate": "2025-12-31|null"
          },
          "parentTaskId": "taskId|null",
          "stoppedByProjectClose": "true|false|undefined",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
        }
      },
      "reports": {
        "userId": {
          "date": {
            "completedTasks": ["taskId1", "taskId2"],
            "pendingTasks": ["taskId3", "taskId4"],
            "notes": "Daily report notes",
            "submittedAt": "timestamp"
          }
        }
      }
    }
  }
}
```

## 🏢 Workspace System

### 1. Personal Workspace
- **Type**: `personal`
- **Auto-created**: Mỗi user đăng ký sẽ tự động có 1 Personal Workspace
- **Features**: Đầy đủ tính năng todo list cá nhân
- **Data Isolation**: Hoàn toàn riêng tư, chỉ user đó có quyền truy cập

### 2. Company Workspace
- **Type**: `company`
- **Created by**: User có thể tạo Company Workspace
- **Account Holder**: Người tạo workspace trở thành Account Holder
- **Features**: Đầy đủ tính năng quản lý team, project, task
- **Multi-user**: Có thể invite nhiều user khác

### 3. Workspace Switching
- **Current Workspace**: User có thể chuyển đổi workspace trong Settings
- **Data Context**: Tất cả data (tasks, projects, reports) được filter theo workspace hiện tại
- **State Management**: Local state lưu `currentWorkspaceId`

## 👥 User Roles & Permissions V1

### 1. Account Holder
- **Scope**: Company Workspace only
- **Permissions**: All permissions + can assign admins
- **Responsibilities**:
  - Create and manage company workspace
  - Assign admin roles to other users
  - Full access to all workspace data
  - Invite/remove users
  - Configure workspace settings

### 2. Admin
- **Scope**: Company Workspace only
- **Permissions**: Assigned by Account Holder
- **Responsibilities**:
  - Manage users and permissions
  - Create/assign tasks and projects
  - View all workspace data
  - Generate reports and analytics

### 3. Member
- **Scope**: Any workspace
- **Permissions**: Assigned by Admin/Account Holder
- **Responsibilities**:
  - Work on assigned tasks
  - Create personal tasks (if permission granted)
  - View own data + team data (if manager)

### 4. Personal User
- **Scope**: Personal Workspace only
- **Permissions**: Full access to own workspace
- **Responsibilities**:
  - Manage personal tasks and projects
  - Create company workspace (becomes Account Holder)
  - Join other company workspaces (becomes Member)

## 🔐 Permission System V1

### Permission-Based Access Control
Thay vì role-based, sử dụng permission-based system:

```dart
// Permission Constants
class WorkspacePermissions {
  // Workspace Management
  static const String manageWorkspace = 'manage_workspace';
  static const String manageUsers = 'manage_users';
  static const String assignPermissions = 'assign_permissions';
  
  // Task Management
  static const String createTasks = 'create_tasks';
  static const String assignTasks = 'assign_tasks';
  static const String updateTaskStatus = 'update_task_status';
  static const String deleteTasks = 'delete_tasks';
  static const String setTaskPriority = 'set_task_priority';
  static const String setTaskDeadline = 'set_task_deadline';
  
  // Project Management
  static const String createProjects = 'create_projects';
  static const String manageProjects = 'manage_projects';
  static const String assignProjects = 'assign_projects';
  
  // Data Access
  static const String viewAllData = 'view_all_data';
  static const String viewTeamData = 'view_team_data';
  static const String viewPersonalData = 'view_personal_data';
  
  // Reports & Analytics
  static const String generateReports = 'generate_reports';
  static const String viewAnalytics = 'view_analytics';
  
  // Invitations
  static const String inviteUsers = 'invite_users';
  static const String removeUsers = 'remove_users';
}
```

### Default Permission Sets
```dart
class DefaultPermissionSets {
  // Account Holder permissions
  static const List<String> accountHolderPermissions = [
    WorkspacePermissions.manageWorkspace,
    WorkspacePermissions.manageUsers,
    WorkspacePermissions.assignPermissions,
    WorkspacePermissions.createTasks,
    WorkspacePermissions.assignTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.assignProjects,
    WorkspacePermissions.viewAllData,
    WorkspacePermissions.viewTeamData,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
    WorkspacePermissions.viewAnalytics,
    WorkspacePermissions.inviteUsers,
    WorkspacePermissions.removeUsers,
  ];
  
  // Admin permissions (customizable)
  static const List<String> defaultAdminPermissions = [
    WorkspacePermissions.manageUsers,
    WorkspacePermissions.createTasks,
    WorkspacePermissions.assignTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.assignProjects,
    WorkspacePermissions.viewAllData,
    WorkspacePermissions.viewTeamData,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
    WorkspacePermissions.viewAnalytics,
    WorkspacePermissions.inviteUsers,
  ];
  
  // Member permissions (customizable)
  static const List<String> defaultMemberPermissions = [
    WorkspacePermissions.createTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.viewPersonalData,
  ];
  
  // Personal user permissions
  static const List<String> personalUserPermissions = [
    WorkspacePermissions.createTasks,
    WorkspacePermissions.updateTaskStatus,
    WorkspacePermissions.deleteTasks,
    WorkspacePermissions.setTaskPriority,
    WorkspacePermissions.setTaskDeadline,
    WorkspacePermissions.createProjects,
    WorkspacePermissions.manageProjects,
    WorkspacePermissions.viewPersonalData,
    WorkspacePermissions.generateReports,
  ];
}
```

## 🔄 User Hierarchy System

### Manager-Employee Relationship
```dart
class UserHierarchy {
  final String userId;
  final String? managerUserId; // null for top-level users
  final List<String> directReports; // users under this user
  final int hierarchyLevel; // 0 = top level, 1 = second level, etc.
}
```

### Data Access Rules
1. **Personal Data**: User chỉ xem được data của chính mình
2. **Team Data**: Nếu user có `managerUserId`, họ có thể xem data của tất cả cấp dưới
3. **Permission Override**: Admin có thể override hierarchy rules
4. **Workspace Isolation**: Data chỉ accessible trong workspace hiện tại

## 🚀 Development Phases V1

### Phase 0: Discovery & Setup (2 weeks) ✅ COMPLETED
**Week 1:**
- [x] Project setup and architecture design
- [x] Firebase project configuration
- [x] OneDrive API setup
- [x] UI/UX wireframes and mockups
- [x] Development environment setup

**Week 2:**
- [x] Flutter project initialization
- [x] Firebase integration setup
- [x] Basic authentication flow
- [x] CI/CD pipeline setup
- [x] Code structure and architecture patterns

## 📋 Detailed Development Phases

### [Phase 1: Multi-Workspace Authentication & User Management](phases/PHASE_1_MULTI_WORKSPACE_AUTH.md)
- **Duration**: 4 weeks (Sprint 1-4)
- **Story Points**: 83 points
- **Focus**: User registration, workspace creation, permission system, user invitation

### [Phase 2: Core Task Management with Workspace Context](phases/PHASE_2_TASK_MANAGEMENT.md)
- **Duration**: 2 weeks (Sprint 5-6)
- **Story Points**: 41 points
- **Focus**: Task management, project management, recurring tasks

### [Phase 3: Advanced Features & Notifications](phases/PHASE_3_ADVANCED_FEATURES.md)
- **Duration**: 3 weeks (Sprint 7-9)
- **Story Points**: 64 points
- **Focus**: Real-time sync, offline support, reports, analytics, push notifications

### [Phase 4: Device-hosted Backend & OneDrive Backup](phases/PHASE_4_BACKEND_ARCHITECTURE.md)
- **Duration**: 5 weeks (Sprint 10-14)
- **Story Points**: 115 points
- **Focus**: Layered backend architecture, OneDrive integration, service mediation

### [Phase 5: Testing & Quality Assurance](phases/PHASE_5_TESTING_QA.md)
- **Duration**: 2 weeks (Sprint 15-16)
- **Story Points**: 36 points
- **Focus**: Testing, performance optimization, UAT, release preparation

## 📊 Overall Project Metrics
- **Total Duration**: 16 weeks
- **Total Story Points**: 339 points
- **Team Size**: 2 developers
- **Total Sprints**: 16 sprints

## 🏗️ Architecture Evolution
1. **Phase 1-2**: Core functionality with basic architecture
2. **Phase 3**: Advanced features with real-time capabilities
3. **Phase 4**: Layered backend architecture implementation
4. **Phase 5**: Optimization and production readiness

## 🎯 Success Criteria
- All phases completed within timeline
- 80%+ test coverage across all phases
- Performance metrics met for each phase
- User acceptance criteria satisfied
- Security requirements fulfilled

## 📚 Phase Documentation Structure
Each phase file contains:
- Phase overview and goals
- Detailed sprint breakdown
- User stories and acceptance criteria
- Technical requirements
- Success metrics
- Risk mitigation strategies
- Documentation requirements

## 🔄 Phase Dependencies
- **Phase 1** → **Phase 2**: Authentication system required for task management
- **Phase 2** → **Phase 3**: Task management required for reports and analytics
- **Phase 3** → **Phase 4**: Real-time sync required for backend architecture
- **Phase 4** → **Phase 5**: Backend architecture required for comprehensive testing

## 🛠️ Technical Specifications V1 - Serverless Edge Hybrid

### Updated Technical Stack
- **Framework**: Flutter 3.35.5 (Latest stable)
- **Frontend**: Flutter UI Layer (GetX Controllers, Widgets)
- **Backend Layer**: Flutter Device-hosted API Gateway (Request/Response Handling)
- **Backend Service Layer**: Flutter Device-hosted Business Logic (Data Processing, Validation)
- **External Services Manager**: Flutter Device-hosted Service Connectors (Firebase, OneDrive)
- **State Management**: GetX (Controllers, Dependency Injection, Route Management)
- **Local Storage**: Hive (Cache, Offline Data, Sync Queue)
- **Cloud Sync**: Firebase (Auth, Realtime DB, FCM, Analytics)
- **Backup**: flutter_onedrive (Account Holder/Admin only)
- **Architecture**: Clean Architecture với Serverless Edge Hybrid pattern + Layered Backend
- **Workspace Management**: Local state + Firebase filtering + Layered backend processing
- **Testing**: Unit, Widget, Integration tests
- **CI/CD**: GitLab CI với automated testing và building

### New Dependencies for Serverless Edge Hybrid (Flutter 3.35.5 Compatible)
```yaml
dependencies:
  # Existing dependencies...
  
  # New for V1 - Serverless Edge Hybrid
  flutter_bloc: ^8.1.4  # For workspace state management
  equatable: ^2.0.5      # For state comparison
  uuid: ^4.2.1          # For workspace ID generation
  
  # Device-hosted Backend
  shelf: ^1.4.1         # HTTP server for device-hosted API
  shelf_router: ^1.1.4  # Router for device-hosted API
  shelf_cors_headers: ^0.1.5  # CORS support
  shelf_static: ^1.1.1  # Static file serving
  
  # Local API & Business Logic
  dio: ^5.4.0           # HTTP client for local API calls
  json_annotation: ^4.8.1  # JSON serialization
  json_serializable: ^6.7.1  # JSON code generation
  
  # Enhanced Local Storage
  hive_flutter: ^1.1.0  # Local database
  hive_generator: ^2.0.1  # Hive code generation
  path_provider: ^2.1.1  # File system access
  
  # OneDrive Integration (Updated)
  flutter_onedrive: ^1.8.1  # OneDrive integration for Flutter (Latest version)
  # Note: flutter_onedrive includes its own OAuth2 implementation
  
  # Event Handling & Sync
  event_bus: ^2.0.0     # Local event bus
  rxdart: ^0.27.7       # Reactive programming
  stream_transform: ^2.0.1  # Stream transformations
  
  # Additional packages for Flutter 3.35.5 compatibility
  # Note: flutter_onedrive already includes: flutter_secure_storage, http, oauth2, oauth_webauth, path, path_provider
  crypto: ^3.0.3        # Cryptographic functions
  intl: ^0.19.0         # Internationalization
  shared_preferences: ^2.2.2  # Shared preferences
  connectivity_plus: ^5.0.2  # Network connectivity
  permission_handler: ^11.1.0  # Permission management
```

## 🔐 Security Implementation V1

### Firebase Security Rules for Multi-Workspace
```javascript
{
  "rules": {
    "users": {
      "$userId": {
        ".read": "auth.uid == $userId",
        ".write": "auth.uid == $userId"
      }
    },
    "workspaces": {
      "$workspaceId": {
        ".read": "root.child('workspace_members').child($workspaceId).child(auth.uid).exists()",
        ".write": "root.child('workspace_members').child($workspaceId).child(auth.uid).child('permissions').hasChild('manage_workspace')"
      }
    },
    "workspace_members": {
      "$workspaceId": {
        ".read": "root.child('workspace_members').child($workspaceId).child(auth.uid).exists()",
        ".write": "root.child('workspace_members').child($workspaceId).child(auth.uid).child('permissions').hasChild('manage_users')"
      }
    },
    "workspace_data": {
      "$workspaceId": {
        ".read": "root.child('workspace_members').child($workspaceId).child(auth.uid).exists()",
        ".write": "root.child('workspace_members').child($workspaceId).child(auth.uid).exists()"
      }
    }
  }
}
```

## 🎨 UI/UX Design V1

### Workspace Switching Interface
```
┌──────────────────────────────────────────────┐
│ [Profile] [Settings] [Workspace: Personal ▼] │
│                                              │
│ Personal Workspace                           │
│ ┌──────────────────────────────────────────┐ │
│ │ My Tasks (12)                            │ │
│ │ My Projects (3)                          │ │
│ │ My Reports                               │ │
│ └──────────────────────────────────────────┘ │
│                                              │
│ [Create Company Workspace]                   │
│ [Join Company Workspace]                     │
└──────────────────────────────────────────────┘
```

### Company Workspace Interface
```
┌──────────────────────────────────────────────┐
│ [Profile] [Settings] [Workspace: ABC Corp ▼] │
│                                              │
│ ABC Corp Workspace                           │
│ ┌──────────────────────────────────────────┐ │
│ │ Team Tasks (45)                          │ │
│ │ Projects (8)                             │ │
│ │ Team Reports                             │ │
│ │ [Manage Users] [Analytics]               │ │
│ └──────────────────────────────────────────┘ │
│                                              │
│ [Switch to Personal Workspace]               │
└──────────────────────────────────────────────┘
```

### Permission Management Interface
```
┌──────────────────────────────────────────────┐
│ User: John Doe                               │
│ Role: Member                                 │
│ Manager: Jane Smith                          │
│                                              │
│ Permissions:                                 │
│ ☑ Create Tasks                               │
│ ☑ Update Task Status                         │
│ ☐ Assign Tasks                               │
│ ☐ Delete Tasks                               │
│ ☐ Create Projects                            │
│ ☐ Manage Users                               │
│                                              │
│ [Save Changes] [Reset to Default]            │
└──────────────────────────────────────────────┘
```

## 📱 Key Features Implementation V1 - Serverless Edge Hybrid

### 1. Multi-Workspace Authentication Flow
- Personal workspace auto-creation
- Company workspace creation
- Workspace switching
- User invitation with default passwords
- Permission-based access control
- Device-hosted authentication processing

### 2. Task Management with Workspace Context
- Task creation within specific workspace
- Project management per workspace
- Task assignment with permission checks
- Recurring task functionality
- Cross-workspace task filtering
- Local business logic processing

### 3. User Management & Hierarchy
- Manager-employee relationships
- Permission customization
- User invitation system
- Role assignment by Account Holder
- Team data access rules
- Device-hosted user management API

### 4. Daily Reports & Analytics
- Workspace-specific reports
- Cross-workspace analytics
- Team performance tracking
- Personal vs team reports
- Export functionality per workspace
- Local report generation

### 5. Data Management & Backup (Serverless Edge Hybrid)
- Workspace-specific data isolation
- Real-time synchronization via Firebase
- Offline support with device-hosted backend
- OneDrive backup per workspace (Account Holder/Admin only) - Mediated by Backend Service Layer
- Data export functionality
- Version control and restore capabilities
- Device-hosted backup management
- **Service Mediation**: Backend Service Layer coordinates Firebase & OneDrive operations
- **Data Consistency**: Ensures consistency between Firebase and OneDrive data
- **Conflict Resolution**: Handles conflicts between Firebase and OneDrive data

### 6. Layered Backend Architecture Features
- **Backend Layer (API Gateway)**: Local HTTP server (Shelf), Request/Response handling
- **Backend Service Layer**: Business logic processing on device, Data validation & transformation
- **External Services Manager**: Firebase & OneDrive connection management
- **Service Mediation**: Coordinates interactions between Firebase and OneDrive
- **Local API endpoints**: RESTful API interface for Frontend
- **Offline-first architecture**: Local processing with sync capabilities
- **Event-driven processing**: Local event handling and processing
- **Conflict resolution**: Multi-device conflict handling
- **Data consistency management**: Ensures consistency across all external services
- **Migration-ready**: Easy transition to real server deployment

## 🧪 Testing Strategy V1 - Serverless Edge Hybrid

### Unit Testing
- Workspace management logic
- Permission checking functions
- User hierarchy validation
- Data filtering by workspace
- State management testing
- **Backend Layer (API Gateway)**: Request/Response handling, API routing
- **Backend Service Layer**: Business logic, Data validation, Event processing
- **External Services Manager**: Firebase connector, OneDrive connector, API gateway
- OneDrive backup logic

### Integration Testing
- Firebase integration with workspace filtering
- flutter_onedrive integration (Account Holder/Admin)
- Multi-workspace authentication flow
- Real-time synchronization
- Cross-workspace data access
- **Backend Layer Integration**: API Gateway with Frontend communication
- **Backend Service Layer Integration**: Business logic with External Services
- **External Services Integration**: Firebase & OneDrive connector testing
- Local storage and sync queue testing
- Offline-first functionality
- **Layer Communication**: Backend Layer ↔ Backend Service Layer ↔ External Services

### UI Testing
- Workspace switching interface
- Permission management UI
- Task creation with workspace context
- Navigation between workspaces
- Responsive design testing
- flutter_onedrive backup interface (Admin only)
- Version control and restore UI

### Performance Testing
- Workspace switching performance
- Large dataset filtering
- Memory usage with multiple workspaces
- Network efficiency
- Database query performance
- **Backend Layer Performance**: API Gateway response times, Request handling
- **Backend Service Layer Performance**: Business logic processing, Data validation
- **External Services Performance**: Firebase & OneDrive connection performance
- Local API response times
- Offline mode performance
- flutter_onedrive backup/restore performance
- **Layer Communication Performance**: Inter-layer communication latency

## 📈 Success Metrics V1 - Serverless Edge Hybrid

### Technical Metrics
- Workspace switching time < 1 second
- Real-time sync latency < 500ms
- Offline functionality coverage > 95%
- Crash rate < 0.1%
- Data isolation accuracy 100%
- **Backend Layer startup time** < 1 second
- **Backend Service Layer startup time** < 2 seconds
- **External Services connection time** < 3 seconds
- Local API response time < 100ms
- **Layer communication latency** < 50ms
- flutter_onedrive backup completion time < 30 seconds
- Restore operation time < 60 seconds

### User Experience Metrics
- User onboarding completion rate > 80%
- Workspace adoption rate > 70%
- Task completion rate > 85%
- User satisfaction score > 4.5/5
- Multi-workspace usage > 60%
- Offline mode usage > 40%
- flutter_onedrive backup adoption (Admin) > 80%
- Version restore usage > 20%

## 🚀 Deployment Strategy V1 - Serverless Edge Hybrid

### Development Environment
- Firebase project for development
- OneDrive sandbox environment (flutter_onedrive)
- GitLab CI/CD pipeline
- Automated testing
- Multi-workspace testing
- Device-hosted backend testing
- Local API endpoint testing

### Staging Environment
- Production-like Firebase setup
- OneDrive test environment (flutter_onedrive)
- User acceptance testing
- Performance monitoring
- Workspace migration testing
- Device-hosted backend performance testing
- flutter_onedrive backup/restore testing

### Production Environment
- Production Firebase project
- OneDrive production integration (flutter_onedrive)
- App store deployment
- Monitoring and analytics
- Workspace data migration
- Device-hosted backend monitoring
- flutter_onedrive backup monitoring

## 📋 Risk Management V1 - Serverless Edge Hybrid

### Technical Risks
- Firebase quota limitations with multiple workspaces
- OneDrive API rate limits
- Real-time sync performance with workspace filtering
- Offline data consistency across workspaces
- Data migration complexity
- Device-hosted backend resource consumption
- Local API security vulnerabilities
- flutter_onedrive backup/restore failures
- Device storage limitations

### Mitigation Strategies
- Implement data pagination per workspace
- Add retry mechanisms for workspace operations
- Optimize database queries with workspace filtering
- Implement conflict resolution for multi-workspace
- Gradual migration strategy
- Resource monitoring for device-hosted backend
- Local API authentication and validation
- flutter_onedrive backup validation and error handling
- Storage management and cleanup policies

## 🔄 Maintenance & Updates V1 - Serverless Edge Hybrid

### Regular Maintenance
- Security updates
- Performance optimization
- Bug fixes
- Feature enhancements
- Workspace management improvements
- Device-hosted backend optimization
- flutter_onedrive integration updates
- Local API security patches

### Monitoring
- Firebase Analytics with workspace tracking
- Crash reporting
- Performance monitoring
- User feedback collection
- Workspace usage analytics
- Device-hosted backend performance
- Local API usage monitoring
- flutter_onedrive backup/restore success rates

## 📚 Documentation V1 - Serverless Edge Hybrid

### Technical Documentation
- Multi-workspace API documentation
- Database schema with workspace structure
- Security rules for multi-workspace
- Device-hosted backend API documentation
- flutter_onedrive integration guide
- OneDrive app registration guide (Microsoft Azure)
- OAuth2 authentication setup
- Deployment guide
- Migration guide from V0
- Local API endpoint documentation

### User Documentation
- Multi-workspace user manual
- Admin guide for workspace management
- Permission management guide
- flutter_onedrive backup/restore guide (Admin only)
- OneDrive connection and authentication guide
- Device-hosted backend user guide
- FAQ
- Video tutorials

---

**Total Development Time**: 14-15 weeks (increased for Serverless Edge Hybrid complexity)  
**Team Size**: 2-3 developers  
**Budget Estimate**: $20,000 - $32,000 (increased for device-hosted backend development)  
**Post-MVP Features**: Web dashboard, Advanced analytics, Multi-company support, Workspace templates, Advanced flutter_onedrive integration, OneDrive file sharing

## 🔄 Migration Strategy from V0 to V1 - Serverless Edge Hybrid

### Data Migration Plan
1. **User Data**: Migrate existing users to new structure
2. **Company Data**: Convert existing companies to workspaces
3. **Task Data**: Migrate tasks to workspace-specific structure
4. **Permission Data**: Convert role-based to permission-based
5. **Backup Data**: Migrate OneDrive backup structure
6. **Layered Backend Architecture**: Deploy Backend Layer + Backend Service Layer + External Services Manager
7. **flutter_onedrive Integration**: Setup Account Holder/Admin access
8. **API Interface Migration**: Migrate from direct service calls to layered API calls

### Rollout Strategy
1. **Phase 1**: Deploy V1 alongside V0 with layered backend architecture
2. **Phase 2**: Migrate existing users gradually to new layered backend
3. **Phase 3**: Enable flutter_onedrive backup for Account Holders/Admins
4. **Phase 4**: Full V1 deployment with all layered backend features
5. **Phase 5**: V0 deprecation
6. **Phase 6**: Future migration to real server (optional)

---

*Document created: $(date)*
*Last updated: $(date)*
*Status: Under Review*
*Version: 1.0 - Serverless Edge Hybrid*
*Architecture: Device-hosted Backend + Firebase Cloud Brain + flutter_onedrive Backup*
