import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_mate/components/info_container.dart';
import 'package:team_mate/services/token_storage.dart';

class InfoListView extends StatefulWidget {
  const InfoListView({super.key});

  @override
  State<InfoListView> createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  List<dynamic> profileList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServerData();
  }

  Future<void> fetchServerData() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        Navigator.pushReplacementNamed(context, '/loginpage');
        return;
      }

      final uri = Uri.parse('http://136.114.213.101:8080/api/v1/profiles');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("응답 코드: ${response.statusCode}");
      debugPrint("응답 본문: ${response.body}");

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // 🔥 핵심: detail → content 까지 들어가서 List 추출
        final contentList = decoded["detail"]?["content"];

        if (contentList is List) {
          setState(() {
            profileList = contentList;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }

        return;
      }

      // 토큰 만료
      if (response.statusCode == 401) {
        Navigator.pushReplacementNamed(context, '/loginpage');
        return;
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("서버 통신 오류: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (profileList.isEmpty) return const Center(child: Text('데이터 없음'));

    return ListView.builder(
      itemCount: profileList.length,
      itemBuilder: (context, index) {
        final student = profileList[index];

        return InfoContainer(
          name: student['name'] ?? '',
          major: student['major'] ?? '-',
          grade: student['grade'] ?? 0,
          applicationField: student['applicationField'] ?? '-',
          techStack: student['techStack'] ?? [],
          simpleInfo: student['simpleInfo'] ?? '',
          onTap: () {
            Navigator.pushNamed(context, '/infopage', arguments: student);
          },
        );
      },
    );
  }
}
