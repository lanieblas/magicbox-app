import 'package:flutter/material.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';
import 'package:magicbox_app/core/exceptions/error_handler.dart';

class ErrorScreen extends StatelessWidget {
  final AppException? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final errorType = error != null ? ErrorHandler.getErrorType(error!) : ErrorType.unknown;
    final message = error?.message ?? 'Unknown error occurred';

    IconData icon;
    Color color;

    switch (errorType) {
      case ErrorType.network:
        icon = Icons.wifi_off;
        color = Colors.orange;
        break;
      case ErrorType.unauthorized:
        icon = Icons.lock;
        color = Colors.red;
        break;
      case ErrorType.validation:
        icon = Icons.error_outline;
        color = Colors.amber;
        break;
      case ErrorType.forbidden:
        icon = Icons.block;
        color = Colors.redAccent;
        break;
      case ErrorType.timeout:
        icon = Icons.timer_off;
        color = Colors.deepOrange;
        break;
      case ErrorType.api:
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.error;
        color = Colors.grey;
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 96, color: color),
              const SizedBox(height: 24),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
