import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';
import '../logger/app_logger.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors.dart';

class DioClient {
  DioClient({SecureStorageService? storage})
      : dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  ) {
    dio.interceptors.add(TrafficLogInterceptor());
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        storage: storage ?? SecureStorageService(),
      ),
    );
    AppLogger.i('DioClient initialized | baseUrl=${ApiEndpoints.baseUrl}');
  }

  final Dio dio;

  /// Opción alternativa, por si quieres este estilo.
  factory DioClient.create({SecureStorageService? storage}) =>
      DioClient(storage: storage);
}
