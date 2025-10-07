# NavigationService - Centralized Navigation Management

## 🎯 Overview

The `NavigationService` is a centralized service for managing all navigation operations in the app. It provides comprehensive stack tracking, logging, and consistent navigation behavior across the entire application.

## 📁 Location
`lib/core/services/navigation_service.dart`

## 🚀 Key Features

### 1. **Navigation Stack Tracking**
- Tracks all navigation operations (push, pop, replace)
- Maintains a complete history of the navigation stack
- Provides stack depth and current route information

### 2. **Popup & Alert Tracking**
- Tracks all dialogs, bottom sheets, and alerts
- Monitors popup lifecycle (show/dismiss)
- Provides visibility into active overlays

### 3. **Comprehensive Logging**
- Logs all navigation operations with timestamps
- Tracks arguments and parameters
- Provides detailed stack information for debugging

### 4. **Centralized Management**
- Single point of control for all navigation
- Consistent behavior across the app
- Easy to modify and extend

## 📋 Basic Usage

### Navigation Operations

```dart
import 'package:todolist/core/services/navigation_service.dart';

// Navigate to a route
await NavigationService.instance.toNamed(AppRouter.taskDetail, arguments: taskId);

// Replace current route
await NavigationService.instance.offNamed(AppRouter.dashboard);

// Replace all routes
await NavigationService.instance.offAllNamed(AppRouter.login);

// Go back
NavigationService.instance.back();

// Go back to root
NavigationService.instance.backToRoot();
```

### Popup Management

```dart
// Show dialog with tracking
await NavigationService.instance.showDialog(
  child: MyDialog(),
  name: 'TaskDeleteDialog',
);

// Show bottom sheet with tracking
await NavigationService.instance.showBottomSheet(
  child: MyBottomSheet(),
  name: 'TaskOptionsSheet',
);

// Show alert dialog with tracking
await NavigationService.instance.showAlertDialog(
  title: 'Confirm Delete',
  message: 'Are you sure you want to delete this task?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  name: 'DeleteConfirmation',
);
```

### Snackbar with Tracking

```dart
NavigationService.instance.showSnackbar(
  title: 'Success',
  message: 'Task created successfully',
  name: 'TaskCreatedSnackbar',
);
```

## 🔍 Stack Tracking & Debugging

### View Current Navigation State

```dart
// Print current navigation state
NavigationService.instance.printNavigationState();

// Get navigation history as string
String history = NavigationService.instance.getNavigationHistory();
print(history);

// Check if route is in stack
bool isInStack = NavigationService.instance.isRouteInStack(AppRouter.dashboard);

// Get route position in stack
int position = NavigationService.instance.getRoutePosition(AppRouter.dashboard);
```

### Stack Information

```dart
// Get current route
String? currentRoute = NavigationService.instance.currentRoute;

// Get stack depth
int depth = NavigationService.instance.stackDepth;

// Get navigation stack
List<String> stack = NavigationService.instance.navigationStack;

// Get active popups
List<String> popups = NavigationService.instance.popupStack;

// Get active alerts
List<String> alerts = NavigationService.instance.alertStack;

// Check if there are active overlays
bool hasOverlays = NavigationService.instance.hasActiveOverlays;

// Get overlay count
int overlayCount = NavigationService.instance.activeOverlayCount;
```

## 📊 Logging Output

### Navigation Logs
```
🧭 [2024-01-15T10:30:45.123Z] Navigation: PUSH -> /task-detail with args: {taskId: 123}
📱 Current Stack: /dashboard -> /task-detail
🔔 Active Popups: TaskOptionsSheet
⚠️ Active Alerts: DeleteConfirmation
---
```

### Popup/Alert Logs
```
🔔 [2024-01-15T10:30:45.123Z] DIALOG: SHOW -> TaskDeleteDialog
📱 Current Stack: /dashboard -> /task-detail
---

🔔 [2024-01-15T10:30:50.456Z] DIALOG: DISMISS -> TaskDeleteDialog
📱 Current Stack: /dashboard -> /task-detail
---
```

## 🎛️ Integration with Controllers

### BaseController Integration

The `BaseController` provides helper methods for navigation:

```dart
class MyController extends BaseController {
  Future<void> navigateToTaskDetail(String taskId) async {
    await navigateTo('/task-detail', arguments: taskId);
  }

  Future<void> navigateToDashboard() async {
    await navigateOffAll('/dashboard');
  }

  void goBack() {
    navigateBack();
  }

  Future<void> showDeleteConfirmation() async {
    await showAlertDialog(
      title: 'Delete Task',
      message: 'Are you sure?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      name: 'DeleteTaskConfirmation',
    );
  }
}
```

## 🔧 Advanced Usage

### Custom Navigation with Tracking

```dart
// Navigate with custom parameters
await NavigationService.instance.toNamed(
  '/task-edit',
  arguments: {'taskId': taskId, 'mode': 'edit'},
  parameters: {'tab': 'details'},
  preventDuplicates: true,
);

// Navigate until condition
await NavigationService.instance.offNamedUntil(
  '/dashboard',
  (route) => route.settings.name == '/home',
  arguments: {'refresh': true},
);
```

### Custom Popup with Tracking

```dart
// Custom dialog with specific configuration
await NavigationService.instance.showDialog(
  child: MyCustomDialog(),
  barrierDismissible: false,
  barrierColor: Colors.black54,
  name: 'CustomDialog_${DateTime.now().millisecondsSinceEpoch}',
);
```

### Navigation State Management

```dart
// Clear navigation tracking (useful for testing)
NavigationService.instance.clearNavigationTracking();

// Close all overlays
NavigationService.instance.closeAllOverlays();

// Get detailed navigation history
String history = NavigationService.instance.getNavigationHistory();
```

## 🚫 Migration from Direct Get Navigation

### Before (Direct Get Navigation)
```dart
// Old way
Get.toNamed('/task-detail', arguments: taskId);
Get.offAllNamed(AppRouter.dashboard);
Get.back();
Get.dialog(MyDialog());
```

### After (Using NavigationService)
```dart
// New way
NavigationService.instance.toNamed('/task-detail', arguments: taskId);
NavigationService.instance.offAllNamed(AppRouter.dashboard);
NavigationService.instance.back();
NavigationService.instance.showDialog(child: MyDialog());
```

## 🎯 Benefits

### 1. **Centralized Control**
- Single point of navigation management
- Consistent behavior across the app
- Easy to modify navigation logic

### 2. **Comprehensive Tracking**
- Complete navigation history
- Popup and alert monitoring
- Detailed logging for debugging

### 3. **Better Debugging**
- Clear visibility into navigation flow
- Stack information for troubleshooting
- Timestamped logs for analysis

### 4. **Maintainability**
- Easy to add new navigation features
- Consistent API across the app
- Centralized configuration

### 5. **Testing Support**
- Clear navigation tracking
- Easy to mock and test
- Predictable behavior

## 🔄 Navigation Flow Examples

### Typical App Flow
```
1. Splash -> Login (offAllNamed)
2. Login -> Register (toNamed)
3. Register -> Company Setup (offAllNamed)
4. Company Setup -> Dashboard (offAllNamed)
5. Dashboard -> Task Detail (toNamed)
6. Task Detail -> Dashboard (back)
```

### Project Detail → Task Creation (Prefilled & Locked projectId)

```dart
// From ProjectDetailPage controller or UI action
Future<void> navigateToCreateTaskForProject(String projectId) async {
  await NavigationService.instance.toNamed(
    AppRouter.taskCreate,
    arguments: {
      'projectId': projectId,
      'lockProject': true, // instruct TaskCreate page to lock Project picker & link toggle
      'source': 'project_detail',
    },
    preventDuplicates: true,
  );
}

// On TaskCreatePage init (pseudo-code)
void onInit() {
  final args = NavigationService.instance.currentArguments as Map? ?? {};
  final String? projectId = args['projectId'] as String?;
  final bool lockProject = (args['lockProject'] as bool?) ?? false;

  if (projectId != null) {
    formState.projectId.value = projectId;
    formState.linkToProject.value = true;
  }

  uiState.lockProjectControls.value = lockProject; // disables toggle & picker when true
}
```

Notes:
- When `lockProject = true`, the Task Creation UI should:
  - Force `Link to project` = ON
  - Prefill the `Project` picker with `projectId`
  - Disable both the toggle and the picker to prevent changes
- Validation remains in effect; if the project is closed, show the closed warning and block creation

Stack example:
```
... -> /project-detail -> /task-create
```

### Stack Tracking
```
Initial: []
After Login: [AppRouter.login]
After Dashboard: [AppRouter.dashboard]
After Task Detail: [AppRouter.dashboard, AppRouter.taskDetail]
After Back: [AppRouter.dashboard]
```

### Popup Flow
```
1. Show Task Options Sheet (showBottomSheet)
2. Show Delete Confirmation (showAlertDialog)
3. Show Success Snackbar (showSnackbar)
4. Dismiss All (closeAllOverlays)
```

## 🧪 Testing

### Unit Testing
```dart
test('should track navigation stack correctly', () {
  final navigationService = NavigationService.instance;
  
  // Clear tracking
  navigationService.clearNavigationTracking();
  
  // Navigate
  navigationService.toNamed('/test-route');
  
  // Verify
  expect(navigationService.currentRoute, '/test-route');
  expect(navigationService.stackDepth, 1);
  expect(navigationService.isRouteInStack('/test-route'), true);
});
```

### Widget Testing
```dart
testWidgets('should show dialog with tracking', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Show dialog
  await NavigationService.instance.showDialog(
    child: TestDialog(),
    name: 'TestDialog',
  );
  
  await tester.pump();
  
  // Verify dialog is shown and tracked
  expect(find.byType(TestDialog), findsOneWidget);
  expect(NavigationService.instance.popupStack, contains('TestDialog'));
});
```

## 📈 Performance Considerations

### Memory Usage
- Stack tracking uses minimal memory
- Logs are printed to console (not stored)
- No performance impact on navigation

### Logging Overhead
- Minimal overhead for logging
- Can be disabled in production if needed
- Useful for development and debugging

## 🔮 Future Enhancements

### Potential Features
- **Navigation Analytics**: Track user navigation patterns
- **Deep Linking**: Handle deep links with stack management
- **Navigation Guards**: Route protection and validation
- **Animation Tracking**: Monitor transition animations
- **Performance Metrics**: Track navigation performance
- **User Flow Analysis**: Analyze user journey through the app

### Example Future Implementation
```dart
// Navigation analytics
void trackNavigationEvent(String event, Map<String, dynamic> data) {
  AnalyticsService.track('navigation_$event', data);
}

// Deep linking support
void handleDeepLink(String link) {
  final route = DeepLinkParser.parse(link);
  NavigationService.instance.offAllNamed(route.path, arguments: route.args);
}

// Navigation guards
bool canNavigateTo(String route) {
  return AuthService.isAuthenticated || route == '/login';
}
```

## 📋 Best Practices

### 1. **Consistent Naming**
- Use descriptive route names
- Use consistent popup/alert naming
- Follow naming conventions

### 2. **Proper Stack Management**
- Use `offAllNamed` for major navigation changes
- Use `toNamed` for adding to stack
- Use `back` for returning to previous screen

### 3. **Popup Management**
- Always provide names for popups
- Handle popup dismissal properly
- Avoid too many simultaneous popups

### 4. **Error Handling**
- Handle navigation errors gracefully
- Provide fallback navigation
- Log navigation failures

### 5. **Testing**
- Test navigation flows
- Verify stack tracking
- Mock navigation service in tests

## 📚 Related Files

- `lib/core/controllers/base_controller.dart` - Uses NavigationService
- `lib/app/pages/auth/register_page.dart` - Updated to use NavigationService
- `lib/app/pages/auth/company_setup_page.dart` - Updated to use NavigationService
- `lib/app/pages/auth/login_page.dart` - Updated to use NavigationService
- `lib/app/pages/splash_page.dart` - Updated to use NavigationService
- `lib/app/pages/home/dashboard_page.dart` - Updated to use NavigationService

## 🎉 Summary

The NavigationService provides a comprehensive solution for managing navigation in your Flutter app. With stack tracking, popup monitoring, and detailed logging, it makes navigation debugging and management much easier while maintaining consistent behavior across the entire application.

---
**Last Updated**: Current Date  
**Maintained By**: Development Team  
**Status**: Active ✅
