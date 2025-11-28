// lib/api/user_api.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/model/user_profile.dart';
import 'package:team_mate/api/auth_api.dart';

class UserApi {
  static const String baseUrl = "http://136.114.213.101:8080/api/v1";

  /// 토큰에서 Authorization 헤더 생성
  static String _getAuthHeader(String token) {
    return token.startsWith("Bearer ") ? token : "Bearer $token";
  }

  /// 프로필 초기 등록 (POST /api/v1/member)
  /// - 신규 사용자가 처음 프로필을 만들 때 사용
  /// - accessToken 또는 temporaryToken 필요
  static Future<bool> initProfile(UserProfile profile) async {
    try {
      String? token = await TokenStorage.getAccessToken();
      token ??= await TokenStorage.getTemporaryToken();

      debugPrint("[UserApi.initProfile] token: $token");

      if (token == null) {
        debugPrint("[UserApi.initProfile] 토큰 없음");
        return false;
      }

      final authHeader = _getAuthHeader(token);
      final uri = Uri.parse("$baseUrl/member");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": authHeader,
        },
        body: jsonEncode(profile.toJson()),
      );

      debugPrint("[UserApi.initProfile] statusCode: ${response.statusCode}");
      debugPrint("[UserApi.initProfile] response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        // 토큰 만료 → 갱신 시도
        final refreshed = await AuthApi.refreshAccessToken();
        if (refreshed != null) {
          return initProfile(profile); // 재귀 호출
        }
      }
      return false;
    } catch (e) {
      debugPrint("[UserApi.initProfile] error: $e");
      return false;
    }
  }

  /// 프로필 수정 (PATCH /api/v1/member)
  /// - 기존 프로필을 수정할 때 사용
  /// - accessToken 필수
  static Future<bool> saveProfile(UserProfile profile) async {
    try {
      final token = await TokenStorage.getAccessToken();

      debugPrint("[UserApi.saveProfile] token: $token");

      if (token == null) {
        debugPrint("[UserApi.saveProfile] 토큰 없음");
        return false;
      }

      final authHeader = _getAuthHeader(token);
      final uri = Uri.parse("$baseUrl/member");

      final response = await http.patch(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": authHeader,
        },
        body: jsonEncode(profile.toJson()),
      );

      debugPrint("[UserApi.saveProfile] statusCode: ${response.statusCode}");
      debugPrint("[UserApi.saveProfile] response: ${response.body}");

      if (response.statusCode == 200) {
        // 로컬 프로필도 업데이트
        await TokenStorage.setUserProfile(profile.toJson());
        return true;
      } else if (response.statusCode == 401) {
        // 토큰 만료 → 갱신 시도
        final refreshed = await AuthApi.refreshAccessToken();
        if (refreshed != null) {
          return saveProfile(profile); // 재귀 호출
        }
      }
      return false;
    } catch (e) {
      debugPrint("[UserApi.saveProfile] error: $e");
      return false;
    }
  }

  /// 본인 프로필 조회 (GET /api/v1/member)
  static Future<UserProfile?> getMyProfile() async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token == null) {
        debugPrint("[UserApi.getMyProfile] 토큰 없음");
        return null;
      }

      final authHeader = _getAuthHeader(token);
      final uri = Uri.parse("$baseUrl/member");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
        },
      );

      debugPrint("[UserApi.getMyProfile] statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final detail = body["detail"] ?? body;

        if (detail is Map<String, dynamic>) {
          return _parseUserProfile(detail);
        }
      } else if (response.statusCode == 401) {
        final refreshed = await AuthApi.refreshAccessToken();
        if (refreshed != null) {
          return getMyProfile(); // 재귀 호출
        }
      }
      return null;
    } catch (e) {
      debugPrint("[UserApi.getMyProfile] error: $e");
      return null;
    }
  }

  /// 전체 프로필 조회 (GET /api/v1/profiles)
  /// - 다른 사용자 프로필 목록 조회
  static Future<List<Map<String, dynamic>>?> getAllProfiles({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token == null) {
        debugPrint("[UserApi.getAllProfiles] 토큰 없음");
        return null;
      }

      final authHeader = _getAuthHeader(token);
      final uri = Uri.parse("$baseUrl/profiles?page=$page&size=$size");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
        },
      );

      debugPrint("[UserApi.getAllProfiles] statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final detail = body["detail"];

        if (detail is Map<String, dynamic>) {
          final content = detail["content"];
          if (content is List) {
            return List<Map<String, dynamic>>.from(content);
          }
        }
      } else if (response.statusCode == 401) {
        final refreshed = await AuthApi.refreshAccessToken();
        if (refreshed != null) {
          return getAllProfiles(page: page, size: size); // 재귀 호출
        }
      }
      return null;
    } catch (e) {
      debugPrint("[UserApi.getAllProfiles] error: $e");
      return null;
    }
  }

  /// UserProfile 객체로 파싱
  static UserProfile _parseUserProfile(Map<String, dynamic> data) {
    return UserProfile(
      studentId: data["studentId"] ?? 0,
      name: data["name"] ?? data["username"] ?? "",
      major: data["major"] ?? "",
      grade: data["grade"] ?? 0,
      techStack: List<String>.from(data["techStack"] ?? []),
      applicationField: data["applicationField"] ?? "",
      simpleInfo: data["simpleInfo"] ?? "",
      contactInfo: data["contactInfo"] ?? "",
      additionalInfo: data["additionalInfo"] ?? "",
      visibility: data["visibility"] ?? true,
    );
  }
}

// ⬇️ AuthApi import 필요 (아래 참고)
// import 'package:team_mate/api/auth_api.dart';