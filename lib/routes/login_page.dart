// lib/routes/login_page.dart
import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';
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

      // 신규 사용자 없음 처리 (서버가 NOT_FOUND 보내는 경우)
      if (body is Map<String, dynamic> && body["status"] == "NOT_FOUND") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("회원 정보가 없습니다. 회원 정보를 입력해주세요.")),
        );
        Navigator.pushReplacementNamed(context, '/infosetting');
        return;
      }

      // 서버가 200을 주고 headerAuth가 있을 때: 로그인 성공 흐름
      if (statusCode == 200 && headerAuth != null) {
        // headerAuth가 "Bearer ..." 를 포함할 수도, 아닐 수도 있음.
        // 저장은 headerAuth 그대로(또는 토큰만 저장) 해도 되지만, 일관성을 위해
        // 실제 저장할 값은 token 문자열(가능하면 Bearer 없이)으로 저장하자.
        String tokenToStore = headerAuth;
        // headerAuth가 "Bearer ..."이면 strip해서 raw token 저장
        if (headerAuth.startsWith("Bearer ")) {
          tokenToStore = headerAuth.substring(7);
        }

        // 저장
        await TokenStorage.setAccessToken(tokenToStore);

        // 로그인 직후 내 프로필 요청
        final profile = await AuthApi.getMemberProfile();
        if (profile != null) {
          await TokenStorage.setUserProfile(profile);
          debugPrint("프로필 저장 완료: ${profile['name']}");
        } else {
          // 프로필 못 가져오면 경고는 띄우지만 토큰은 저장되어 있으므로 홈에서 재시도 가능
          debugPrint("프로필을 가져오지 못했습니다. (null)");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 성공!")),
        );

        // 홈으로 라우팅 (루트는 '/'로 설정되어 있다고 가정)
        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      // 토큰은 header로 오지 않았지만 body에 인증 관련 정보만 있는 경우
      // 예: 인증은 되었으나 서버 흐름상 추가 처리가 필요한 케이스
      if (body is Map<String, dynamic> && (body["status"] == "OK" || statusCode == 200)) {
        // 시나리오에 따라 headerAuth가 없을 수 있음 — 이 경우 서버 설계 확인 필요
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"]?.toString() ?? "로그인 실패")),
        );
        return;
      }

      // 기타 실패
      String errMsg = "로그인 실패";
      if (body is Map<String, dynamic> && body["message"] != null) errMsg = body["message"].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errMsg)));
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
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: '학번',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('로그인', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}