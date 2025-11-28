import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    // ✅ 이전 화면에서 전달받은 데이터
    final student = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("정보")),
        body: const Center(child: Text("데이터 없음")),
      );
    }

    debugPrint('[InfoPage] 받은 데이터: $student');

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 정보"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 기본 정보 섹션
            _buildSection(
              title: "기본 정보",
              children: [
                _buildInfoRow("이름", student['name'] ?? '-'),
                _buildInfoRow("학번", student['studentId']?.toString() ?? '-'),
                _buildInfoRow("학과", student['major'] ?? '-'),
                _buildInfoRow("학년", student['grade']?.toString() ?? '-'),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ 기술 스택 섹션
            _buildSection(
              title: "기술 스택",
              children: [
                _buildTechStackChips(student['techStack'] ?? []),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ 지원 분야 섹션
            _buildSection(
              title: "지원 분야",
              children: [
                _buildInfoRow("분야", student['applicationField'] ?? '-'),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ 상세 정보 섹션
            _buildSection(
              title: "상세 정보",
              children: [
                _buildDetailBox("간단한 소개", student['simpleInfo'] ?? '없음'),
                const SizedBox(height: 12),
                _buildDetailBox("연락처", student['contactInfo'] ?? '없음'),
                const SizedBox(height: 12),
                _buildDetailBox("추가 정보", student['additionalInfo'] ?? '없음'),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ 공개 여부
            _buildSection(
              title: "공개 설정",
              children: [
                _buildInfoRow(
                  "프로필 공개",
                  (student['visibility'] ?? false) ? "공개" : "비공개",
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ 액션 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: 좋아요/관심 기능
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("관심을 표시했습니다")),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text("관심"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: 채팅/연락 기능
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("연락처로 이동합니다")),
                      );
                    },
                    icon: const Icon(Icons.mail_outline),
                    label: const Text("연락"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 섹션 헤더 위젯
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  // ✅ 정보 행 위젯 (라벨: 값)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 기술 스택 칩 위젯
  Widget _buildTechStackChips(List<dynamic> techStack) {
    if (techStack.isEmpty) {
      return const Text("없음");
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: techStack.map((tech) {
        return Chip(
          label: Text(tech.toString()),
          backgroundColor: Colors.blue[100],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        );
      }).toList(),
    );
  }

  // ✅ 상세 정보 박스 (여러 줄)
  Widget _buildDetailBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }
}