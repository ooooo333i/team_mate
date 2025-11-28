import 'package:flutter/material.dart';
import 'package:team_mate/components/info_container.dart';
import 'package:team_mate/api/user_api.dart';
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
      final token = await TokenStorage.getAccessToken();

      if (token == null) {
        debugPrint('[LikedListview] 토큰 없음 → 로그인 필요');
        if (!mounted) return;
        setState(() => isLoading = false);
        Navigator.pushReplacementNamed(context, '/loginpage');
        return;
      }

      debugPrint('[LikedListview] 토큰: $token');

      // ✅ UserApi 사용 (401 처리 + 토큰 갱신 자동)
      final profile = await UserApi.getMyProfile();

      if (!mounted) return;

      if (profile != null) {
        setState(() {
          dataList = [profile.toJson()]; // UserProfile을 Map으로 변환
          isLoading = false;
        });
        debugPrint('[LikedListview] 프로필 로드 성공: ${profile.name}');
      } else {
        setState(() => isLoading = false);
        debugPrint('[LikedListview] 프로필 없음 (로그인 필요)');
        Navigator.pushReplacementNamed(context, '/loginpage');
      }
    } catch (e) {
      debugPrint('[LikedListview] 서버 통신 오류: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 로드 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataList.isEmpty) {
      return const Center(child: Text('프로필을 불러올 수 없습니다.'));
    }

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final student = dataList[index];
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
