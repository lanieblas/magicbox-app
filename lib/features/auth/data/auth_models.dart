import 'models/auth_user.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class LoginResponse {
  final AuthUser user;

  LoginResponse({required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final authUser = AuthUser.fromJson(data);
    return LoginResponse(user: authUser);
  }
}
