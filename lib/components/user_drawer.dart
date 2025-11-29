import 'package:flutter/material.dart';
import 'package:team_mate/services/token_storage.dart';
import 'package:team_mate/api/auth_api.dart';
import 'package:team_mate/theme/color_schemes.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

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
      isLoading = false;
    });
    debugPrint('[UserDrawer] 프로필 로드: ${data?['name']}');
  }

  Future<void> handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("로그아웃"),
        content: const Text("정말 로그아웃하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("로그아웃"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await AuthApi.logout();
    debugPrint('[UserDrawer] 서버 로그아웃: $success');

    if (!mounted) return;

    Navigator.pop(context); // Drawer 닫기
    // ✅ 변경: pushNamedAndRemoveUntil로 스택 정리
    Navigator.pushNamedAndRemoveUntil(context, '/loginpage', (route) => false);
  }

  // ✅ 학과 코드를 한글명으로 변환
  String _getMajorName(String? code) {
    switch (code) {
      case "CS":
        return "컴퓨터공학과";
      case "SW":
        return "소프트웨어학과";
      case "AIR":
        return "AI로봇학과";
      default:
        return code ?? "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = profile;

    return Drawer(
      width: 300,
      child: Column(
        children: [
          // ✅ 헤더: 사용자 정보 + 로그아웃 버튼
          Container(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16), // ✅ 변경: 24 → 80 (상단 패딩)
            decoration: BoxDecoration(
              color: lightColorScheme.secondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoading ? "로드 중..." : (user?["name"] ?? "사용자"),
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLoading ? "-" : (user?["studentId"]?.toString() ?? "-"),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ✅ 로그아웃 버튼
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: "로그아웃",
                      onPressed: handleLogout,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ✅ 사용자 정보 섹션
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else if (user != null)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  // 학과
                  _buildDrawerItem(
                    icon: Icons.school,
                    label: "학과",
                    value: _getMajorName(user["major"]),
                  ),
                  const Divider(height: 1),

                  // 학년
                  _buildDrawerItem(
                    icon: Icons.grade,
                    label: "학년",
                    value: "${user["grade"] ?? "-"}학년",
                  ),
                  const Divider(height: 1),

                  // 기술 스택
                  _buildDrawerItem(
                    icon: Icons.build_circle,
                    label: "기술",
                    value: (user["techStack"] as List<dynamic>?)?.join(", ") ?? "-",
                    multiline: true,
                  ),
                  const Divider(height: 1),

                  // 지원 분야
                  _buildDrawerItem(
                    icon: Icons.flag, // ✅ 변경: Icons.target → Icons.flag
                    label: "지원 분야",
                    value: user["applicationField"] ?? "-",
                  ),
                  const Divider(height: 1),

                  // 한 줄 소개
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    label: "소개",
                    value: user["simpleInfo"] ?? "-",
                    multiline: true,
                  ),
                  const Divider(height: 1),

                  // 연락처
                  _buildDrawerItem(
                    icon: Icons.mail,
                    label: "연락처",
                    value: user["contactInfo"] ?? "-",
                  ),
                  const Divider(height: 1),

                  // 공개 여부
                  _buildDrawerItem(
                    icon: Icons.visibility,
                    label: "공개 설정",
                    value: (user["visibility"] ?? false) ? "공개" : "비공개",
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      "로그인이 필요합니다",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

          const Spacer(),

          // ✅ 액션 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: Icon(user == null ? Icons.login : Icons.edit),
                    label: Text(user == null ? "로그인" : "정보 수정"),
                    onPressed: () {
                      Navigator.pop(context);
                      if (user == null) {
                        Navigator.pushNamed(context, '/loginpage');
                      } else {
                        Navigator.pushNamed(context, '/infosetting');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 헬퍼: Drawer 아이템 빌더
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: lightColorScheme.secondary),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        maxLines: multiline ? 3 : 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
