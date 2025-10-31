import 'package:flutter/material.dart';


class InfoContainer extends StatelessWidget {
  final String name;
  final String major;
  final String task;
  final List<dynamic> techStack;
  final String info;
  final bool isPublic;
  final VoidCallback onTap;

  const InfoContainer({
    super.key,
    required this.name,
    required this.major,
    required this.task,
    required this.techStack,
    required this.info,
    required this.isPublic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (!isPublic)
                    const Icon(Icons.lock, color: Colors.grey, size: 20)
                  else
                    const Icon(Icons.public, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text('$major • $task', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: -4,
                children: techStack
                    .map((tech) => Chip(
                          label: Text(tech),
                          backgroundColor: const Color.fromARGB(255, 249, 255, 250),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Text(
                info,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              
            ],
          ),
        ),
      ),
    );
  }
}