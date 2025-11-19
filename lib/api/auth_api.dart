import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "http://136.114.213.101:8080/api/v1";

  static Future<Map<String, dynamic>> login(String id, String pw) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "pw": pw}),
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }
}