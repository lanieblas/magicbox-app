class ConfigState {
  final bool isDarkMode;

  const ConfigState({required this.isDarkMode});

  ConfigState copyWith({bool? isDarkMode}) =>
      ConfigState(isDarkMode: isDarkMode ?? this.isDarkMode);

  factory ConfigState.initial() => const ConfigState(isDarkMode: false);
}
