import 'package:dio/dio.dart';
import 'package:magicbox_app/core/constants/api_endpoints.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post(ApiEndpoints.login, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Login failed';
      final code = e.response?.statusCode;
      throw ApiException(msg, code);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await dio.post(ApiEndpoints.logout, data: {'refresh_token': refreshToken});
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Logout failed';
      final code = e.response?.statusCode;
      throw ApiException(msg, code);
    }
  }
}

