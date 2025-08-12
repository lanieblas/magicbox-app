import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/ble/data/ble_service.dart';
import 'package:magicbox_app/ble/models/ble_device.dart';
import 'package:magicbox_app/core/logger/app_logger.dart';

class BleScanState {
  final List<BleDevice> devices;
  final bool isScanning;
  const BleScanState({required this.devices, required this.isScanning});

  BleScanState copyWith({List<BleDevice>? devices, bool? isScanning}) =>
      BleScanState(
        devices: devices ?? this.devices,
        isScanning: isScanning ?? this.isScanning,
      );

  static const idle = BleScanState(devices: <BleDevice>[], isScanning: false);
}

class BleScanNotifier extends StateNotifier<BleScanState> {
  final BleService _ble;
  StreamSubscription<BleDevice>? _sub;
  Timer? _timeout;

  BleScanNotifier(this._ble) : super(BleScanState.idle);

  bool get isScanning => state.isScanning;

  Future<void> startScan({Duration duration = const Duration(seconds: 12)}) async {
    if (state.isScanning) return;
    await _cancelScan(); // por seguridad si quedó algo pendiente
    state = const BleScanState(devices: <BleDevice>[], isScanning: true);

    _sub = _ble.scanForDevices().listen(
          (d) {
        final name = (d.name).trim();
        if (name.isEmpty || !name.toLowerCase().contains('magicbox')) return;

        final already = state.devices.any((e) => e.id == d.id);
        if (!already) {
          state = state.copyWith(devices: [...state.devices, d]);
        }
      },
      onError: (e, st) {
        AppLogger.e('BLE scan error: $e');
      },
      cancelOnError: false,
    );

    // Evitar escaneos infinitos
    _timeout = Timer(duration, () {
      stopScan();
    });
  }

  Future<void> stopScan() async {
    if (!state.isScanning) return;
    await _cancelScan();
    state = state.copyWith(isScanning: false);
  }

  Future<void> _cancelScan() async {
    _timeout?.cancel();
    _timeout = null;
    try {
      await _sub?.cancel();
    } catch (_) {}
    _sub = null;
    // Nota: no llamamos a _ble.stopScan() porque no existe; cancelar la suscripción alcanza.
  }

  @override
  void dispose() {
    _cancelScan();
    super.dispose();
  }
}

final bleScanProvider = StateNotifierProvider.autoDispose<BleScanNotifier, BleScanState>((ref) {
  final service = ref.read(bleServiceProvider);
  final notifier = BleScanNotifier(service);
  ref.onDispose(notifier.dispose);
  return notifier;
});
