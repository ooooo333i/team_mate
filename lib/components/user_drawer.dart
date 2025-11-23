import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = profile;

    return Drawer(
      width: 280,
      child: SafeArea(
        child: user == null
            ? const Center(child: Text("로그인이 필요합니다."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(user["name"] ?? "이름 없음"),
                    subtitle: Text("학번: ${user["studentId"]}"),
                  ),
                  const Divider(),

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
                      (user["techStack"] as List<dynamic>?)
                              ?.take(3)
                              .join(", ") ??
                          "-",
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("한 줄 소개"),
                    subtitle: Text(user["simpleInfo"] ?? "-"),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/infosetting');
                      },
                      child: const Text("내 정보 수정하기"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}