import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:magicbox_app/core/exceptions/app_exceptions.dart';
import 'package:magicbox_app/ble/models/ble_device.dart';

class BleService {
  final FlutterReactiveBle _ble;

  final Map<String, StreamSubscription<ConnectionStateUpdate>> _connections =
      {};

  BleService(this._ble);

  Stream<BleDevice> scanForDevices() {
    return _ble
        .scanForDevices(withServices: [])
        .where((device) {
          final name = device.name.toLowerCase();
          return name.contains('magicbox'.toLowerCase());
        })
        .map(
          (d) => BleDevice(
            id: d.id,
            name: d.name.isNotEmpty ? d.name : 'Unknown',
            rssi: d.rssi,
          ),
        );
  }

  Future<void> connectToDevice(String deviceId) async {
    try {
      final subscription = _ble
          .connectToDevice(id: deviceId)
          .listen(
            (update) {
              // Puedes manejar los estados aquí si deseas
            },
            onError: (e) {
              throw BleException('Connection error: $e');
            },
          );

      _connections[deviceId] = subscription;
    } catch (e) {
      throw BleException('Error connecting to device: $e');
    }
  }

  Future<void> disconnectDevice(String deviceId) async {
    try {
      await _connections[deviceId]?.cancel();
      _connections.remove(deviceId);
    } catch (e) {
      throw BleException('Error disconnecting from device: $e');
    }
  }

  Stream<BleStatus> observeStatus() => _ble.statusStream;
}
