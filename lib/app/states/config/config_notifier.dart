import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/states/config/config_state.dart';
import 'package:magicbox_app/core/constants/preferences_keys.dart';
import 'package:magicbox_app/core/storage/preferences_storage.dart';

class ConfigNotifier extends StateNotifier<ConfigState> {
  final PreferencesStorage _storage;

  ConfigNotifier(this._storage) : super(ConfigState.initial()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final isDark = await _storage.getBool(PreferencesKeys.themeMode) ?? false;
    state = state.copyWith(isDarkMode: isDark);
  }

  Future<void> toggleDarkMode(bool value) async {
    await _storage.setBool(PreferencesKeys.themeMode, value);
    state = state.copyWith(isDarkMode: value);
  }
}
