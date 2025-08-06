import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/core/constants/storage_keys.dart';
import 'package:magicbox_app/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage secureStorage;
  final Ref ref;

  AuthInterceptor(this.secureStorage, this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.read(StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await secureStorage.clear();
      ref.read(authNotifierProvider.notifier).logout();
    }
    handler.next(err);
  }
}
