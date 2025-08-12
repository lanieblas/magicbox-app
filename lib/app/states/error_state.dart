import 'package:flutter/material.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';

@immutable
class ErrorState {
  final bool hasError;
  final AppException? error;

  const ErrorState({required this.hasError, this.error});

  factory ErrorState.initial() => const ErrorState(hasError: false);

  /// Error de autorización por rol (gate)
  factory ErrorState.authRoleDenied() => ErrorState(
    hasError: true,
    // 403 semántico; usa tus excepciones tipadas ya existentes
    error: ForbiddenException('Tu perfil no tiene acceso a esta aplicación.'),
  );

  ErrorState copyWith({bool? hasError, AppException? error}) {
    return ErrorState(
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }
}
