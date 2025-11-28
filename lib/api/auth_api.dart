// lib/api/auth_api.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_mate/services/token_storage.dart';

class AuthApi {
  static const String baseUrl = "http://136.114.213.101:8080/api/v1";

  /// 로그인
  static Future<Map<String, dynamic>> login(String id, String pw) async {
    final uri = Uri.parse("$baseUrl/auth/login");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": id, "password": pw}),
    );

    debugPrint("[AuthApi.login] statusCode: ${response.statusCode}");
    debugPrint("[AuthApi.login] headers: ${response.headers}");
    debugPrint("[AuthApi.login] body: ${response.body}");

    String? authHeader = response.headers["authorization"] ?? response.headers["Authorization"];
    
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = {};
    }

    return {
      "statusCode": response.statusCode,
      "body": body,
      "tokenHeader": authHeader,
    };
  }

  /// 토큰 갱신 (GET /api/v1/auth/refresh)
  static Future<Map<String, dynamic>?> refreshAccessToken() async {
    final currentToken = await TokenStorage.getAccessToken();
    if (currentToken == null) return null;

    final uri = Uri.parse("$baseUrl/auth/refresh");
    final authHeader = currentToken.startsWith("Bearer ") ? currentToken : "Bearer $currentToken";

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
        },
      );

      debugPrint("[AuthApi.refresh] statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        String? newAuthHeader = response.headers["authorization"] ?? response.headers["Authorization"];
        
        if (newAuthHeader != null) {
          String newToken = newAuthHeader.startsWith("Bearer ") 
              ? newAuthHeader.substring(7) 
              : newAuthHeader;
          
          await TokenStorage.setAccessToken(newToken);
          return {"statusCode": 200, "newToken": newToken};
        }
      }
      return null;
    } catch (e) {
      debugPrint("[AuthApi.refresh] error: $e");
      return null;
    }
  }

  /// 본인 프로필 조회 (GET /api/v1/member)
  static Future<Map<String, dynamic>?> getMemberProfile() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) return null;

    final uri = Uri.parse("$baseUrl/member");
    final authHeader = token.startsWith("Bearer ") ? token : "Bearer $token";

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
        },
      );

      debugPrint("[AuthApi.getMemberProfile] statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body["detail"] is Map<String, dynamic>) {
          return body["detail"];
        }
        return body;
      } else if (response.statusCode == 401) {
        final refreshed = await refreshAccessToken();
        if (refreshed != null) {
          return getMemberProfile();
        }
        return null;
      }
      return null;
    } catch (e) {
      debugPrint("[AuthApi.getMemberProfile] error: $e");
      return null;
    }
  }

  /// 로그아웃 (POST /api/v1/auth/logout)
  static Future<bool> logout() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) return false;

    final uri = Uri.parse("$baseUrl/auth/logout");
    final authHeader = token.startsWith("Bearer ") ? token : "Bearer $token";

    try {
      final response = await http.post(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
        },
      );

      debugPrint("[AuthApi.logout] statusCode: ${response.statusCode}");

      await TokenStorage.clearAll();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("[AuthApi.logout] error: $e");
      await TokenStorage.clearAll();
      return false;
    }
  }
}