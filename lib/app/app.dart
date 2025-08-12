import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/app/router.dart';
import 'package:magicbox_app/app/states/error_state.dart';
import 'package:magicbox_app/core/constants/route_names.dart';
import 'package:magicbox_app/shared/theme/app_theme.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final config = ref.watch(configProvider);

    ref.listen<ErrorState>(errorStateProvider, (prev, next) {
      if (next.hasError) {
        router.go(RouteNames.error);
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: config.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}