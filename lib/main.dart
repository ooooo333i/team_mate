import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // JSON 데이터 불러오기
  Future<List<dynamic>> loadUserData() async {
    final jsonString = await rootBundle.loadString('assets/data/data.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('JSON 테스트')),
        body: FutureBuilder<List<dynamic>>(
          future: loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('데이터 없음'));
            }

            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('전공: ${user['major']} / 역할: ${user['desiredRole']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
