import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/ble/logic/ble_connection_notifier.dart';
import 'package:magicbox_app/ble/logic/ble_scan_notifier.dart';
import 'package:magicbox_app/features/devices/ui/widgets/device_tile.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(bleScanProvider);
    final scanner = ref.read(bleScanProvider.notifier);
    final connectedDevices = ref.watch(bleConnectionProvider);

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
                final device = devices[index];
                final isConnected = connectedDevices.contains(device.id);
                return DeviceTile(
                  device: device,
                  isConnected: isConnected,
                  onTap: () async {
                    final notifier = ref.read(bleConnectionProvider.notifier);
                    if (isConnected) {
                      await notifier.disconnect(device.id);
                    } else {
                      await notifier.connect(device.id);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}