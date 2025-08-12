import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> ensureBlePermissions() async {
    final requests = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // Android < 12
    ].request();
    return requests.values.every((s) => s.isGranted);
  }
}