import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/core/constants/route_names.dart';
import 'package:magicbox_app/features/auth/ui/confirm_otp_screen.dart';
import 'package:magicbox_app/features/auth/ui/login_screen.dart';
import 'package:magicbox_app/features/auth/ui/recover_password_screen.dart';
import 'package:magicbox_app/features/device/ui/device_screen.dart';
import 'package:magicbox_app/features/error/ui/error_screen.dart';
import 'package:magicbox_app/shared/layout/auth_layout.dart';
import 'package:magicbox_app/shared/layout/main_layout.dart';
import 'package:magicbox_app/shared/widgets/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.loading,
    routes: [
      GoRoute(
        path: RouteNames.loading,
        builder: (_, __) => const LoadingScreen(),
      ),

      ShellRoute(
        builder: (_, __, child) => AuthLayout(child: child),
        routes: [
          GoRoute(
            path: RouteNames.login,
            builder: (_, __) => const LoginScreen(),
          ),
          GoRoute(
            path: RouteNames.recoverPassword,
            builder: (_, __) => const RecoverPasswordScreen(),
          ),
          GoRoute(
            path: RouteNames.confirmOtp,
            builder: (_, __) => const ConfirmOtpScreen(),
          ),
        ],
      ),

      ShellRoute(
        builder: (_, __, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: RouteNames.devices,
            builder: (_, __) => const DeviceScreen(),
          ),
        ],
      ),

      GoRoute(
        path: RouteNames.error,
        builder: (_, __) => const ErrorScreen(),
      ),
    ],
    errorBuilder: (_, __) => const ErrorScreen(),
      redirect: (context, state) {
        if (authState.status == AuthStatus.checking) {
          if (state.matchedLocation != RouteNames.loading) {
            return RouteNames.loading;
          }
          return null;
        }

        final isAuth = authState.status == AuthStatus.authenticated;
        final isLoggingIn = state.matchedLocation == RouteNames.login;

        if (!isAuth && !isLoggingIn) {
          return RouteNames.login;
        }

        if (isAuth) {
          if (isLoggingIn || state.matchedLocation == RouteNames.loading) {
            return RouteNames.devices;
          }
        }

        return null;
      }
  );
});
