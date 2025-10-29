import 'package:flutter/material.dart';
import 'package:team_mate/route/home.dart';
import 'package:team_mate/route/info_page.dart';
import 'package:team_mate/route/info_setting.dart';
import 'package:team_mate/route/login_page.dart';

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
    );
  }
}