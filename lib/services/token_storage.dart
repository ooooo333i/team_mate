import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _temporaryTokenKey = 'temporary_token';
  static const _refreshTokenKey = 'refresh_token';
  static final _storage = FlutterSecureStorage();

  
  // 임시 토큰
  static Future<void> setTemporaryToken(String token) =>
      _storage.write(key: _temporaryTokenKey, value: token);
  static Future<String?> getTemporaryToken() =>
      _storage.read(key: _temporaryTokenKey);

  // 액세스 토큰
  static Future<void> setAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);
  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  // 리프레시 토큰
  static Future<void> setRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);
  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  // 토큰 삭제 (로그아웃용)
  static Future<void> clearAll() => _storage.deleteAll();
}