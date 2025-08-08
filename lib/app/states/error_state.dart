import 'package:flutter/material.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';

@immutable
class ErrorState {
  final bool hasError;
  final AppException? error;

  const ErrorState({required this.hasError, this.error});

  factory ErrorState.initial() => const ErrorState(hasError: false);

  ErrorState copyWith({bool? hasError, AppException? error}) {
    return ErrorState(
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }
}