import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/app/states/error_state.dart';
import 'package:magicbox_app/core/exceptions/error_handler.dart';
import 'package:magicbox_app/core/services/auth_service.dart';
import 'package:magicbox_app/core/services/session_bootstrap.dart'; // ← sin alias
import 'package:magicbox_app/features/auth/data/auth_api.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';

// BLE: limpieza de sesión al salir
import 'package:magicbox_app/ble/logic/ble_scan_notifier.dart';
import 'package:magicbox_app/ble/logic/ble_connection_notifier.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final AuthApi _authApi;
  final Ref _ref;

  // Gate por rol (normalizado a minúsculas)
  static const _allowedRoles = {
    'admin',
    'maestro',
    'director',
    'super_admin', // incluimos para no bloquear tu caso real
  };

  AuthNotifier(this._authService, this._authApi, this._ref)
      : super(const AuthState.checking()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final access = await _authService.getAccessToken();
      final identityId = await _authService.getIdentityId();

      // Access válido -> autenticar, hidratar perfil y gate por rol
      if (access != null &&
          identityId != null &&
          !_authService.isTokenExpired(access)) {
        state = AuthState.authenticated(access);

        await _ref.read(userNotifierProvider.notifier).loadUserFromStorage();
        final user = _ref.read(userNotifierProvider);
        final userType = (user?.userType ?? '').trim().toLowerCase();

        if (userType.isNotEmpty && !_allowedRoles.contains(userType)) {
          await _authService.clearToken();
          _ref.read(userNotifierProvider.notifier).clear();
          state = const AuthState.unauthenticated();
          _ref.read(errorStateProvider.notifier).state =
              ErrorState.authRoleDenied();
          return;
        }
        return;
      }

      // Intento de refresh único al inicio (sin alias)
      final ok = await tryRefreshOnLaunch(
        dio: _ref.read(dioClientProvider).dio,
        storage: _ref.read(secureStorageProvider),
      );

      if (ok) {
        final newAccess = await _authService.getAccessToken();
        if (newAccess != null && !_authService.isTokenExpired(newAccess)) {
          state = AuthState.authenticated(newAccess);

          await _ref.read(userNotifierProvider.notifier).loadUserFromStorage();
          final user = _ref.read(userNotifierProvider);
          final userType = (user?.userType ?? '').trim().toLowerCase();

          if (userType.isNotEmpty && !_allowedRoles.contains(userType)) {
            await _authService.clearToken();
            _ref.read(userNotifierProvider.notifier).clear();
            state = const AuthState.unauthenticated();
            _ref.read(errorStateProvider.notifier).state =
                ErrorState.authRoleDenied();
            return;
          }
          return;
        }
      }

      // Sin sesión válida -> logout suave
      await logout();
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      _ref.read(errorStateProvider.notifier).state =
          ErrorState(hasError: true, error: error);
      state = const AuthState.unauthenticated();
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

      // Hidratar perfil y gate por rol
      await _ref.read(userNotifierProvider.notifier).loadUserFromStorage();
      final loaded = _ref.read(userNotifierProvider);
      final userType = (loaded?.userType ?? '').trim().toLowerCase();

      if (userType.isNotEmpty && !_allowedRoles.contains(userType)) {
        await _authService.clearToken();
        _ref.read(userNotifierProvider.notifier).clear();
        state = const AuthState.unauthenticated();
        _ref.read(errorStateProvider.notifier).state =
            ErrorState.authRoleDenied();
        return;
      }

      state = AuthState.authenticated(user.accessToken);
      _ref.read(errorStateProvider.notifier).state = ErrorState.initial();
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      _ref.read(errorStateProvider.notifier).state =
          ErrorState(hasError: true, error: error);
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> logout() async {
    try {
      // 1) Limpieza BLE
      _ref.read(bleScanProvider.notifier).stopScan();
      await _ref.read(bleConnectionProvider.notifier).disconnectAll();

      // 2) Backend logout (si hay refresh)
      final refreshToken = await _authService.getRefreshToken();
      if (refreshToken != null) {
        await _authApi.logout(refreshToken);
      }

      // 3) Limpiar sesión local
      await _authService.clearToken();
      _ref.read(userNotifierProvider.notifier).clear();

      state = const AuthState.unauthenticated();
      _ref.read(errorStateProvider.notifier).state = ErrorState.initial();
    } catch (e) {
      // Si falla el logout del backend, igualmente limpiamos localmente y notificamos.
      final error = ErrorHandler.handleError(e);
      _ref.read(errorStateProvider.notifier).state =
          ErrorState(hasError: true, error: error);
    }
  }
}
