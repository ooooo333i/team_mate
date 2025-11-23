import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/theme/color_schemes.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await TokenStorage.getUserProfile();
    if (!mounted) return;
    setState(() {
      profile = data;
    });
  }

  Future<void> handleLogout() async {
    await TokenStorage.clearAll(); // 토큰, 프로필 모두 삭제
    if (!mounted) return;

    Navigator.pop(context); // Drawer 닫기
    Navigator.pushNamedAndRemoveUntil(context, '/loginpage', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = profile;

    return Drawer(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DrawerHeader + 오른쪽 상단 로그아웃 버튼
          // DrawerHeader 대신 Container 사용
          Container(
            height: 100, // 🔥 원하는 높이
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: lightColorScheme.secondary),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    user != null ? user["name"] ?? "사용자" : "로그인 필요",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (user != null)
                  Positioned(
                    right: 0,
                    top: 32,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: handleLogout,
                    ),
                  ),
              ],
            ),
          ),

          // 사용자 정보
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("전공"),
              subtitle: Text(user["major"] ?? "-"),
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text("학년"),
              subtitle: Text("${user["grade"] ?? "-"}"),
            ),
            ListTile(
              leading: const Icon(Icons.build_circle),
              title: const Text("기술 스택"),
              subtitle: Text(
                (user["techStack"] as List<dynamic>?)?.take(3).join(", ") ??
                    "-",
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("한 줄 소개"),
              subtitle: Text(user["simpleInfo"] ?? "-"),
            ),
          ],

          const Spacer(),

          // 내 정보 수정 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (user == null) {
                  Navigator.pushNamed(context, '/loginpage');
                } else {
                  Navigator.pushNamed(context, '/infosetting');
                }
              },
              child: Text(user == null ? "로그인하기" : "정보 수정하기"),
            ),
          ),
        ],
      ),
    );
  }
}
