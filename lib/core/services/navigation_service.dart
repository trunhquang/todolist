import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized service for managing all navigation operations
/// Provides stack tracking, logging, and consistent navigation behavior
class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance => _instance ??= NavigationService._();

  NavigationService._();

  // Navigation stack tracking
  final List<String> _navigationStack = [];
  final List<String> _popupStack = [];
  final List<String> _alertStack = [];

  // Getters for stack information
  List<String> get navigationStack => List.unmodifiable(_navigationStack);
  List<String> get popupStack => List.unmodifiable(_popupStack);
  List<String> get alertStack => List.unmodifiable(_alertStack);
  String? get currentRoute => _navigationStack.isNotEmpty ? _navigationStack.last : null;
  int get stackDepth => _navigationStack.length;

  /// Log navigation operation
  void _logNavigation(String operation, String route, {Map<String, dynamic>? arguments}) {
    final timestamp = DateTime.now().toIso8601String();
    final args = arguments != null ? ' with args: $arguments' : '';
    print('🧭 [$timestamp] Navigation: $operation -> $route$args');
    print('📱 Current Stack: ${_navigationStack.join(' -> ')}');
    if (_popupStack.isNotEmpty) {
      print('🔔 Active Popups: ${_popupStack.join(', ')}');
    }
    if (_alertStack.isNotEmpty) {
      print('⚠️ Active Alerts: ${_alertStack.join(', ')}');
    }
    print('---');
  }

  /// Log popup/alert operation
  void _logPopupAlert(String operation, String type, String identifier) {
    final timestamp = DateTime.now().toIso8601String();
    print('🔔 [$timestamp] $type: $operation -> $identifier');
    print('📱 Current Stack: ${_navigationStack.join(' -> ')}');
    print('---');
  }

  /// Navigate to a named route
  Future<T?> toNamed<T>(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
    bool preventDuplicates = true,
  }) async {
    _logNavigation('PUSH', routeName, arguments: arguments);
    _navigationStack.add(routeName);
    
    return await Get.toNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters as Map<String, String>?,
      preventDuplicates: preventDuplicates,
    );
  }

  /// Navigate to a named route and remove all previous routes
  Future<T?> offAllNamed<T>(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    _logNavigation('REPLACE_ALL', routeName, arguments: arguments);
    _navigationStack.clear();
    _navigationStack.add(routeName);
    
    return await Get.offAllNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters as Map<String, String>?,
    );
  }

  /// Navigate to a named route and remove current route
  Future<T?> offNamed<T>(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    _logNavigation('REPLACE', routeName, arguments: arguments);
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    _navigationStack.add(routeName);
    
    return await Get.offNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters as Map<String, String>?,
    );
  }

  /// Navigate to a named route and remove routes until condition
  Future<T?> offNamedUntil<T>(
    String routeName,
    RoutePredicate predicate, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    _logNavigation('REPLACE_UNTIL', routeName, arguments: arguments);
    
    // Remove routes from stack until predicate is met
    while (_navigationStack.isNotEmpty && !predicate(Get.routing.current as Route)) {
      _navigationStack.removeLast();
    }
    _navigationStack.add(routeName);
    
    return await Get.offNamedUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
      parameters: parameters as Map<String, String>?,
    );
  }

  /// Go back to previous route
  void back<T>({T? result, bool closeOverlays = false}) {
    final currentRoute = _navigationStack.isNotEmpty ? _navigationStack.last : 'Unknown';
    _logNavigation('POP', 'from $currentRoute', arguments: {'result': result});
    
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    
    Get.back<T>(result: result, closeOverlays: closeOverlays);
  }

  /// Go back until condition is met
  void backUntil(RoutePredicate predicate) {
    _logNavigation('POP_UNTIL', 'until condition met');
    
    // Remove routes from stack until predicate is met
    while (_navigationStack.isNotEmpty && !predicate(Get.routing.current as Route)) {
      _navigationStack.removeLast();
    }
    
    Get.until(predicate);
  }

  /// Go back to root route
  void backToRoot() {
    _logNavigation('POP_TO_ROOT', 'clearing entire stack');
    _navigationStack.clear();
    Get.until((route) => route.isFirst);
  }

  /// Navigate to a page (non-named route)
  Future<T?> to<T>(
    Widget page, {
    Transition? transition,
    Duration? duration,
    bool? opaque,
    bool? popGesture,
    dynamic arguments,
  }) async {
    final routeName = page.runtimeType.toString();
    _logNavigation('PUSH_PAGE', routeName, arguments: arguments);
    _navigationStack.add(routeName);
    
    return await Get.to<T>(
      page,
      transition: transition,
      duration: duration,
      opaque: opaque,
      popGesture: popGesture,
      arguments: arguments,
    );
  }

  /// Show dialog and track it
  Future<T?> showDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    Duration? transitionDuration,
    String? name,
  }) async {
    final dialogId = name ?? 'Dialog_${DateTime.now().millisecondsSinceEpoch}';
    _logPopupAlert('SHOW', 'DIALOG', dialogId);
    _popupStack.add(dialogId);
    
    final result = await Get.dialog<T>(
      child,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      transitionDuration: transitionDuration,
    );
    
    _logPopupAlert('DISMISS', 'DIALOG', dialogId);
    _popupStack.remove(dialogId);
    
    return result;
  }

  /// Show bottom sheet and track it
  Future<T?> showBottomSheet<T>(
    Widget child, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    String? name,
  }) async {
    final sheetId = name ?? 'BottomSheet_${DateTime.now().millisecondsSinceEpoch}';
    _logPopupAlert('SHOW', 'BOTTOM_SHEET', sheetId);
    _popupStack.add(sheetId);
    
    final result = await Get.bottomSheet<T>(
      child,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
    
    _logPopupAlert('DISMISS', 'BOTTOM_SHEET', sheetId);
    _popupStack.remove(sheetId);
    
    return result;
  }

  /// Show snackbar and track it
  void showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? colorText,
    Duration? duration,
    SnackPosition? snackPosition,
    Widget? icon,
    bool? shouldIconPulse,
    double? maxWidth,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    TextButton? mainButton,
    OnTap? onTap,
    bool? isDismissible,
    bool? showProgressIndicator,
    DismissDirection? dismissDirection,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    SnackStyle? snackStyle,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? overlayBlur,
    Color? overlayColor,
    String? name,
  }) {
    final snackbarId = name ?? 'Snackbar_${DateTime.now().millisecondsSinceEpoch}';
    _logPopupAlert('SHOW', 'SNACKBAR', snackbarId);
    _popupStack.add(snackbarId);
    
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      duration: duration,
      snackPosition: snackPosition,
      icon: icon,
      shouldIconPulse: shouldIconPulse,
      maxWidth: maxWidth,
      margin: margin,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible,
      showProgressIndicator: showProgressIndicator,
      dismissDirection: dismissDirection,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      snackStyle: snackStyle,
      forwardAnimationCurve: forwardAnimationCurve,
      reverseAnimationCurve: reverseAnimationCurve,
      animationDuration: animationDuration,
      overlayBlur: overlayBlur,
      overlayColor: overlayColor,
    );
    
    // Remove from stack after duration
    if (duration != null) {
      Future.delayed(duration, () {
        _logPopupAlert('AUTO_DISMISS', 'SNACKBAR', snackbarId);
        _popupStack.remove(snackbarId);
      });
    }
  }

  /// Show alert dialog and track it
  Future<T?> showAlertDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    String? name,
  }) async {
    final alertId = name ?? 'Alert_${DateTime.now().millisecondsSinceEpoch}';
    _logPopupAlert('SHOW', 'ALERT', alertId);
    _alertStack.add(alertId);
    
    final result = await showDialog<T>(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                onCancel?.call();
                back();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () {
                onConfirm?.call();
                back();
              },
              child: Text(confirmText),
            ),
        ],
      ),
      barrierDismissible: barrierDismissible,
      name: alertId,
    );
    
    _logPopupAlert('DISMISS', 'ALERT', alertId);
    _alertStack.remove(alertId);
    
    return result;
  }

  /// Close all overlays (dialogs, bottom sheets, snackbars)
  void closeAllOverlays() {
    _logPopupAlert('CLOSE_ALL', 'OVERLAYS', 'all');
    _popupStack.clear();
    _alertStack.clear();
    Get.closeAllSnackbars();
    Get.until((route) => route.isFirst);
  }

  /// Get navigation history as a formatted string
  String getNavigationHistory() {
    final buffer = StringBuffer();
    buffer.writeln('🧭 Navigation History:');
    buffer.writeln('📱 Stack Depth: ${_navigationStack.length}');
    buffer.writeln('🔔 Active Popups: ${_popupStack.length}');
    buffer.writeln('⚠️ Active Alerts: ${_alertStack.length}');
    buffer.writeln('');
    
    if (_navigationStack.isNotEmpty) {
      buffer.writeln('📱 Navigation Stack:');
      for (int i = 0; i < _navigationStack.length; i++) {
        final route = _navigationStack[i];
        final isCurrent = i == _navigationStack.length - 1;
        buffer.writeln('  ${i + 1}. $route${isCurrent ? ' (current)' : ''}');
      }
    }
    
    if (_popupStack.isNotEmpty) {
      buffer.writeln('🔔 Active Popups:');
      for (final popup in _popupStack) {
        buffer.writeln('  - $popup');
      }
    }
    
    if (_alertStack.isNotEmpty) {
      buffer.writeln('⚠️ Active Alerts:');
      for (final alert in _alertStack) {
        buffer.writeln('  - $alert');
      }
    }
    
    return buffer.toString();
  }

  /// Print current navigation state
  void printNavigationState() {
    print(getNavigationHistory());
  }

  /// Clear all navigation tracking (useful for testing)
  void clearNavigationTracking() {
    _navigationStack.clear();
    _popupStack.clear();
    _alertStack.clear();
    print('🧭 Navigation tracking cleared');
  }

  /// Check if a route is in the current stack
  bool isRouteInStack(String routeName) {
    return _navigationStack.contains(routeName);
  }

  /// Get the position of a route in the stack
  int getRoutePosition(String routeName) {
    return _navigationStack.indexOf(routeName);
  }

  /// Check if there are any active popups or alerts
  bool get hasActiveOverlays => _popupStack.isNotEmpty || _alertStack.isNotEmpty;

  /// Get the number of active overlays
  int get activeOverlayCount => _popupStack.length + _alertStack.length;
}
