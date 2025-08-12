import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/app/states/error_state.dart';
import 'package:magicbox_app/core/constants/route_names.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';
import 'package:magicbox_app/core/exceptions/error_handler.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ErrorState state = ref.watch(errorStateProvider);
    final AppException? error = state.error;
    final ErrorType type = (error != null) ? ErrorHandler.getErrorType(error) : ErrorType.unknown;
    final String message = error?.message ?? 'Ocurrió un error inesperado';

    IconData icon;
    Color color;

    switch (type) {
      case ErrorType.api:
        icon = Icons.bug_report;
        color = Colors.deepOrange;
        break;
      case ErrorType.network:
        icon = Icons.wifi_off;
        color = Colors.blueGrey;
        break;
      case ErrorType.validation:
        icon = Icons.rule;
        color = Colors.amber;
        break;
      case ErrorType.unauthorized:
        icon = Icons.lock_outline;
        color = Colors.redAccent;
        break;
      case ErrorType.forbidden:
        icon = Icons.block;
        color = Colors.redAccent;
        break;
      case ErrorType.timeout:
        icon = Icons.timer_off;
        color = Colors.purple;
        break;
      case ErrorType.cache:
        icon = Icons.sd_storage_rounded;
        color = Colors.teal;
        break;
      case ErrorType.unknown:
      default:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72, color: color),
              const SizedBox(height: 16),
              Text(
                _titleFor(type),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (error != null && error.statusCode != null) ...[
                const SizedBox(height: 8),
                Text('Código: ${error.statusCode}', style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Limpiar error y volver a Devices
                      ref.read(errorStateProvider.notifier).state = ErrorState.initial();
                      GoRouter.of(context).go(RouteNames.devices);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(errorStateProvider.notifier).state = ErrorState.initial();
                      GoRouter.of(context).go(RouteNames.login);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleFor(ErrorType type) {
    switch (type) {
      case ErrorType.api:
        return 'Error del servidor';
      case ErrorType.network:
        return 'Sin conexión';
      case ErrorType.validation:
        return 'Datos inválidos';
      case ErrorType.unauthorized:
        return 'No autorizado';
      case ErrorType.forbidden:
        return 'Acceso denegado';
      case ErrorType.timeout:
        return 'Tiempo de espera agotado';
      case ErrorType.cache:
        return 'Error de caché';
      case ErrorType.unknown:
      default:
        return 'Algo salió mal';
    }
  }
}
