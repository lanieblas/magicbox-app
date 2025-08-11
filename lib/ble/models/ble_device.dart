class BleDevice {
  final String id;
  final String name;
  final int rssi;
  final bool isConnected;

  BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.isConnected = false,
  });

  BleDevice copyWith({
    bool? isConnected,
  }) {
    return BleDevice(
      id: id,
      name: name,
      rssi: rssi,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}