import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';

/// Centralized service for managing all snackbar notifications
/// This allows for easy customization and consistent styling across the app
class SnackbarService {
  factory SnackbarService() => _instance ??= SnackbarService._();
  SnackbarService._();

  static SnackbarService? _instance;

  /// Show success snackbar
  void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success,
      colorText: AppColors.onPrimary,
      snackPosition: position,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.check_circle,
        color: AppColors.onPrimary,
      ),
    );
  }

  /// Show error snackbar
  void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.onError,
      snackPosition: position,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.error,
        color: AppColors.onError,
      ),
    );
  }

  /// Show warning snackbar
  void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warning,
      colorText: AppColors.onPrimary,
      snackPosition: position,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.warning,
        color: AppColors.onPrimary,
      ),
    );
  }

  /// Show info snackbar
  void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.info,
      colorText: AppColors.onPrimary,
      snackPosition: position,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.info,
        color: AppColors.onPrimary,
      ),
    );
  }

  /// Show custom snackbar with full control
  void showCustom({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor ?? AppColors.primary,
      colorText: textColor ?? AppColors.onPrimary,
      snackPosition: position,
      duration: duration,
      margin: margin ?? const EdgeInsets.all(16),
      borderRadius: borderRadius ?? 12,
      icon: icon != null
          ? Icon(
              icon,
              color: textColor ?? AppColors.onPrimary,
            )
          : null,
    );
  }

  /// Show loading snackbar (for long operations)
  void showLoading({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (Get.testMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primary,
      colorText: AppColors.onPrimary,
      snackPosition: SnackPosition.TOP,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
        ),
      ),
    );
  }

  /// Quick success messages for common operations
  void showTaskCreated() {
    showSuccess(
      title: 'Task Created',
      message: 'Your task has been created successfully',
    );
  }

  void showTaskUpdated() {
    showSuccess(
      title: 'Task Updated',
      message: 'Your task has been updated successfully',
    );
  }

  void showTaskDeleted() {
    showSuccess(
      title: 'Task Deleted',
      message: 'Your task has been deleted successfully',
    );
  }

  void showTaskCompleted() {
    showSuccess(
      title: 'Task Completed',
      message: 'Great job! Task marked as completed',
    );
  }

  /// Quick error messages for common operations
  void showNetworkError() {
    showError(
      title: 'Network Error',
      message: 'Please check your internet connection and try again',
      duration: const Duration(seconds: 5),
    );
  }

  void showServerError() {
    showError(
      title: 'Server Error',
      message: 'Something went wrong. Please try again later',
      duration: const Duration(seconds: 5),
    );
  }

  void showValidationError(String field) {
    showError(
      title: 'Validation Error',
      message: 'Please check your $field and try again',
    );
  }

  /// Auth-related messages
  void showLoginSuccess() {
    showSuccess(
      title: 'Welcome Back!',
      message: 'You have been logged in successfully',
    );
  }

  void showLoginError() {
    showError(
      title: 'Login Failed',
      message: 'Please check your credentials and try again',
    );
  }

  void showRegistrationSuccess() {
    showSuccess(
      title: 'Registration Successful',
      message: 'Your account has been created successfully',
    );
  }

  void showRegistrationError() {
    showError(
      title: 'Registration Failed',
      message: 'Please try again or contact support',
    );
  }

  void showLogoutSuccess() {
    showSuccess(
      title: 'Logged Out',
      message: 'You have been logged out successfully',
    );
  }

  /// Company setup messages
  void showCompanySetupSuccess() {
    showSuccess(
      title: 'Setup Complete',
      message: 'Your company has been set up successfully',
    );
  }

  void showCompanySetupError() {
    showError(
      title: 'Setup Failed',
      message: 'Please try again or contact support',
    );
  }

  /// Close all snackbars
  void closeAll() {
    Get.closeAllSnackbars();
  }
}
