import 'package:flutter/material.dart';
import 'package:team_mate/theme/color_schemes.dart';
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/routes/home.dart';
import 'package:team_mate/routes/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    goNext();
  }

  Future<void> goNext() async {
    // 1초 대기
    await Future.delayed(const Duration(seconds: 1));

    // 토큰 확인 후 이동
    final token = await TokenStorage.getAccessToken();
    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.secondary, // 테마 색
      body: Center(
        child: Text(
          'Team Mate', // 가운데 제목
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}