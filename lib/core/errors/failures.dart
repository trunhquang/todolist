import 'package:todolist/core/errors/exceptions.dart';

// Base failure class
abstract class Failure {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'Failure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.code == code &&
        other.details == details;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode ^ details.hashCode;
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory TimeoutFailure.fromException(TimeoutException exception) {
    return TimeoutFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory AuthenticationFailure.fromException(AuthenticationException exception) {
    return AuthenticationFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory UnauthorizedFailure.fromException(UnauthorizedException exception) {
    return UnauthorizedFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory ForbiddenFailure.fromException(ForbiddenException exception) {
    return ForbiddenFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory InvalidInputFailure.fromException(InvalidInputException exception) {
    return InvalidInputFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Storage failures
class StorageFailure extends Failure {
  const StorageFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory StorageFailure.fromException(StorageException exception) {
    return StorageFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory BusinessFailure.fromException(BusinessException exception) {
    return BusinessFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory NotFoundFailure.fromException(NotFoundException exception) {
    return NotFoundFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory ConflictFailure.fromException(ConflictException exception) {
    return ConflictFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Firebase failures
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory FirebaseFailure.fromException(FirebaseException exception) {
    return FirebaseFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory DatabaseFailure.fromException(DatabaseException exception) {
    return DatabaseFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// OneDrive failures
class OneDriveFailure extends Failure {
  const OneDriveFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory OneDriveFailure.fromException(OneDriveException exception) {
    return OneDriveFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class UploadFailure extends Failure {
  const UploadFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory UploadFailure.fromException(UploadException exception) {
    return UploadFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class DownloadFailure extends Failure {
  const DownloadFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory DownloadFailure.fromException(DownloadException exception) {
    return DownloadFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Notification failures
class NotificationFailure extends Failure {
  const NotificationFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory NotificationFailure.fromException(NotificationException exception) {
    return NotificationFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory PermissionFailure.fromException(PermissionException exception) {
    return PermissionFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

// Generic failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory UnknownFailure.fromException(UnknownException exception) {
    return UnknownFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  factory NotImplementedFailure.fromException(NotImplementedException exception) {
    return NotImplementedFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}
