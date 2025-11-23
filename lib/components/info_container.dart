import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String name;
  final String major;
  final int grade;
  final String applicationField;
  final List<dynamic> techStack;
  final String simpleInfo;
  final VoidCallback onTap;

  const InfoContainer({
    super.key,
    required this.name,
    required this.major,
    required this.grade,
    required this.applicationField,
    required this.techStack,
    required this.simpleInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // 전공, 학년, 지원 분야
              Text(
                "$major • $grade학년 • $applicationField",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              // Tech Stack
              Wrap(
                spacing: 6,
                children: techStack
                    .map((tech) => Chip(
                          label: Text(tech),
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              ),

              const SizedBox(height: 10),

              // 간단 소개
              Text(
                simpleInfo,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}