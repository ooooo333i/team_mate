import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // 🔐 안전하게 JWT 저장
  final storage = const FlutterSecureStorage();

  Future<void> handleLogin() async {
    final studentId = studentIdController.text.trim();
    final password = passwordController.text.trim();

    if (studentId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("학번과 비밀번호를 입력하세요")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse("http://136.114.213.101:8080/api/v1/auth/login");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": studentId,
          "pw": password,
        }),
      );

      debugPrint("응답 코드: ${response.statusCode}");
      debugPrint("응답 본문: ${response.body}");

      if (!mounted) return;

      final responseData = jsonDecode(response.body);

      // 회원이 없는 경우
      if (responseData["status"] == "NOT_FOUND") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("회원 정보가 없습니다. 회원 정보를 입력해주세요.")),
        );
        Navigator.pushReplacementNamed(context, '/infosetting');
      }
      // 로그인 성공, 토큰이 있는 경우
      else if (response.statusCode == 200 && responseData["token"] != null) {
        final String token = responseData["token"];
        await storage.write(key: "jwt", value: token);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("로그인 성공!")));
        Navigator.pushReplacementNamed(context, '/home');
      }
      // 기타 실패
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 실패: ${responseData["message"] ?? '알 수 없는 오류'}")),
        );
      }
    } catch (e) {
      debugPrint("로그인 오류: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("서버와 통신할 수 없습니다.")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '개발자 프로필 로그인',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // 학번
              TextField(
                controller: studentIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '학번',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 비밀번호
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('로그인', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}