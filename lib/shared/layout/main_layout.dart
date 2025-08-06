import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/app/providers.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(configProvider).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("MagicBox"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authNotifierProvider.notifier).logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dark mode'),
                    Switch(
                      value: isDark,
                      onChanged: (value) {
                        ref
                            .read(configProvider.notifier)
                            .toggleDarkMode(value);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            icon: const CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}