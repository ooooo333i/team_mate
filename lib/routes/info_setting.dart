import 'package:flutter/material.dart';

class InfoSetting extends StatefulWidget {
  const InfoSetting({super.key});

  @override
  State<InfoSetting> createState() => _InfoSettingState();
}

class _InfoSettingState extends State<InfoSetting> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  String? selectedMajor;

  // 선택 가능한 기술 스택 목록
  final List<String> allTechStacks = [
    "Flutter",
    "Dart",
    "Java",
    "Spring",
    "Python",
    "Django",
    "JavaScript",
    "React",
    "Node.js",
    "AWS",
  ];

  // 선택된 기술 스택들
  List<String> selectedTechStacks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Setting"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름 입력
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "이름",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "이름을 입력하세요" : null,
              ),

              const SizedBox(height: 20),

              // 전공 선택
              DropdownButtonFormField<String>(
                initialValue: selectedMajor,
                decoration: const InputDecoration(
                  labelText: "전공",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "컴퓨터공학과",
                  "소프트웨어학과",
                  "정보보안학과",
                  "AI학과",
                ].map((major) {
                  return DropdownMenuItem(
                    value: major,
                    child: Text(major),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMajor = value;
                  });
                },
                validator: (v) => v == null ? "전공을 선택하세요" : null,
              ),

              const SizedBox(height: 20),

              // 기술 스택 선택
              const Text(
                "기술 스택",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allTechStacks.map((tech) {
                  final bool isSelected = selectedTechStacks.contains(tech);
                  return ChoiceChip(
                    label: Text(tech),
                    selected: isSelected,
                    selectedColor: Colors.blue.shade200,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedTechStacks.remove(tech);
                        } else {
                          selectedTechStacks.add(tech);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // 연락처 입력
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: "연락처 (이메일, 전화번호)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // 추가 정보 입력
              TextFormField(
                controller: infoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "추가 정보",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("이름: ${nameController.text}");
                      print("전공: $selectedMajor");
                      print("기술스택: $selectedTechStacks");
                      print("연락처: ${contactController.text}");
                      print("추가정보: ${infoController.text}");

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("정보가 저장되었습니다.")),
                      );
                    }
                  },
                  child: const Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}