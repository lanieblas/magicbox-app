// lib/core/services/session_bootstrap.dart
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Intenta refrescar el access token al iniciar la app si:
/// - no hay access o está expirado
/// - hay refresh y NO está expirado
/// Devuelve true si dejó un access válido en storage.
Future<bool> tryRefreshOnLaunch({
  required Dio dio,
  required SecureStorageService storage,
}) async {
  try {
    final access = await storage.read(StorageKeys.accessToken);
    if (access != null && access.isNotEmpty && !JwtDecoder.isExpired(access)) {
      AppLogger.i('Bootstrap: access token still valid');
      return true;
    }

    final refresh = await storage.read(StorageKeys.refreshToken);
    if (refresh == null || refresh.isEmpty || JwtDecoder.isExpired(refresh)) {
      AppLogger.i('Bootstrap: no valid refresh token');
      return false;
    }

    AppLogger.i('Bootstrap: refreshing access via refresh token…');
    final res = await dio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refresh},
      options: Options(extra: {'skipAuth': true}),
    );

    final body = res.data;
    final data = (body is Map) ? body['data'] as Map? : null;
    final newAccess = data?['access_token'] as String?;
    final newRefresh = data?['refresh_token'] as String?;

    if (newAccess == null || newAccess.isEmpty) {
      AppLogger.w('Bootstrap refresh without access_token');
      return false;
    }

    await storage.write(StorageKeys.accessToken, newAccess);
    if (newRefresh != null && newRefresh.isNotEmpty) {
      await storage.write(StorageKeys.refreshToken, newRefresh);
    }

    AppLogger.i('Bootstrap: access refreshed OK');
    return true;
  } catch (e) {
    AppLogger.e('Bootstrap refresh failed: $e');
    return false;
  }
}
