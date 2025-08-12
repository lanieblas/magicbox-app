abstract class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.3:9000/api/v1.0';
  static const String login = '$baseUrl/identity/login';
  static const String logout = '$baseUrl/identity/logout';
  static const String refreshToken = '$baseUrl/identity/refresh-token';
  static const String userProfile = '$baseUrl/user';
}