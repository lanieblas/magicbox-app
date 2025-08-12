// lib/shared/layout/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:magicbox_app/app/providers.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(configProvider).isDarkMode;
    final user = ref.watch(userNotifierProvider);

    final imageUrl = (user?.imageUrl ?? '').trim();
    final hasUrl = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Image.asset(
              'assets/icons/ic_launcher.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'Magicbox',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menú',
            onSelected: (value) async {
              switch (value) {
                case 'toggle_theme':
                  await ref.read(configProvider.notifier).toggleDarkMode(!isDark);
                  break;
                case 'logout':
                  await ref.read(authNotifierProvider.notifier).logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'toggle_theme',
                child: Row(
                  children: [
                    const Icon(Icons.brightness_6, size: 18),
                    const SizedBox(width: 8),
                    Text(isDark ? 'Tema: Oscuro' : 'Tema: Claro'),
                    const Spacer(),
                    if (isDark) const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            icon: CircleAvatar(
              radius: 16,
              foregroundImage: hasUrl ? NetworkImage(imageUrl) : null,
              child: const Icon(Icons.person, size: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}
