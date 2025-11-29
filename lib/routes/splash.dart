import 'package:flutter/material.dart';
import 'package:team_mate/theme/color_schemes.dart';
import 'package:team_mate/services/token_storage.dart';

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

    // ✅ 변경: MaterialPageRoute → pushNamedAndRemoveUntil (스택 정리)
    if (token != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/loginpage', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.secondary,
      body: Center(
        child: Text(
          'Team Mate',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}