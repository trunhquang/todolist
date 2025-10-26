import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/constants/app_strings.dart';

abstract class BaseController extends GetxController {
  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Error state
  final Rx<Failure?> _error = Rx<Failure?>(null);
  Failure? get error => _error.value;
  bool get hasError => _error.value != null;

  // Success state
  final RxBool _isSuccess = false.obs;
  bool get isSuccess => _isSuccess.value;

  // Set loading state
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  // Set error state
  void setError(Failure? failure) {
    _error.value = failure;
    _isSuccess.value = false;
  }

  // Set success state
  set isSuccess(bool value) {
    _isSuccess.value = value;
    _error.value = null;
  }

  // Clear all states
  void clearStates() {
    _isLoading.value = false;
    _error.value = null;
    _isSuccess.value = false;
  }

  // Handle error
  void handleError(Failure failure) {
    setError(failure);
    isLoading = false;
    
    // Show error message to user using SnackbarService
    final snackbar = Get.isRegistered<SnackbarService>()
        ? Get.find<SnackbarService>()
        : SnackbarService();
    snackbar.showError(
      title: AppStrings.error,
      message: failure.message,
    );
  }

  // Handle success
  void handleSuccess([String? message]) {
    isSuccess = true;
    isLoading = false;
    
    if (message != null) {
      final snackbar = Get.isRegistered<SnackbarService>()
          ? Get.find<SnackbarService>()
          : SnackbarService();
      snackbar.showSuccess(
        title: AppStrings.success,
        message: message,
      );
    }
  }

  // Execute async operation with error handling
  Future<T?> executeAsync<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
    String? successMessage,
    bool showError = true,
  }) async {
    try {
      if (showLoading) isLoading = true;
      clearStates();
      
      final result = await operation();
      
      if (successMessage != null) {
        handleSuccess(successMessage);
      } else {
        isLoading = false;
      }
      
      return result;
    } on Exception catch (e) {
      final failure = _mapExceptionToFailure(e);
      if (showError) {
        handleError(failure);
      } else {
        setError(failure);
        isLoading = false;
      }
      return null;
    }
  }

  // Map exception to failure
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is Failure) {
      return exception;
    }
    
    // Map common exceptions to failures
    if (exception.toString().contains('network')) {
      return const NetworkFailure(message: 'Network connection failed');
    }
    
    if (exception.toString().contains('timeout')) {
      return const TimeoutFailure(message: 'Request timed out');
    }
    
    if (exception.toString().contains('unauthorized')) {
      return const UnauthorizedFailure(message: 'Unauthorized access');
    }
    
    if (exception.toString().contains('forbidden')) {
      return const ForbiddenFailure(message: 'Access forbidden');
    }
    
    if (exception.toString().contains('not found')) {
      return const NotFoundFailure(message: 'Resource not found');
    }
    
    if (exception.toString().contains('validation')) {
      return const ValidationFailure(message: 'Validation failed');
    }
    
    if (exception.toString().contains('firebase')) {
      return const FirebaseFailure(message: 'Firebase operation failed');
    }
    
    if (exception.toString().contains('storage')) {
      return const StorageFailure(message: 'Storage operation failed');
    }
    
    // Default to unknown failure
    return UnknownFailure(
      message: exception.toString(),
    );
  }

  @override
  void onInit() {
    super.onInit();
    clearStates();
  }

  // Navigation helper methods
  Future<T?> navigateTo<T>(String routeName, {dynamic arguments}) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.toNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> navigateOffAll<T>(String routeName, {dynamic arguments}) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.offAllNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> navigateOff<T>(String routeName, {dynamic arguments}) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.offNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  void navigateBack<T>({T? result}) {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    nav.back<T>(result: result);
  }

  void navigateBackToRoot() {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    nav.backToRoot();
  }

  // Show dialog with tracking
  Future<T?> showDialog<T>(Widget child, {String? name}) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.showDialog<T>(
      child: child,
      name: name,
    );
  }

  // Show bottom sheet with tracking
  Future<T?> showBottomSheet<T>(Widget child, {String? name}) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.showBottomSheet<T>(
      child,
      name: name,
    );
  }

  // Show alert dialog with tracking
  Future<T?> showAlertDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? name,
  }) async {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    return nav.showAlertDialog<T>(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      name: name,
    );
  }

  // Print navigation state for debugging
  void printNavigationState() {
    final nav = Get.isRegistered<NavigationService>()
        ? Get.find<NavigationService>()
        : NavigationService();
    nav.printNavigationState();
  }

  @override
  void onClose() {
    clearStates();
    super.onClose();
  }
}
