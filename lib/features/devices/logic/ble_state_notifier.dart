import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/core/services/ble_service.dart';

final bleStateProvider = StateNotifierProvider<BleStateNotifier, BleStatus>((ref) {
  return BleStateNotifier(ref.watch(bleServiceProvider));
});

class BleStateNotifier extends StateNotifier<BleStatus> {
  final BleService _bleService;
  BleStateNotifier(this._bleService) : super(BleStatus.unknown) {
    _bleService.observeStatus().listen((status) => state = status);
  }
}