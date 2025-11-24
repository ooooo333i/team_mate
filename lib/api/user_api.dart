// lib/api/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/model/user_profile.dart';

class UserApi {
  static const String baseUrl = "http://136.114.213.101:8080/api/v1";

  // 회원 등록 (프로필 저장) - 토큰 필요(임시 토큰 또는 access token)
  static Future<bool> saveProfile(UserProfile profile) async {
    try {
      // 우선 accessToken, 없으면 temporaryToken 사용
      String? token = await TokenStorage.getAccessToken();
      token ??= await TokenStorage.getTemporaryToken();
      print("사용할 토큰: $token");
      if (token == null) {
        // 토큰이 없으면 false
        return false;
      }

      final authHeader = token.startsWith("Bearer ") ? token : "Bearer $token";

      final response = await http.patch(
        Uri.parse("$baseUrl/member"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authHeader,
        },
        body: jsonEncode(profile.toJson()),
      );

      print("회원 등록 응답 코드: ${response.statusCode}");
      print("회원 등록 응답: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("회원 등록 실패: $e");
      return false;
    }
  }
}