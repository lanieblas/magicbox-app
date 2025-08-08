import 'package:dio/dio.dart';
import 'app_exceptions.dart';

enum ErrorType {
  api,
  network,
  validation,
  unauthorized,
  forbidden,
  timeout,
  cache,
  unknown,
}

class ErrorHandler {
  static AppException handleError(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return TimeoutException('Request timed out');
      }

      if (error.type == DioExceptionType.connectionError) {
        return NetworkException('No internet connection');
      }

      final statusCode = error.response?.statusCode ?? 0;
      final msg = error.response?.data['message'] ?? error.message;

      if (statusCode == 401) {
        return UnauthorizedException(msg);
      } else if (statusCode == 403) {
        return ForbiddenException(msg);
      } else if (statusCode >= 400 && statusCode < 600) {
        return ApiException(msg, statusCode);
      }

      return UnknownException(msg);
    }

    if (error is FormatException) {
      return ValidationException(error.message);
    }

    return UnknownException(error.toString());
  }

  static ErrorType getErrorType(AppException error) {
    if (error is ApiException) return ErrorType.api;
    if (error is NetworkException) return ErrorType.network;
    if (error is ValidationException) return ErrorType.validation;
    if (error is UnauthorizedException) return ErrorType.unauthorized;
    if (error is ForbiddenException) return ErrorType.forbidden;
    if (error is TimeoutException) return ErrorType.timeout;
    if (error is CacheException) return ErrorType.cache;
    return ErrorType.unknown;
  }
}