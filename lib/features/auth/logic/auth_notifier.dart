import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/app/states/error_state.dart';
import 'package:magicbox_app/core/exceptions/error_handler.dart';
import 'package:magicbox_app/core/services/auth_service.dart';
import 'package:magicbox_app/features/auth/data/auth_api.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final AuthApi _authApi;
  final Ref _ref;

  AuthNotifier(this._authService, this._authApi, this._ref) : super(const AuthState.checking()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final accessToken = await _authService.getAccessToken();
    final identityId = await _authService.getIdentityId();

    if (accessToken != null &&
        identityId != null &&
        !_authService.isTokenExpired(accessToken)) {
      state = AuthState.authenticated(accessToken);
      await _ref.read(userNotifierProvider.notifier).loadUserFromStorage();
    } else {
      await logout();
    }
  }

  Future<void> login(LoginResponse response) async {
    try {
      final user = response.user;
      await _authService.saveTokenAndUserData(
        user.accessToken,
        user.refreshToken,
        user.userId,
        user.identityId,
        user.firstName,
        user.lastName,
        user.email,
        user.imageUrl,
        user.userType,
      );
      state = AuthState.authenticated(user.accessToken);
      _ref.read(errorStateProvider.notifier).state = ErrorState.initial();

      // Cargar usuario localmente (desde almacenamiento)
      await _ref.read(userNotifierProvider.notifier).loadUserFromStorage();
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      _ref.read(errorStateProvider.notifier).state = ErrorState(hasError: true, error: error);
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _authService.getRefreshToken();

      if (refreshToken != null) {
        await _authApi.logout(refreshToken);
      }

      await _authService.clearToken();

      _ref.read(userNotifierProvider.notifier).clear();

      state = const AuthState.unauthenticated();
      _ref.read(errorStateProvider.notifier).state = ErrorState.initial();
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      _ref.read(errorStateProvider.notifier).state = ErrorState(hasError: true, error: error);
    }
  }
}