# SnackbarService - Centralized Notification Management

## 🎯 Overview

The `SnackbarService` is a centralized service for managing all snackbar notifications in the app. This ensures consistent styling, easy customization, and maintainable code.

## 📁 Location
`lib/core/services/snackbar_service.dart`

## 🚀 Usage

### Basic Usage

```dart
import 'package:todolist/core/services/snackbar_service.dart';

// Show success message
SnackbarService.instance.showSuccess(
  title: 'Success',
  message: 'Operation completed successfully',
);

// Show error message
SnackbarService.instance.showError(
  title: 'Error',
  message: 'Something went wrong',
);

// Show warning message
SnackbarService.instance.showWarning(
  title: 'Warning',
  message: 'Please check your input',
);

// Show info message
SnackbarService.instance.showInfo(
  title: 'Info',
  message: 'Here is some information',
);
```

### Quick Methods for Common Operations

```dart
// Task operations
SnackbarService.instance.showTaskCreated();
SnackbarService.instance.showTaskUpdated();
SnackbarService.instance.showTaskDeleted();
SnackbarService.instance.showTaskCompleted();

// Auth operations
SnackbarService.instance.showLoginSuccess();
SnackbarService.instance.showLoginError();
SnackbarService.instance.showRegistrationSuccess();
SnackbarService.instance.showRegistrationError();
SnackbarService.instance.showLogoutSuccess();

// Company setup
SnackbarService.instance.showCompanySetupSuccess();
SnackbarService.instance.showCompanySetupError();

// Common errors
SnackbarService.instance.showNetworkError();
SnackbarService.instance.showServerError();
SnackbarService.instance.showValidationError('email');
```

### Custom Snackbar

```dart
SnackbarService.instance.showCustom(
  title: 'Custom Title',
  message: 'Custom message',
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  icon: Icons.star,
  duration: Duration(seconds: 5),
  position: SnackPosition.BOTTOM,
);
```

### Loading Snackbar

```dart
SnackbarService.instance.showLoading(
  title: 'Processing',
  message: 'Please wait...',
);
```

## 🎨 Styling

### Default Colors
- **Success**: Green (`AppColors.success`)
- **Error**: Red (`AppColors.error`)
- **Warning**: Orange (`AppColors.warning`)
- **Info**: Blue (`AppColors.info`)

### Default Settings
- **Position**: Top
- **Duration**: 3 seconds (4 seconds for errors)
- **Margin**: 16px all around
- **Border Radius**: 12px
- **Icons**: Contextual icons for each type

## 🔧 Customization

### Changing Global Settings

To modify the default behavior, edit the `SnackbarService` class:

```dart
// Change default duration
void showSuccess({
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 5), // Changed from 3
  // ... other parameters
}) {
  // Implementation
}

// Change default position
void showError({
  required String title,
  required String message,
  SnackPosition position = SnackPosition.BOTTOM, // Changed from TOP
  // ... other parameters
}) {
  // Implementation
}
```

### Adding New Quick Methods

```dart
// Add new quick method
void showDataSynced() {
  showSuccess(
    title: 'Data Synced',
    message: 'Your data has been synchronized successfully',
  );
}

void showBackupCreated() {
  showInfo(
    title: 'Backup Created',
    message: 'Your data backup has been created',
  );
}
```

## 📱 Integration with Controllers

### BaseController Integration

The `BaseController` automatically uses `SnackbarService`:

```dart
class MyController extends BaseController {
  Future<void> performAction() async {
    await executeAsync(
      () async {
        // Your async operation
        return await someApiCall();
      },
      successMessage: 'Action completed successfully',
    );
  }
}
```

### Manual Usage in Controllers

```dart
class MyController extends GetxController {
  Future<void> performAction() async {
    try {
      setLoading(true);
      await someApiCall();
      
      SnackbarService.instance.showSuccess(
        title: 'Success',
        message: 'Action completed successfully',
      );
    } catch (e) {
      SnackbarService.instance.showError(
        title: 'Error',
        message: 'Failed to complete action',
      );
    } finally {
      setLoading(false);
    }
  }
}
```

## 🚫 Migration from Get.snackbar

### Before (Direct Get.snackbar)
```dart
Get.snackbar(
  'Error',
  'Something went wrong',
  backgroundColor: AppColors.error,
  colorText: AppColors.onError,
  snackPosition: SnackPosition.TOP,
);
```

### After (Using SnackbarService)
```dart
SnackbarService.instance.showError(
  title: 'Error',
  message: 'Something went wrong',
);
```

## ✅ Benefits

1. **Centralized Management**: All snackbar logic in one place
2. **Consistent Styling**: Uniform appearance across the app
3. **Easy Customization**: Change styling globally
4. **Type Safety**: Predefined methods for common scenarios
5. **Maintainability**: Easy to update and modify
6. **Reusability**: Quick methods for common operations
7. **Testing**: Easier to mock and test

## 🔄 Future Enhancements

### Potential Additions
- **Animation Options**: Custom animations for different types
- **Sound Effects**: Audio feedback for notifications
- **Haptic Feedback**: Vibration for mobile devices
- **Queue Management**: Handle multiple notifications
- **Persistent Notifications**: For critical messages
- **Custom Themes**: Dark/light mode support

### Example Future Implementation
```dart
void showSuccess({
  required String title,
  required String message,
  bool withHaptic = true,
  bool withSound = false,
  NotificationAnimation animation = NotificationAnimation.slide,
}) {
  if (withHaptic) {
    HapticFeedback.lightImpact();
  }
  
  if (withSound) {
    AudioService.playSuccessSound();
  }
  
  // Show snackbar with animation
  _showWithAnimation(title, message, animation);
}
```

## 📋 Best Practices

1. **Use Quick Methods**: Prefer predefined methods over custom ones
2. **Consistent Messaging**: Use similar wording for similar actions
3. **Appropriate Duration**: Longer duration for errors, shorter for success
4. **Clear Titles**: Use descriptive titles that match the action
5. **User-Friendly Messages**: Write messages that users can understand
6. **Error Handling**: Always provide helpful error messages

## 🧪 Testing

### Unit Testing
```dart
test('should show success snackbar', () {
  // Arrange
  final snackbarService = SnackbarService.instance;
  
  // Act
  snackbarService.showSuccess(
    title: 'Test',
    message: 'Test message',
  );
  
  // Assert
  // Verify snackbar was shown
});
```

### Widget Testing
```dart
testWidgets('should display error snackbar', (tester) async {
  // Arrange
  await tester.pumpWidget(MyApp());
  
  // Act
  SnackbarService.instance.showError(
    title: 'Error',
    message: 'Test error',
  );
  await tester.pump();
  
  // Assert
  expect(find.text('Error'), findsOneWidget);
  expect(find.text('Test error'), findsOneWidget);
});
```

## 📚 Related Files

- `lib/core/controllers/base_controller.dart` - Uses SnackbarService
- `lib/app/pages/auth/company_setup_page.dart` - Updated to use SnackbarService
- `lib/app/pages/auth/register_page.dart` - Updated to use SnackbarService
- `lib/app/theme/app_colors.dart` - Color definitions used by SnackbarService
