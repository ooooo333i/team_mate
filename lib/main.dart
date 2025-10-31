import 'package:flutter/material.dart';
import 'package:team_mate/routes/home.dart';
import 'package:team_mate/routes/info_page.dart';
import 'package:team_mate/routes/info_setting.dart';
import 'package:team_mate/routes/login_page.dart';
import 'theme/app_theme.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/',
      routes:{
        '/' : (context) => const Home(),
        '/loginpage': (context) => const LoginPage(),
        '/infosetting': (context) => const InfoSetting(),
        '/infopage' : (context) => InfoPage(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}