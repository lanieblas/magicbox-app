class AuthUser {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String identityId;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String userType;

  AuthUser({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.identityId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.userType,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      userId: json['user_id'],
      identityId: json['identity_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      imageUrl: json['image_url'],
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_id': userId,
      'identity_id': identityId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'image_url': imageUrl,
      'user_type': userType,
    };
  }
}