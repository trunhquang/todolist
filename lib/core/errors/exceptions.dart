// Base exception class
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final dynamic details;

  @override
  String toString() => 'AppException: $message';
}

// Network exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
  });
}

// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    required super.message,
    super.code,
    super.details,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    required super.message,
    super.code,
    super.details,
  });
}

// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class InvalidInputException extends AppException {
  const InvalidInputException({
    required super.message,
    super.code,
    super.details,
  });
}

// Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });
}

// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.details,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code,
    super.details,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.code,
    super.details,
  });
}

// Firebase exceptions
class FirebaseException extends AppException {
  const FirebaseException({
    required super.message,
    super.code,
    super.details,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.details,
  });
}

// OneDrive exceptions
class OneDriveException extends AppException {
  const OneDriveException({
    required super.message,
    super.code,
    super.details,
  });
}

class UploadException extends AppException {
  const UploadException({
    required super.message,
    super.code,
    super.details,
  });
}

class DownloadException extends AppException {
  const DownloadException({
    required super.message,
    super.code,
    super.details,
  });
}

// Notification exceptions
class NotificationException extends AppException {
  const NotificationException({
    required super.message,
    super.code,
    super.details,
  });
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });
}

// Generic exceptions
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.details,
  });
}

class NotImplementedException extends AppException {
  const NotImplementedException({
    required super.message,
    super.code,
    super.details,
  });
}
