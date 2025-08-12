// lib/app/router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/app/states/auth_state.dart';

import 'package:magicbox_app/core/constants/route_names.dart';

import 'package:magicbox_app/features/auth/ui/login_screen.dart';
import 'package:magicbox_app/features/auth/ui/otp_verify_screen.dart';
import 'package:magicbox_app/features/auth/ui/password_confirm_screen.dart';
import 'package:magicbox_app/features/auth/ui/password_forgot_screen.dart';
import 'package:magicbox_app/features/devices/ui/devices_screen.dart';
import 'package:magicbox_app/features/error/ui/error_screen.dart';

import 'package:magicbox_app/shared/layout/auth_layout.dart';
import 'package:magicbox_app/shared/layout/main_layout.dart';
import 'package:magicbox_app/shared/widgets/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Importante: ver estado actual para re-evaluar redirect
  final auth = ref.watch(authNotifierProvider);
  final user = ref.watch(userNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.loading,
    routes: [
      GoRoute(
        path: RouteNames.loading,
        builder: (ctx, st) => const LoadingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (ctx, st) => const AuthLayout(child: LoginScreen()),
      ),
      GoRoute(
        path: RouteNames.otpVerify,
        builder: (ctx, st) => const AuthLayout(child: OtpVerifyScreen()),
      ),
      GoRoute(
        path: RouteNames.passwordForgot,
        builder: (ctx, st) => const AuthLayout(child: PasswordForgotScreen()),
      ),
      GoRoute(
        path: RouteNames.passwordConfirm,
        builder: (ctx, st) => const AuthLayout(child: PasswordConfirmScreen()),
      ),
      GoRoute(
        path: RouteNames.devices,
        builder: (ctx, st) => const MainLayout(child: DevicesScreen()),
      ),
      GoRoute(
        path: RouteNames.error,
        builder: (ctx, st) => const ErrorScreen(),
      ),
    ],
    redirect: (ctx, state) {
      final status = auth.status;
      final isAuth = status == AuthStatus.authenticated;
      final isChecking = status == AuthStatus.checking;

      // Mientras chequea tokens/refresh, siempre a /loading
      if (isChecking) {
        if (state.matchedLocation != RouteNames.loading) {
          return RouteNames.loading;
        }
        return null;
      }

      final isOnLogin = state.matchedLocation == RouteNames.login;

      // Gate por rol permitido una vez autenticado
      if (isAuth && user != null) {
        final t = (user.userType).trim().toLowerCase();
        const allowed = {'admin', 'maestro', 'director', 'super_admin'};
        if (t.isNotEmpty && !allowed.contains(t)) {
          return RouteNames.login;
        }
      }

      // No autenticado → permitir solo login
      if (!isAuth && !isOnLogin) {
        return RouteNames.login;
      }

      // Autenticado y está en login → mandarlo a devices
      if (isAuth && isOnLogin) {
        return RouteNames.devices;
      }

      // No cambiar
      return null;
    },
  );
});
