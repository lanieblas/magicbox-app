import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/features/devices/logic/ble_scan_notifier.dart';
import 'package:magicbox_app/features/devices/ui/widgets/device_tile.dart';

class DeviceScanPage extends ConsumerWidget {
  const DeviceScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(bleScanProvider);
    final scanner = ref.read(bleScanProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos Bluetooth')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => scanner.startScan(),
            child: const Text('Escanear'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceTile(
                  device: devices[index],
                  onTap: () => {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}