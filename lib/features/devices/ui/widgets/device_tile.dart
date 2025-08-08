import 'package:flutter/material.dart';
import 'package:magicbox_app/core/models/ble_device.dart';

class DeviceTile extends StatelessWidget {
  final BleDevice device;
  final VoidCallback onTap;

  const DeviceTile({super.key, required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text('RSSI: ${device.rssi}'),
      trailing: Icon(device.isConnected ? Icons.bluetooth_connected : Icons.bluetooth),
      onTap: onTap,
    );
  }
}