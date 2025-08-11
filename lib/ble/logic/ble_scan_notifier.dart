import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/ble/models/ble_device.dart';
import 'package:magicbox_app/ble/data/ble_service.dart';

final bleScanProvider = StateNotifierProvider<BleScanNotifier, List<BleDevice>>((ref) {
  return BleScanNotifier(ref.watch(bleServiceProvider));
});

class BleScanNotifier extends StateNotifier<List<BleDevice>> {
  final BleService _bleService;
  BleScanNotifier(this._bleService) : super([]);

  void startScan() {
    state = [];
    _bleService.scanForDevices().listen((device) {
      if (!state.any((d) => d.id == device.id)) {
        state = [...state, device];
      }
    });
  }
}