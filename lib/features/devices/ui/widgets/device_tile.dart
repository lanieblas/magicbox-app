import 'package:flutter/material.dart';
import 'package:magicbox_app/ble/models/ble_device.dart';


class DeviceTile extends StatelessWidget {
  final BleDevice device;
  final bool isConnected;
  final VoidCallback onTap;

  const DeviceTile({
    super.key,
    required this.device,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text('ID: ${device.id}  RSSI: ${device.rssi}'),
      trailing: Icon(isConnected ? Icons.bluetooth_connected : Icons.bluetooth),
      onTap: onTap,
    );
  }
}