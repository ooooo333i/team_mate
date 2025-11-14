import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_mate/components/info_container.dart';

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
      final uri = Uri.parse('http://136.114.213.101:8080/api/v1/');
      final response = await http.get(uri);

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 본문: ${response.body}');

      if (!mounted) return; // 위젯이 트리에서 제거되었으면 종료

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          dataList = jsonData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버 응답 코드: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('❌ 서버 통신 오류: $e');
      if (!mounted) return; // 위젯이 사라졌으면 setState 호출 금지
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