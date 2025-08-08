import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/app/states/config/config_notifier.dart';
import 'package:magicbox_app/app/states/config/config_state.dart';
import 'package:magicbox_app/app/states/error_state.dart';
import 'package:magicbox_app/core/network/dio_client.dart';
import 'package:magicbox_app/core/services/auth_service.dart';
import 'package:magicbox_app/core/services/ble_service.dart';
import 'package:magicbox_app/core/storage/preferences_storage.dart';
import 'package:magicbox_app/features/auth/data/auth_api.dart';
import 'package:magicbox_app/features/auth/logic/auth_notifier.dart';
import 'package:magicbox_app/features/user/logic/user_notifier.dart';

final authServiceProvider = Provider((ref) => AuthService(ref));

final dioClientProvider = Provider((ref) => DioClient(ref));

final preferencesStorageProvider = Provider((ref) => PreferencesStorage());

final configProvider =
StateNotifierProvider<ConfigNotifier, ConfigState>((ref) =>
    ConfigNotifier(ref.watch(preferencesStorageProvider)));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(
    ref.watch(authServiceProvider),
    ref.watch(authApiProvider),
    ref,
  ),
);

final authApiProvider = Provider((ref) => AuthApi(ref.watch(dioClientProvider).dio));

final errorStateProvider = StateProvider<ErrorState>((ref) => ErrorState.initial());

final userNotifierProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserNotifier(authService);
});

final flutterReactiveBleProvider = Provider<FlutterReactiveBle>((ref) => FlutterReactiveBle());
final bleServiceProvider = Provider<BleService>((ref) => BleService(ref.watch(flutterReactiveBleProvider)));