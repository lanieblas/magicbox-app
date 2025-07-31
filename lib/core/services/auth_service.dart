import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:magicbox_app/core/constants/storage_keys.dart';
import 'package:magicbox_app/core/storage/secure_storage_service.dart';

class AuthService {
  final SecureStorage _storage = SecureStorage();

  AuthService(Ref ref);

  Future<void> saveToken(String token, String refreshToken) async {
    await _storage.write(StorageKeys.accessToken, token);
    await _storage.write(StorageKeys.refreshToken, refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(StorageKeys.refreshToken);
  }

  Future<void> clearToken() async {
    await _storage.clear();
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}