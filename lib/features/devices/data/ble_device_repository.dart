import 'package:magicbox_app/core/models/ble_device.dart';
import 'package:magicbox_app/core/services/ble_service.dart';

class BleDeviceRepository {
  final BleService _service;

  BleDeviceRepository(this._service);

  Stream<BleDevice> scanDevices() => _service.scanForDevices();
  Future<void> connect(String id) => _service.connectToDevice(id);
  Future<void> disconnect(String id) => _service.disconnectDevice(id);
  Stream observeStatus() => _service.observeStatus();
}