import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/core/exceptions/api_exception.dart';
import 'package:magicbox_app/features/device/data/home_models.dart';

final deviceControllerProvider = FutureProvider<List<Device>>((ref) async {
  final dio = ref.read(dioClientProvider).dio;
  try {
    final response = await dio.get('/devices');

    final list = (response.data['data'] as List)
        .map((e) => Device.fromJson(e))
        .toList();

    return list;
  } on DioException catch (e) {
    final msg = e.response?.data['message'] ?? 'Error al obtener dispositivos';
    throw ApiException(msg, e.response?.statusCode);
  }
});
