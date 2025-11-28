import 'package:flutter/material.dart';
import 'package:team_mate/components/info_container.dart';
import 'package:team_mate/api/user_api.dart';
import 'package:team_mate/services/token_storage.dart';

class InfoListView extends StatefulWidget {
  final Map<String, dynamic>? filter;

  const InfoListView({
    super.key,
    this.filter,
  });

  @override
  State<InfoListView> createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  List<dynamic> profileList = [];
  List<dynamic> filteredList = [];
  bool isLoading = true;

  // ✅ 추가: 서버 코드 → 한글명 역매핑
  static const Map<String, String> majorCodeToName = {
    "CS": "컴퓨터공학과",
    "SW": "소프트웨어학과",
    "AIR": "AI로봇학과",
  };

  @override
  void initState() {
    super.initState();
    fetchServerData();
  }

  @override
  void didUpdateWidget(InfoListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      debugPrint('[InfoListView.didUpdateWidget] 필터 변경 감지');
      _applyFilter();
    }
  }

  Future<void> fetchServerData() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        debugPrint("[InfoListView] 토큰 없음 → 로그인 필요");
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/loginpage');
        return;
      }

      debugPrint("[InfoListView] 토큰: $token");

      final profiles = await UserApi.getAllProfiles(page: 0, size: 100);

      if (!mounted) return;

      if (profiles != null && profiles.isNotEmpty) {
        setState(() {
          profileList = profiles;
          isLoading = false;
        });
        _applyFilter();
        debugPrint("[InfoListView] 프로필 로드 성공: ${profiles.length}개");
        
        // ✅ 디버그: 실제 major 코드 출력
        for (var p in profiles) {
          debugPrint('[프로필] name: ${p['name']}, major: ${p['major']}');
        }
      } else {
        setState(() => isLoading = false);
        debugPrint("[InfoListView] 프로필 없음");
      }
    } catch (e) {
      debugPrint("[InfoListView] 서버 통신 오류: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("프로필 로드 실패: $e")),
      );
    }
  }

  void _applyFilter() {
    List<dynamic> temp = List.from(profileList);

    if (widget.filter != null) {
      final selectedMajor = widget.filter!['major'] ?? '전체';
      final selectedTech = (widget.filter!['tech'] ?? []) as List<dynamic>;

      debugPrint('[_applyFilter] 적용 중 - major: $selectedMajor, tech: $selectedTech');
      debugPrint('[_applyFilter] 전체 프로필: ${profileList.length}개');

      // 전공 필터 (서버 코드와 비교)
      if (selectedMajor != '전체') {
        // ✅ 변경: 한글명을 서버 코드로 변환해서 비교
        final majorCode = _getMajorCode(selectedMajor);
        debugPrint('[_applyFilter] 선택된 전공(한글): $selectedMajor → 서버 코드: $majorCode');
        
        temp = temp.where((p) {
          final serverMajor = p['major']?.toString() ?? '';
          final match = serverMajor == majorCode;
          if (!match) {
            debugPrint('[필터 제외] ${p['name']}: server major=$serverMajor (찾는 코드: $majorCode)');
          }
          return match;
        }).toList();
        debugPrint('[_applyFilter] 전공 필터 후: ${temp.length}개');
      }

      // 기술 스택 필터
      if (selectedTech.isNotEmpty) {
        temp = temp.where((p) {
          final techStack = (p['techStack'] ?? []) as List<dynamic>;
          final techStackStr = techStack.map((t) => t.toString().toUpperCase()).toList();
          final selectedTechUpper = selectedTech.map((t) => t.toString().toUpperCase()).toList();
          final hasAllTech = selectedTechUpper.every((tech) => techStackStr.contains(tech));
          
          if (!hasAllTech) {
            debugPrint('[필터 제외] ${p['name']}: techStack=$techStackStr (찾는 값: $selectedTechUpper)');
          }
          return hasAllTech;
        }).toList();
        debugPrint('[_applyFilter] 기술 필터 후: ${temp.length}개');
      }
    }

    setState(() {
      filteredList = temp;
    });
    debugPrint('[_applyFilter] 최종: ${filteredList.length}개');
  }

  // ✅ 추가: 한글명 → 서버 코드 변환
  String _getMajorCode(String majorName) {
    switch (majorName) {
      case "컴퓨터공학과":
        return "CS";
      case "소프트웨어학과":
        return "SW";
      case "AI로봇학과":
        return "AIR";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    
    final displayList = (widget.filter != null && filteredList.isEmpty && 
        (widget.filter!['major'] != '전체' || 
         (widget.filter!['tech'] as List).isNotEmpty))
        ? []
        : (filteredList.isNotEmpty ? filteredList : profileList);
    
    debugPrint('[build] displayList: ${displayList.length}개');
    
    if (displayList.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다'));
    }

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final student = displayList[index];
        
        // ✅ UI에 표시할 때는 한글명으로 변환
        final majorDisplay = majorCodeToName[student['major']] ?? student['major'] ?? '-';

        return InfoContainer(
          name: student['name'] ?? '',
          major: majorDisplay, // 한글명으로 표시
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
