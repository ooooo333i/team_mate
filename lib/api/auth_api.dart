// lib/api/auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:team_mate/services/token_storage.dart';

class AuthApi {
  // 서버 주소로 바꿔줘 (끝에 /api/v1 까지 포함)
  static const String baseUrl = "http://136.114.213.101:8080/api/v1";

  /// 로그인: 서버 응답(body)을 파싱해서 Map으로 반환.
  /// 또한 Response header의 authorization 값을 읽어 "token" 항목으로 반환함.
  static Future<Map<String, dynamic>> login(String id, String pw) async {
    final uri = Uri.parse("$baseUrl/auth/login");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      // 서버가 문자열로 받길 원하면 id/pw 모두 String으로 전달 (텍스트필드에서 문자열)
      body: jsonEncode({"studentId": id, "password": pw}),
    );

    // header에서 authorization 읽음 (있으면 사용)
    String? rawAuth = response.headers["authorization"];

    // 일부 서버는 'Authorization' 대신 다른 케이스로 줄 수 있으니 fallback 검사
    rawAuth ??= response.headers["Authorization"];

    // 만약 header에 "Bearer ..."가 아닌 토큰만 담겨있으면 나중에 처리하도록 그대로 둠.
    // (저장 시에는 그대로 저장하고, 요청 보낼 때 앞에 Bearer 붙여서 보냄.)

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = response.body;
    }

    return {
      "statusCode": response.statusCode,
      "tokenHeader": rawAuth, // header에 있는 인증 헤더 (null 가능)
      "body": body, // 파싱된 body (Map 또는 String)
    };
  }

  /// /member (내 프로필) 정보 가져오기
  /// - TokenStorage.getAccessToken()에서 꺼낸 값을 사용
  /// - 항상 Map<String,dynamic>? 형태로 반환 (detail이 Map이면 detail 반환)
  /// - 실패(401 등)는 null 반환
  static Future<Map<String, dynamic>?> getMemberProfile() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) return null;

    // token이 "Bearer ..."로 이미 저장되었는지 확인 후 header 값 생성
    final authHeader = token.startsWith("Bearer ") ? token : "Bearer $token";

    final uri = Uri.parse("$baseUrl/member");
    final response = await http.get(
      uri,
      headers: {
        "Authorization": authHeader,
        "Content-Type": "application/json",
      },
    );

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      // body가 JSON이 아니면 로그 찍고 null 반환
      print("AuthApi.getMemberProfile: JSON 디코드 실패 -> ${response.body}");
      return null;
    }

    if (decoded is Map<String, dynamic>) {
      final detail = decoded["detail"];
      // detail이 Map이면 실제 프로필
      if (detail is Map<String, dynamic>) {
        return detail;
      }
      // 서버가 에러 메시지(문자열)를 detail에 담으면 null 반환 (401 등)
      return null;
    }

    return null;
  }
}