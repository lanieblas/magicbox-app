import 'package:flutter/material.dart';
import 'package:magicbox_app/features/devices/ui/widgets/device_scan_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagicBox BLE',
      home: const DeviceScanPage(),
    );
  }
}

// class MainApp extends ConsumerWidget {
//   const MainApp({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final router = ref.watch(routerProvider);
//     final config = ref.watch(configProvider);
//
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: config.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       routerConfig: router,
//     );
//   }
// }