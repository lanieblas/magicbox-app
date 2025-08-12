import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/ble/logic/ble_scan_notifier.dart';
import 'package:magicbox_app/ble/logic/ble_connection_notifier.dart';
import 'package:magicbox_app/features/devices/ui/widgets/device_tile.dart';
import 'package:magicbox_app/shared/widgets/loading_screen.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {

  @override
  void initState() {
    super.initState();
    // Arrancar el escaneo después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bleScanProvider.notifier).startScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(bleScanProvider);
    final connectedIds = ref.watch(bleConnectionProvider);

    final devices = scanState.devices;
    final isScanning = scanState.isScanning;

    if (isScanning && devices.isEmpty) {
      return const LoadingScreen();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(bleScanProvider.notifier).startScan();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: devices.isEmpty ? 1 : devices.length,
        itemBuilder: (context, index) {
          if (devices.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.bluetooth_searching, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'No hay Magicbox cercanos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isScanning
                        ? 'Escanenado...'
                        : 'Desliza hacia abajo para reintentar',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (!isScanning)
                    OutlinedButton.icon(
                      onPressed: () => ref.read(bleScanProvider.notifier).startScan(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                ],
              ),
            );
          }

          final d = devices[index];
          final isConnected = connectedIds.contains(d.id);
          return DeviceTile(
            device: d,
            isConnected: isConnected,
            onTap: () async {
              // Al conectar, detén el escaneo para cumplir la regla de 1 conexión
              await ref.read(bleScanProvider.notifier).stopScan();
              if (isConnected) {
                await ref.read(bleConnectionProvider.notifier).disconnect(d.id);
              } else {
                await ref.read(bleConnectionProvider.notifier).connect(d.id);
              }
            },
          );
        },
      ),
    );
  }
}
