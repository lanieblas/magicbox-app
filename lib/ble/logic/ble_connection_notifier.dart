import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/ble/data/ble_service.dart';

/// Provider global para conexiones BLE.
/// Depende de `bleServiceProvider` (definido en app/providers.dart).
final bleConnectionProvider =
StateNotifierProvider<BleConnectionNotifier, Set<String>>((ref) {
  return BleConnectionNotifier(ref.watch(bleServiceProvider));
});

/// Regla interna: SOLO UNA conexión activa a la vez.
class BleConnectionNotifier extends StateNotifier<Set<String>> {
  final BleService _bleService;
  BleConnectionNotifier(this._bleService) : super({});

  Future<void> connect(String deviceId) async {
    try {
      if (state.isNotEmpty && !state.contains(deviceId)) {
        // Desconecta el actual antes de conectar el nuevo
        final current = state.first;
        await _bleService.disconnectDevice(current);
        state = {};
      }
      await _bleService.connectToDevice(deviceId);
      state = {deviceId};
    } catch (_) {
      // (Opcional) reportar a ErrorState si quieres gestionar errores globales
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      await _bleService.disconnectDevice(deviceId);
      state = state.where((id) => id != deviceId).toSet();
    } catch (_) {}
  }

  /// Desconecta cualquier dispositivo activo.
  Future<void> disconnectAll() async {
    try {
      for (final id in state) {
        await _bleService.disconnectDevice(id);
      }
    } catch (_) {
      // swallow
    } finally {
      state = {};
    }
  }

  bool isConnected(String deviceId) => state.contains(deviceId);
}
