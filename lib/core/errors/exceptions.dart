// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message';
}

// Network exceptions
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class ServerException extends AppException {
  const ServerException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class TimeoutException extends AppException {
  const TimeoutException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class InvalidInputException extends AppException {
  const InvalidInputException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class CacheException extends AppException {
  const CacheException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class NotFoundException extends AppException {
  const NotFoundException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class ConflictException extends AppException {
  const ConflictException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Firebase exceptions
class FirebaseException extends AppException {
  const FirebaseException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class DatabaseException extends AppException {
  const DatabaseException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// OneDrive exceptions
class OneDriveException extends AppException {
  const OneDriveException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class UploadException extends AppException {
  const UploadException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class DownloadException extends AppException {
  const DownloadException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Notification exceptions
class NotificationException extends AppException {
  const NotificationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Generic exceptions
class UnknownException extends AppException {
  const UnknownException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class NotImplementedException extends AppException {
  const NotImplementedException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}
