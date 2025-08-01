import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/auth_state.dart';
import 'package:magicbox_app/app/states/config/config_notifier.dart';
import 'package:magicbox_app/app/states/config/config_state.dart';
import 'package:magicbox_app/core/network/dio_client.dart';
import 'package:magicbox_app/core/services/auth_service.dart';
import 'package:magicbox_app/core/storage/preferences_storage.dart';
import 'package:magicbox_app/features/auth/logic/auth_notifier.dart';

final authServiceProvider = Provider((ref) => AuthService(ref));

final dioClientProvider = Provider((ref) => DioClient(ref));

final preferencesStorageProvider = Provider((ref) => PreferencesStorage());

final configProvider =
StateNotifierProvider<ConfigNotifier, ConfigState>((ref) =>
    ConfigNotifier(ref.watch(preferencesStorageProvider)));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(ref.watch(authServiceProvider)),
);