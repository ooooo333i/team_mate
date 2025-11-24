import 'package:flutter/material.dart';
import 'package:team_mate/routes/home.dart';
import 'package:team_mate/routes/info_page.dart';
import 'package:team_mate/routes/info_setting.dart';
import 'package:team_mate/routes/login_page.dart';
import 'package:team_mate/services/token_storage.dart';
import 'theme/app_theme.dart';
import 'routes/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await TokenStorage.getAccessToken();

  runApp(MyApp(initialRoute: token == null ? '/loginpage' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashPage(),

      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/home' : (context) => const Home(),
        '/loginpage': (context) => const LoginPage(),
        '/infosetting': (context) => const InfoSetting(),
        '/infopage': (context) => const InfoPage(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}