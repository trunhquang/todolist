import 'package:get/get.dart';
import 'package:todolist/core/errors/failures.dart';

abstract class BaseController extends GetxController {
  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Error state
  final Rx<Failure?> _error = Rx<Failure?>(null);
  Failure? get error => _error.value;

  // Success state
  final RxBool _isSuccess = false.obs;
  bool get isSuccess => _isSuccess.value;

  // Set loading state
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  // Set error state
  void setError(Failure? failure) {
    _error.value = failure;
    _isSuccess.value = false;
  }

  // Set success state
  void setSuccess(bool success) {
    _isSuccess.value = success;
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
    setLoading(false);
    
    // Show error message to user
    Get.snackbar(
      'Error',
      failure.message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Handle success
  void handleSuccess([String? message]) {
    setSuccess(true);
    setLoading(false);
    
    if (message != null) {
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
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
      if (showLoading) setLoading(true);
      clearStates();
      
      final result = await operation();
      
      if (successMessage != null) {
        handleSuccess(successMessage);
      } else {
        setLoading(false);
      }
      
      return result;
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      if (showError) {
        handleError(failure);
      } else {
        setError(failure);
        setLoading(false);
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

  @override
  void onClose() {
    clearStates();
    super.onClose();
  }
}
