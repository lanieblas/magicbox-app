import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/ble/data/ble_service.dart';

final bleConnectionProvider = StateNotifierProvider<BleConnectionNotifier, Set<String>>((ref) {
  return BleConnectionNotifier(ref.watch(bleServiceProvider));
});

class BleConnectionNotifier extends StateNotifier<Set<String>> {
  final BleService _bleService;
  BleConnectionNotifier(this._bleService) : super({});

  Future<void> connect(String deviceId) async {
    try {
      await _bleService.connectToDevice(deviceId);
      state = {...state, deviceId};
    } catch (_) {
      // Aquí podrías agregar manejo de error si quieres
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      await _bleService.disconnectDevice(deviceId);
      state = state.where((id) => id != deviceId).toSet();
    } catch (_) {}
  }

  bool isConnected(String deviceId) => state.contains(deviceId);
}