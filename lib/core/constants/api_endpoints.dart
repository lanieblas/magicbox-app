abstract class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.176:9000/api/v1.0';
  static const String login = '$baseUrl/identity/login';
  static const String logout = '$baseUrl/identity/logout';
  static const String userProfile = '$baseUrl/user';
}