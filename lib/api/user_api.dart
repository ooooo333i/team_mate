import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile.dart';

class UserApi {
  static Future<bool> saveProfile(UserProfile profile) async {
    try {
      final url = Uri.parse("http://136.114.213.101:8080/api/v1/member");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          
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