class ConfigState {
  final bool isDarkMode;
  final bool ready;

  const ConfigState({required this.isDarkMode, required this.ready});

  ConfigState copyWith({bool? isDarkMode, bool? ready}) =>
      ConfigState(isDarkMode: isDarkMode ?? this.isDarkMode, ready: ready ?? this.ready);

  factory ConfigState.initial() => const ConfigState(isDarkMode: false, ready: false);
}
