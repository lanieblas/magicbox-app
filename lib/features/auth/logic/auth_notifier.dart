import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/core/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.checking()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken != null && !_authService.isTokenExpired(accessToken)) {
      state = AuthState.authenticated(accessToken);
    } else {
      await logout();
    }
  }

  Future<void> login(String accessToken, String refreshToken) async {
    await _authService.saveToken(accessToken, refreshToken);
    state = AuthState.authenticated(accessToken);
  }

  Future<void> logout() async {
    await _authService.clearToken();
    state = const AuthState.unauthenticated();
  }
}