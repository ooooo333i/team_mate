// lib/services/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _temporaryTokenKey = 'temporary_token';
  static const _refreshTokenKey = 'refresh_token';
  static final _storage = FlutterSecureStorage();

  static Future<void> setTemporaryToken(String token) => _storage.write(key: _temporaryTokenKey, value: token);
  static Future<String?> getTemporaryToken() => _storage.read(key: _temporaryTokenKey);

  static Future<void> setAccessToken(String token) => _storage.write(key: _accessTokenKey, value: token);
  static Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  static Future<void> setRefreshToken(String token) => _storage.write(key: _refreshTokenKey, value: token);
  static Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  static Future<void> clearAll() => _storage.deleteAll();

  static Future<void> setUserProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userProfile');
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
}