import 'package:dio/dio.dart';
import 'package:magicbox_app/core/constants/api_endpoints.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    final res = await _dio.post(
      ApiEndpoints.login,
      data: {
        'email': request.email,
        'password': request.password,
      },
      options: Options(extra: {'skipAuth': true}), // login no lleva bearer
    );

    final body = res.data;
    return LoginResponse.fromJson(body['data']);
  }

  /// Logout a nivel backend: NO debe llevar bearer ni gatillar refresh.
  Future<void> logout(String refreshToken) async {
    await _dio.post(
      ApiEndpoints.logout,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuth': true}),
    );
  }
}
