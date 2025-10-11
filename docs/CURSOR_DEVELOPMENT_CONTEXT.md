# 🎯 Cursor Development Context Guide

## 📋 Overview

This document provides essential context for Cursor AI when developing features for the Multi-Workspace Todo List Application. It serves as a quick reference to understand the project's architecture, rules, and development patterns.

## 🏗️ Project Architecture

### Current Version: V1 - Serverless Edge Hybrid
- **Frontend**: Flutter UI Layer (GetX Controllers, Widgets)
- **Backend**: Flutter Device-hosted API (Business Logic, Data Processing)
- **State Management**: GetX (Controllers, Dependency Injection, Route Management)
- **Local Storage**: Hive (Cache, Offline Data, Sync Queue)
- **Cloud Sync**: Firebase (Auth, Realtime DB, FCM, Analytics)
- **Backup**: flutter_onedrive (Account Holder/Admin only)

### Multi-Workspace System
- **Personal Workspace**: Auto-created for each user
- **Company Workspace**: Created by users with Account Holder/Admin/Member roles
- **Workspace Switching**: Users can switch between workspaces
- **Data Isolation**: All data is filtered by current workspace

## 📊 Data Model Structure

### Firebase Database Structure (V1)
```json
{
  "users": { "userId": { ... } },
  "workspaces": { "workspaceId": { ... } },
  "workspace_members": { "workspaceId": { "userId": { ... } } },
  "workspace_data": {
    "workspaceId": {
      "projects": { "projectId": { ... } },
      "tasks": { "taskId": { ... } },
      "reports": { "userId": { "date": { ... } } }
    }
  }
}
```

## 👥 User Roles & Permissions

### Role Hierarchy
1. **Account Holder**: Company workspace creator, full permissions
2. **Admin**: Assigned by Account Holder, customizable permissions
3. **Member**: Assigned by Admin/Account Holder, limited permissions
4. **Personal User**: Full access to own personal workspace

### Permission System
- **Permission-based** (not role-based)
- **Customizable** per user
- **Workspace-scoped** permissions
- **Hierarchy-aware** data access

## 🚀 Current Development Phase

### Phase 1: Multi-Workspace Authentication & User Management
**Status**: In Progress
**Focus Areas**:
- Multi-workspace user registration flow
- Personal workspace auto-creation
- Company workspace creation
- Workspace switching functionality
- Permission-based access control system

## 🎨 UI/UX Standards

### Widget Naming
- **Custom Widgets**: Must use TD prefix (e.g., `TDButton`, `TDTextField`)
- **Material Widgets**: NEVER use directly, always wrap in TD widgets

### String Management
- **AppStrings**: All user-facing text must come from `lib/core/constants/app_strings.dart`
- **NO hardcoded strings** anywhere in the codebase

### Navigation & Notifications
- **NavigationService**: Use for all navigation (never `Get.to`, `Get.back`)
- **SnackbarService**: Use for all notifications (never `Get.snackbar`)
- **Always await** navigation calls to avoid race conditions

### Color Scheme
- **Primary Color**: Green `rgb(5, 129, 45)`
- **AppSpacing**: Use for all spacing constants

## 📁 File Organization

### Clean Architecture Structure
```
lib/
├── app/                    # App configuration and routes
├── core/                   # Core utilities and constants
│   ├── constants/         # AppStrings, AppSpacing, etc.
│   ├── services/          # NavigationService, SnackbarService
│   └── utils/             # Utility functions
├── features/              # Feature-based modules
│   └── [feature_name]/
│       ├── data/          # Data sources and repositories
│       ├── domain/        # Entities and use cases
│       └── presentation/  # Controllers and UI
└── main.dart
```

### Feature Module Structure
Each feature follows Clean Architecture:
- **data/**: Data sources, repositories, models
- **domain/**: Entities, use cases, repository interfaces
- **presentation/**: Controllers, pages, widgets

## 🔧 Technical Stack

### Core Dependencies
- **Flutter**: 3.35.5 (Latest stable)
- **State Management**: GetX
- **Local Storage**: Hive
- **Cloud**: Firebase (Auth, Realtime DB, FCM)
- **Backup**: flutter_onedrive
- **HTTP Server**: Shelf (for device-hosted backend)

### Key Packages
```yaml
dependencies:
  get: ^4.6.6                    # State management
  firebase_core: ^2.24.2        # Firebase core
  firebase_auth: ^4.15.3        # Authentication
  cloud_firestore: ^4.13.6      # Firestore database
  firebase_messaging: ^14.7.10  # Push notifications
  hive: ^2.2.3                  # Local storage
  hive_flutter: ^1.1.0          # Hive Flutter integration
  flutter_onedrive: ^1.8.1      # OneDrive integration
  shelf: ^1.4.1                 # HTTP server
  dio: ^5.4.0                   # HTTP client
```

## 🧪 Testing Requirements

### Test Coverage
- **Unit Tests**: Minimum 80% coverage
- **Widget Tests**: For all custom widgets
- **Integration Tests**: For Firebase and OneDrive integration

### Test Structure
```
test/
├── unit/                    # Unit tests
├── widget/                  # Widget tests
├── integration/             # Integration tests
└── helpers/                 # Test helpers and mocks
```

## 📝 Code Quality Standards

### File Size Limits
- **Files**: Maximum 400 lines
- **Widgets**: Maximum 100 lines
- **Functions**: Maximum 50 lines

### Naming Conventions
- **Variables**: camelCase
- **Classes**: PascalCase
- **Files**: snake_case
- **Constants**: UPPER_SNAKE_CASE

### Error Handling
- **NO print() statements** in production
- **Use logging service** or SnackbarService
- **Proper error boundaries** in UI
- **Graceful degradation** for offline scenarios

## 🔐 Security Requirements

### Authentication
- **Firebase Auth** with Google Sign-In and Email/Password
- **Multi-workspace** authentication flow
- **Permission-based** access control

### Data Security
- **Firebase Security Rules** for data access
- **Workspace isolation** for data
- **Encrypted local storage** with Hive

## 📚 Essential Documentation

### Must-Read Files
1. **Development Blueprint V1**: `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md`
2. **Development Rules**: `rules/DEVELOPMENT_RULES.md`
3. **Architecture Rules**: `rules/ARCHITECTURE_RULES.md`
4. **Coding Standards**: `rules/CODING_STANDARDS.md`
5. **UI/UX Rules**: `rules/UI_UX_RULES.md`
6. **Security Rules**: `rules/SECURITY_RULES.md`
7. **Commit Rules**: `rules/COMMIT_RULES.md`

### Additional Context
- **Authentication Flow**: `docs/v1/AUTHENTICATION_AND_COMPANY_SETUP_FLOW.md`
- **Technical Specifications**: `docs/TECHNICAL_SPECIFICATIONS.md`
- **Design System**: `docs/DESIGN_SYSTEM.md`

## 🚨 Critical Rules Summary

### ❌ NEVER DO
- Hardcode strings (use AppStrings)
- Use Material widgets directly (use TD widgets)
- Use Get.snackbar() or Get.to/Get.back (use Services)
- Use withOpacity() (use withValues(alpha: value))
- Create files > 400 lines or widgets > 100 lines
- Use print() in production

### ✅ ALWAYS DO
- Read rules/ and docs/v1/ before coding
- Use AppStrings for all text
- Use TD prefix for custom widgets
- Use NavigationService and SnackbarService
- Await navigation calls
- Follow Clean Architecture
- Use proper type arguments
- Write comprehensive tests

## 🎯 Development Workflow

### Pre-Development Checklist
1. ✅ Read Development Blueprint V1
2. ✅ Read Development Rules
3. ✅ Read relevant feature documentation
4. ✅ Understand current phase requirements
5. ✅ Check existing code patterns

### Implementation Steps
1. **Plan**: Understand requirements and architecture
2. **Design**: Create proper data models and interfaces
3. **Implement**: Follow Clean Architecture and coding standards
4. **Test**: Write comprehensive tests
5. **Document**: Update relevant documentation
6. **Commit**: Follow commit message conventions

### Post-Development Checklist
1. ✅ Code follows all rules
2. ✅ Tests pass with >80% coverage
3. ✅ No linting errors
4. ✅ Documentation updated
5. ✅ Commit message follows conventions

## 🔄 Common Patterns

### Controller Pattern
```dart
class TaskController extends GetxController {
  final _taskRepository = Get.find<TaskRepository>();
  
  final _tasks = <Task>[].obs;
  List<Task> get tasks => _tasks;
  
  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }
  
  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskRepository.getTasks();
      _tasks.assignAll(tasks);
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.failedToLoadTasks,
      );
    }
  }
}
```

### Widget Pattern
```dart
class TDButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  
  const TDButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? const CircularProgressIndicator()
        : Text(text),
    );
  }
}
```

### Navigation Pattern
```dart
// ✅ Correct
await NavigationService().toNamed<void>(
  AppRoutes.taskDetail,
  arguments: {'taskId': task.id},
);

// ❌ Wrong
Get.toNamed('/task-detail', arguments: {'taskId': task.id});
```

### Notification Pattern
```dart
// ✅ Correct
SnackbarService().showSuccess(
  title: AppStrings.success,
  message: AppStrings.taskCreated,
);

// ❌ Wrong
Get.snackbar('Success', 'Task created');
```

---

**Remember**: Always refer to the rules/ and docs/v1/ directories for detailed information. This context guide is a summary - the full rules take precedence.
