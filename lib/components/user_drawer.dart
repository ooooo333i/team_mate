import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.person, size: 40),
              title: Text("로그인 정보"),
              subtitle: Text("User ID: 20230001"),
            ),
            const Divider(),

            const ListTile(
              leading: Icon(Icons.mail),
              title: Text("Email"),
              subtitle: Text("minsu@example.com"),
            ),

            const ListTile(
              leading: Icon(Icons.school),
              title: Text("전공"),
              subtitle: Text("컴퓨터공학"),
            ),

            const Spacer(),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
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