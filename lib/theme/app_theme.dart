import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_theme.dart';

class AppTheme {
  // ☀️ 라이트 테마
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: Colors.grey[100],

    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 44, 126, 118),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    textTheme: appTextTheme,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 74, 177, 166),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  // 🌙 다크 테마
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: appTextTheme.apply(bodyColor: Colors.white),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}