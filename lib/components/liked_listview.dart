import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_mate/components/info_container.dart';
import 'package:team_mate/services/token_storage.dart';

class LikedListview extends StatefulWidget {
  const LikedListview({super.key});

  @override
  State<LikedListview> createState() => _LikedListviewState();
}

class _LikedListviewState extends State<LikedListview> {
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
        final decoded = json.decode(response.body);

        // 서버가 Map을 보내면 List로 감싸서 처리
        List<dynamic> jsonData;
        if (decoded is List) {
          jsonData = decoded;
        } else if (decoded is Map) {
          jsonData = [decoded];
        } else {
          jsonData = [];
        }

        setState(() {
          dataList = jsonData;
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataList.isEmpty) {
      return const Center(
        child: Text('서버에서 데이터를 불러올 수 없습니다.'),
      );
    }

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${student['name']} 클릭됨')),
            );
          },
        );
      },
    );
  }
}