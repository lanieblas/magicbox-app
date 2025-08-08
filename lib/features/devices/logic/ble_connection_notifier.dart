import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/core/services/ble_service.dart';

final bleConnectionProvider = StateNotifierProvider<BleConnectionNotifier, bool>((ref) {
  return BleConnectionNotifier(ref.watch(bleServiceProvider));
});

class BleConnectionNotifier extends StateNotifier<bool> {
  final BleService _bleService;
  BleConnectionNotifier(this._bleService) : super(false);

  Future<void> connect(String deviceId) async {
    try {
      await _bleService.connectToDevice(deviceId);
      state = true;
    } catch (_) {
      state = false;
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      await _bleService.disconnectDevice(deviceId);
      state = false;
    } catch (_) {
      // Ignore for now
    }
  }
}