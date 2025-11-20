import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String studentId = '';
  String email = '';
  String major = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    // 저장된 정보 불러오기
    //final storedId = await TokenStorage.getStudentId(); // 새로 추가 필요
    //final storedEmail = await TokenStorage.getEmail();   // 새로 추가 필요
    //final storedMajor = await TokenStorage.getMajor();   // 새로 추가 필요

    if (!mounted) return;
/*
    setState(() {
      studentId = storedId ?? '';
      email = storedEmail ?? '';
      major = storedMajor ?? '';
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: const Text("로그인 정보"),
              subtitle: Text("User ID: $studentId"),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.mail),
              title: const Text("Email"),
              subtitle: Text(email.isNotEmpty ? email : '-'),
            ),

            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("전공"),
              subtitle: Text(major.isNotEmpty ? major : '-'),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pop(context); // Drawer 닫기
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