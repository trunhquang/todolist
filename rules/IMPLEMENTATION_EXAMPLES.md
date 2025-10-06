# 🛠️ Implementation Examples

## 1. Custom Widget Implementation
```dart
// shared/widgets/td_card.dart
class TDCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;

  const TDCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? AppSpacing.cardMargin,
      child: Card(
        elevation: elevation ?? AppTheme.cardElevation,
        color: backgroundColor ?? AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Padding(
          padding: padding ?? AppSpacing.cardPadding,
          child: child,
        ),
      ),
    );
  }
}

// shared/widgets/td_button.dart
class TDButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TDButtonType type;
  final TDButtonSize size;
  final IconData? icon;

  const TDButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = TDButtonType.primary,
    this.size = TDButtonSize.medium,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: _buildButtonContent(),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: AppSpacing.getButtonPadding(size),
      backgroundColor: AppTheme.getButtonColor(type),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppTheme.getIconSize(size)),
          SizedBox(width: AppSpacing.iconTextSpacing),
          TDText.button(text),
        ],
      );
    }
    return TDText.button(text);
  }
}
```

## 2. Notification Service Implementation
```dart
// shared/services/notification_service.dart
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static void showSnackbar({
    required String message,
    String? title,
    TDNotificationType type = TDNotificationType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    // Use SnackbarService instead of direct Get.snackbar
    SnackbarService.instance.showInfo(
      title: title ?? _getDefaultTitle(type),
      message: message,
      duration: duration,
      onTap: onTap,
    );
  }

  static Future<T?> showDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    // Use NavigationService to show dialog
    return NavigationService.instance.showAlertDialog<T>(
      title: title,
      message: message,
      confirmText: confirmText ?? AppStrings.confirm,
      cancelText: cancelText ?? AppStrings.cancel,
      onConfirm: onConfirm,
      onCancel: onCancel,
      barrierDismissible: barrierDismissible,
    );
  }
}
```

## 3. String Management Implementation
```dart
// shared/constants/app_strings.dart
class AppStrings {
  // Common
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  static const String ok = 'ok';
  static const String save = 'save';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String add = 'add';
  static const String search = 'search';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String warning = 'warning';
  static const String info = 'info';

  // Tasks
  static const String tasks = 'tasks';
  static const String task = 'task';
  static const String createTask = 'create_task';
  static const String editTask = 'edit_task';
  static const String deleteTask = 'delete_task';
  static const String taskTitle = 'task_title';
  static const String taskDescription = 'task_description';
  static const String taskCreatedSuccessfully = 'task_created_successfully';
  static const String taskUpdatedSuccessfully = 'task_updated_successfully';
  static const String taskDeletedSuccessfully = 'task_deleted_successfully';

  // Task Types
  static const String dailyTask = 'daily_task';
  static const String weeklyTask = 'weekly_task';
  static const String monthlyTask = 'monthly_task';
  static const String projectTask = 'project_task';

  // Validation Messages
  static const String fieldRequired = 'field_required';
  static const String emailInvalid = 'email_invalid';
  static const String passwordTooShort = 'password_too_short';

  // Error Messages
  static const String unexpectedError = 'unexpected_error';
  static const String networkError = 'network_error';
  static const String serverError = 'server_error';
}
```

## 4. Spacing Implementation
```dart
// shared/constants/app_spacing.dart
class AppSpacing {
  // Base spacing unit
  static const double _baseUnit = 8.0;

  // Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(_baseUnit * 2); // 16
  static const EdgeInsets contentPadding = EdgeInsets.all(_baseUnit * 1.5); // 12
  static const EdgeInsets actionPadding = EdgeInsets.symmetric(
    horizontal: _baseUnit * 2,
    vertical: _baseUnit,
  ); // 16, 8
  static const EdgeInsets screenPadding = EdgeInsets.all(_baseUnit * 2); // 16
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    vertical: _baseUnit * 3,
  ); // 24

  // Margin
  static const EdgeInsets cardMargin = EdgeInsets.all(_baseUnit); // 8
  static const EdgeInsets contentMargin = EdgeInsets.symmetric(
    horizontal: _baseUnit * 2,
  ); // 16
  static const EdgeInsets sectionMargin = EdgeInsets.only(
    bottom: _baseUnit * 4,
  ); // 32

  // Specific spacing
  static const EdgeInsets snackbarMargin = EdgeInsets.all(_baseUnit * 2);
  static const double iconTextSpacing = _baseUnit; // 8
  static const double itemSpacing = _baseUnit * 1.5; // 12
  static const double sectionSpacing = _baseUnit * 3; // 24

  // Button padding by size
  static EdgeInsets getButtonPadding(TDButtonSize size) {
    switch (size) {
      case TDButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 1.5,
          vertical: _baseUnit,
        );
      case TDButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 2,
          vertical: _baseUnit * 1.5,
        );
      case TDButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 3,
          vertical: _baseUnit * 2,
        );
    }
  }
}
```

---

**📁 File liên quan:**
- [UI/UX Rules](UI_UX_RULES.md)
- [String Management Rules](STRING_MANAGEMENT_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
