import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Logs de tráfico HTTP (simple y alineado con AppLogger.i/w/e)
class TrafficLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i(
        'HTTP → ${options.method} ${options.baseUrl}${options.path} '
            '| query=${options.queryParameters} '
            '| data=${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i(
        'HTTP ← ${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path} '
            '| data=${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ro = err.requestOptions;
    AppLogger.e(
        'HTTP ✖ ${ro.method} ${ro.baseUrl}${ro.path} '
            '| status=${err.response?.statusCode} '
            '| msg=${err.message} '
            '| data=${err.response?.data}');
    handler.next(err);
  }
}

/// Interceptor que agrega Authorization y maneja refresh en 401.
/// Usa Options(extra: {'skipAuth': true}) para saltarse auth (login/refresh).
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorageService _storage;

  Completer<void>? _refreshing; // mutex

  AuthInterceptor({
    required Dio dio,
    required SecureStorageService storage,
  })  : _dio = dio,
        _storage = storage;

  bool _shouldSkipAuth(RequestOptions opts) {
    final extra = opts.extra;
    final skip = extra['skipAuth'] == true;
    final isRefresh = opts.path.endsWith(ApiEndpoints.refreshToken);
    return skip || isRefresh;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (_shouldSkipAuth(options)) return handler.next(options);

      final access = await _storage.read(StorageKeys.accessToken);
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
      handler.next(options);
    } catch (_) {
      handler.next(options); // no bloquear
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final opts = err.requestOptions;
    final status = err.response?.statusCode ?? 0;

    if (status != 401 || _shouldSkipAuth(opts)) {
      return handler.next(err);
    }

    try {
      // Garantizar refresh único
      if (_refreshing != null) {
        await _refreshing!.future; // esperar refresh en curso
      } else {
        _refreshing = Completer<void>();
        final ok = await _refreshTokens();
        _refreshing!.complete();
        _refreshing = null;

        if (!ok) {
          await _clearSession();
          return handler.next(err);
        }
      }

      // Reintentar request original con nuevo access
      final newAccess = await _storage.read(StorageKeys.accessToken);
      if (newAccess == null || newAccess.isEmpty) {
        return handler.next(err);
      }

      final RequestOptions r = opts;
      final Options newOptions = Options(
        method: r.method,
        headers: {
          ...r.headers,
          'Authorization': 'Bearer $newAccess',
        },
        responseType: r.responseType,
        contentType: r.contentType,
        listFormat: r.listFormat,
        followRedirects: r.followRedirects,
        validateStatus: r.validateStatus,
        sendTimeout: r.sendTimeout,
        receiveTimeout: r.receiveTimeout,
        receiveDataWhenStatusError: r.receiveDataWhenStatusError,
        extra: r.extra,
      );

      final response = await _dio.request(
        r.path,
        data: r.data,
        queryParameters: r.queryParameters,
        options: newOptions,
        cancelToken: r.cancelToken,
        onReceiveProgress: r.onReceiveProgress,
        onSendProgress: r.onSendProgress,
      );

      return handler.resolve(response);
    } catch (e) {
      AppLogger.e('AuthInterceptor retry failed: $e');
      return handler.next(err);
    }
  }

  Future<bool> _refreshTokens() async {
    try {
      final refresh = await _storage.read(StorageKeys.refreshToken);
      if (refresh == null || refresh.isEmpty) {
        AppLogger.w('Refresh: no refresh token');
        return false;
      }
      if (JwtDecoder.isExpired(refresh)) {
        AppLogger.w('Refresh: refresh token expired');
        return false;
      }

      AppLogger.i('Refreshing access token…');
      final res = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refresh},
        options: Options(extra: {'skipAuth': true}),
      );

      final body = res.data;
      final data = (body is Map) ? body['data'] as Map? : null;
      final newAccess = data?['access_token'] as String?;
      final newRefresh = data?['refresh_token'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        AppLogger.w('Refresh response without access_token');
        return false;
      }

      await _storage.write(StorageKeys.accessToken, newAccess);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await _storage.write(StorageKeys.refreshToken, newRefresh);
      }

      AppLogger.i('Access token refreshed');
      return true;
    } catch (e) {
      AppLogger.e('Refresh token failed: $e');
      return false;
    }
  }

  Future<void> _clearSession() async {
    await _storage.delete(StorageKeys.accessToken);
    await _storage.delete(StorageKeys.refreshToken);
  }
}
