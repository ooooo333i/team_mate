import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile.dart';
import '../services/token_storage.dart';

class UserApi {
  static Future<bool> saveProfile(UserProfile profile) async {
    try {
      final url = Uri.parse("http://136.114.213.101:8080/api/v1/member");

      // 토큰 가져오기 (임시 또는 액세스 토큰)
      final accessToken = await TokenStorage.getTemporaryToken() ?? 
                          await TokenStorage.getAccessToken();

      if (accessToken == null) {
        print("토큰 없음 → 로그인 필요");
        return false;
      }

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // 토큰 추가
        },
        body: jsonEncode(profile.toJson()),
      );

      print("회원 등록 응답 코드: ${response.statusCode}");
      print("회원 등록 응답 본문: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("회원 등록 실패: $e");
      return false;
    }
  }
}