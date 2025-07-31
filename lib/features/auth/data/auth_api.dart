import 'package:dio/dio.dart';
import 'package:magicbox_app/core/constants/api_endpoints.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await dio.post(ApiEndpoints.login, data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }
}