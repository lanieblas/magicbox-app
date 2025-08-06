class Device {
  final String id;
  final String name;
  final String status;

  Device({required this.id, required this.name, required this.status});

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    status: json['status'] ?? '',
  );
}
