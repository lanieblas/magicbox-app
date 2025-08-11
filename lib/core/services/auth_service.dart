import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:magicbox_app/core/constants/storage_keys.dart';
import 'package:magicbox_app/core/logger/app_logger.dart';
import 'package:magicbox_app/core/storage/secure_storage_service.dart';

class AuthService {
  final SecureStorage _storage = SecureStorage();

  AuthService(Ref ref);

  Future<void> saveTokenAndUserData(String accessToken,
      String refreshToken,
      String userId,
      String identityId,
      String firstName,
      String lastName,
      String email,
      String imageUrl,
      String userType,) async {
    await Future.wait([
      _storage.write(StorageKeys.accessToken, accessToken),
      _storage.write(StorageKeys.refreshToken, refreshToken),
      _storage.write(StorageKeys.userId, userId),
      _storage.write(StorageKeys.identityId, identityId),
      _storage.write(StorageKeys.firstName, firstName),
      _storage.write(StorageKeys.lastName, lastName),
      _storage.write(StorageKeys.email, email),
      _storage.write(StorageKeys.imageUrl, imageUrl),
      _storage.write(StorageKeys.userType, userType),
    ]);

    AppLogger.d('Loaded Identity and User data to Secure Storage, UserId: $userId, IdentityId: $identityId');
  }

  Future<String?> getAccessToken() async =>
      await _storage.read(StorageKeys.accessToken);

  Future<String?> getRefreshToken() async =>
      await _storage.read(StorageKeys.refreshToken);

  Future<String?> getUserId() async => await _storage.read(StorageKeys.userId);

  Future<String?> getIdentityId() async =>
      await _storage.read(StorageKeys.identityId);

  Future<String?> getFirstName() async =>
      await _storage.read(StorageKeys.firstName);

  Future<String?> getLastName() async =>
      await _storage.read(StorageKeys.lastName);

  Future<String?> getEmail() async => await _storage.read(StorageKeys.email);

  Future<String?> getImageUrl() async =>
      await _storage.read(StorageKeys.imageUrl);

  Future<String?> getUserType() async =>
      await _storage.read(StorageKeys.userType);

  Future<void> clearToken() async {
    await _storage.clear();
  }

  bool isTokenExpired(String token) => JwtDecoder.isExpired(token);
}
