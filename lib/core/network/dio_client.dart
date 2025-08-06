import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/core/constants/api_endpoints.dart';
import 'package:magicbox_app/core/network/interceptors.dart';
import 'package:magicbox_app/core/storage/secure_storage_service.dart';

class DioClient {
  final Dio dio;

  DioClient(Ref ref)
      : dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  )) {
    dio.interceptors.add(AuthInterceptor(SecureStorage(), ref));
  }
}