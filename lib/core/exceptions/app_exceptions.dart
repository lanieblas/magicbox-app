class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

class ApiException extends AppException {
  ApiException(super.message, [super.statusCode]);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, 401);
}

class ForbiddenException extends AppException {
  ForbiddenException(String message) : super(message, 403);
}

class TimeoutException extends AppException {
  TimeoutException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class UnknownException extends AppException {
  UnknownException(super.message);
}

class BleException extends AppException {
  BleException(super.message, [super.statusCode]);
}