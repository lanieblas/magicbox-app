import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/core/services/auth_service.dart';

class User {
  final String userId;
  final String identityId;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String userType;

  User({
    required this.userId,
    required this.identityId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.userType,
  });
}

class UserNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  UserNotifier(this._authService) : super(null);

  Future<void> loadUserFromStorage() async {
    final userId = await _authService.getUserId();
    final identityId = await _authService.getIdentityId();
    final firstName = await _authService.getFirstName();
    final lastName = await _authService.getLastName();
    final email = await _authService.getEmail();
    final imageUrl = await _authService.getImageUrl();
    final userType = await _authService.getUserType();

    if (userId != null && identityId != null) {
      state = User(
        userId: userId,
        identityId: identityId,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        email: email ?? '',
        imageUrl: imageUrl ?? '',
        userType: userType ?? '',
      );
    } else {
      state = null;
    }
  }

  void clear() {
    state = null;
  }
}
