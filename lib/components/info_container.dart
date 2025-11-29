import 'package:flutter/material.dart';

class InfoContainer extends StatefulWidget {
  final String name;
  final String major;
  final int grade;
  final String applicationField;
  final List<dynamic> techStack;
  final String simpleInfo;
  final VoidCallback onTap;
  final bool isLiked; // ✅ 추가: 좋아요 상태
  final ValueChanged<bool>? onLikeChanged; // ✅ 추가: 좋아요 콜백

  const InfoContainer({
    super.key,
    required this.name,
    required this.major,
    required this.grade,
    required this.applicationField,
    required this.techStack,
    required this.simpleInfo,
    required this.onTap,
    this.isLiked = false, // ✅ 기본값: false
    this.onLikeChanged,
  });

  @override
  State<InfoContainer> createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onLikeChanged?.call(_isLiked); // ✅ 부모에 알림
    debugPrint('[InfoContainer] 좋아요: $_isLiked - ${widget.name}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 헤더: 이름 + 좋아요 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${widget.major} · ${widget.grade}학년", // ✅ 변경: major → widget.major
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ 좋아요 버튼 (별표 아이콘)
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.star : Icons.star_border,
                      color: _isLiked ? Colors.amber : Colors.grey,
                      size: 28,
                    ),
                    onPressed: _toggleLike,
                    tooltip: _isLiked ? "좋아요 취소" : "좋아요",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 지원 분야
              Text(
                "지원 분야: ${widget.applicationField}",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // 기술 스택
              if (widget.techStack.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.techStack.map((tech) {
                    return Chip(
                      label: Text(tech.toString()),
                      backgroundColor: Colors.blue[100],
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    );
                  }).toList(),
                )
              else
                Text(
                  "기술 스택: 없음",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),

              const SizedBox(height: 8),

              // 간단한 소개
              if (widget.simpleInfo.isNotEmpty)
                Text(
                  widget.simpleInfo,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}