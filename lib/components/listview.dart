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
  List<dynamic> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServerData();
  }

  Future<void> fetchServerData() async {
    try {
      final accessToken = await TokenStorage.getAccessToken();
      final temporaryToken = await TokenStorage.getTemporaryToken();
      final tokenToUse = accessToken ?? temporaryToken;

      if (tokenToUse == null) {
        debugPrint('토큰 없음 → 로그인 필요');
        setState(() => isLoading = false);
        Navigator.pushReplacementNamed(context, '/loginpage');
        return;
      }

      final uri = Uri.parse('http://136.114.213.101:8080/api/v1/member');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenToUse',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 본문: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          dataList = jsonData;
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // 토큰 만료/잘못됨 → 로그인 페이지로
        debugPrint("401 Unauthorized → 로그인 필요");
        setState(() => isLoading = false);
        Navigator.pushReplacementNamed(context, '/loginpage');
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버 응답 코드: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('서버 통신 오류: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버에 연결할 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (dataList.isEmpty) return const Center(child: Text('데이터 없음'));

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final student = dataList[index];
        return InfoContainer(
          name: student['name'] ?? '이름 없음',
          major: student['major'] ?? '-',
          task: student['task'] ?? '-',
          techStack: student['techStack'] ?? [],
          info: student['info'] ?? '정보 없음',
          isPublic: student['isPublic'] ?? true,
          onTap: () {
            Navigator.pushNamed(context, '/infopage');
          },
        );
      },
    );
  }
}