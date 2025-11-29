import 'package:flutter/material.dart';
import 'package:team_mate/routes/home.dart';
import 'package:team_mate/routes/info_page.dart';
import 'package:team_mate/routes/info_setting.dart';
import 'package:team_mate/routes/login_page.dart';
import 'package:team_mate/routes/splash.dart';
import 'package:team_mate/services/token_storage.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // ✅ SplashPage부터 시작
      routes: {
        '/splash': (context) => const SplashPage(),
        '/': (context) => const Home(), // ✅ routes에만 정의
        '/loginpage': (context) => const LoginPage(),
        '/infosetting': (context) => const InfoSetting(),
        '/infopage': (context) => const InfoPage(),
      },
      // ❌ 제거: home 속성 제거 (routes의 '/'와 충돌)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}