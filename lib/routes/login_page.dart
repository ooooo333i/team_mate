import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/api/auth_api.dart';
import 'package:team_mate/api/user_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    final id = studentIdController.text.trim();
    final pw = passwordController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("학번과 비밀번호를 입력하세요")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthApi.login(id, pw);

      final statusCode = result["statusCode"] as int;
      final body = result["body"];
      String? headerAuth = result["tokenHeader"] as String?;

      debugPrint("login() statusCode: $statusCode");
      debugPrint("login() headerAuth: $headerAuth");
      debugPrint("login() body: $body");

      if (!mounted) return;

      // 신규 사용자 없음 처리
      if (body is Map<String, dynamic> && body["status"] == "NOT_FOUND") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("등록되지 않은 사용자입니다")),
        );
        Navigator.pushReplacementNamed(context, '/infosetting');
        return;
      }

      // 로그인 성공
      if (statusCode == 200 && headerAuth != null) {
        // ✅ 토큰 저장
        await TokenStorage.setAccessToken(headerAuth);

        // ✅ 프로필 조회 및 저장
        final profile = await UserApi.getMyProfile();
        if (profile != null) {
          await TokenStorage.setUserProfile(profile.toJson());
          debugPrint("프로필 저장 완료: ${profile.name}");
        } else {
          debugPrint("프로필 조회 실패");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 성공")),
        );

        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      // 기타 실패
      String errMsg = "로그인 실패";
      if (body is Map<String, dynamic> && body["message"] != null) {
        errMsg = body["message"].toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errMsg)));
    } catch (e) {
      debugPrint("로그인 오류: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 오류: $e")),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  labelText: "학번",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: handleLogin,
                      child: const Text("로그인"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}