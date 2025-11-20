import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:team_mate/api/auth_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
      final result = await AuthApi.login(studentId, password);

      final statusCode = result["statusCode"];
      final responseData = result["body"];
      final rawBody = result["rawBody"];
      final token = result["token"]; // 헤더에서 읽음

      // 🔥🔥 로그인 출력 🔥🔥
      debugPrint("===== 로그인 API 응답 =====");
      debugPrint("Status Code: $statusCode");
      debugPrint("Raw Body: $rawBody");
      debugPrint("Parsed JSON: $responseData");
      debugPrint("Header Token: $token");
      debugPrint("==========================");

      if (!mounted) return;

      // ❗ 사용자가 회원가입 안 돼 있을 때
      if (responseData["status"] == "NOT_FOUND") {
        debugPrint("서버 응답: 사용자 없음 → info_setting 이동");

        Navigator.pushReplacementNamed(context, '/infosetting');
        return;
      }

      // ❗ 로그인 성공 — 서버가 Token을 Header로 전달
      if (statusCode == 200 && token != null) {
        debugPrint("발급된 토큰: $token");

        await storage.write(key: "jwt", value: token);
        await storage.write(key: "studentId", value: studentId);

        debugPrint("토큰 저장 완료");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 성공!")),
        );

        // 🔥 Home으로 이동
        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      // ❗ 그 외 실패
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: ${responseData["message"] ?? '알 수 없는 오류'}")),
      );
    } catch (e) {
      debugPrint("로그인 오류(EXCEPTION): $e");

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

              TextField(
                controller: studentIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '학번',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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