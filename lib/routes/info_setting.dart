import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/user_api.dart';
import 'package:team_mate/model/user_profile.dart';

class InfoSetting extends StatefulWidget {
  const InfoSetting({super.key});

  @override
  State<InfoSetting> createState() => _InfoSettingState();
}

class _InfoSettingState extends State<InfoSetting> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController simpleInfoController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

  String? selectedMajor;
  String? selectedApplicationField;

  final List<String> allTechStacks = [
    "FLUTTER",
    "JAVA",
    "SPRING",
    "PYTHON",
    "C",
    "AI", 
    "REACT"
    "ANDROID",
    "NODEJS",
    "UNITY",
    "UNREAL",
  ];
  List<String> selectedTechStacks = [];

  // 서버에 저장 전, 학과 및 지원 분야 코드를 맞추는 함수
  String mapMajor(String? major) {
    switch (major) {
      case "컴퓨터공학과":
        return "CS";
      case "소프트웨어학과":
        return "SW";
      case "AI학과":
        return "AI";
      default:
        return "";
    }
  }

  String mapApplicationField(String? field) {
    switch (field) {
      case "PM":
        return "PM";
      case "Frontend":
        return "FE";
      case "Backend":
        return "BE";
      case "VR":
        return "VR";
      case "Design":
        return "DESIGN";
      default:
        return "ETC";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Information Setting")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "이름",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "이름을 입력하세요" : null,
              ),
              const SizedBox(height: 20),

              // 전공
              DropdownButtonFormField<String>(
                initialValue: selectedMajor,
                decoration: const InputDecoration(
                  labelText: "전공",
                  border: OutlineInputBorder(),
                ),
                items:
                    ["컴퓨터공학과", "소프트웨어학과", "정보보안학과", "AI학과"]
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                onChanged: (v) => setState(() => selectedMajor = v),
                validator: (v) => v == null ? "전공을 선택하세요" : null,
              ),
              const SizedBox(height: 20),

              // 학년
              TextFormField(
                controller: gradeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "학년",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "학년을 입력하세요" : null,
              ),
              const SizedBox(height: 20),

              // 기술 스택
              const Text(
                "기술 스택",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    allTechStacks.map((tech) {
                      final bool isSelected = selectedTechStacks.contains(tech);
                      return ChoiceChip(
                        label: Text(tech),
                        selected: isSelected,
                        selectedColor: Colors.blue.shade200,
                        onSelected: (_) {
                          setState(() {
                            isSelected
                                ? selectedTechStacks.remove(tech)
                                : selectedTechStacks.add(tech);
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // 지원 분야
              DropdownButtonFormField<String>(
                initialValue: selectedApplicationField,
                decoration: const InputDecoration(
                  labelText: "지원 분야",
                  border: OutlineInputBorder(),
                ),
                items:
                    ["PM", "Frontend", "Backend", "VR", "Design"]
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                onChanged: (v) => setState(() => selectedApplicationField = v),
                validator: (v) => v == null ? "지원 분야를 선택하세요" : null,
              ),
              const SizedBox(height: 20),

              // 연락처
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: "연락처",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "연락처를 입력하세요" : null,
              ),
              const SizedBox(height: 20),

              // 한 줄 소개
              TextFormField(
                controller: simpleInfoController,
                decoration: const InputDecoration(
                  labelText: "한 줄 소개",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 추가 정보
              TextFormField(
                controller: additionalInfoController,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final storage = const FlutterSecureStorage();
                      final studentIdString = await storage.read(
                        key: "studentId",
                      );
                      final jwt = await storage.read(key: "jwt");

                      // ⬇️ JSON 출력은 JWT 유무와 상관없이 먼저 수행
                      final profile = UserProfile(
                        studentId: int.tryParse(studentIdString ?? "0") ?? 0,
                        name: nameController.text.trim(),
                        major: mapMajor(selectedMajor),
                        grade: int.parse(gradeController.text.trim()),
                        techStack: selectedTechStacks,
                        applicationField: mapApplicationField(
                          selectedApplicationField,
                        ),
                        simpleInfo: simpleInfoController.text.trim(),
                        contactInfo: contactController.text.trim(),
                        additionalInfo: additionalInfoController.text.trim(),
                        visibility: true,
                      );

                      debugPrint("===== 저장 버튼 클릭됨 =====");
                      debugPrint("보낼 요청 바디:");
                      debugPrint(profile.toJson().toString());
                      debugPrint("================================");


                      
                      // ⬇️ JWT 체크는 이 뒤에서
                      if (studentIdString == null || jwt == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("JWT가 없습니다. 로그인 후 다시 시도하세요."),
                          ),
                        );
                        
                      }

                      // 실제 저장 API 호출
                      final ok = await UserApi.saveProfile(profile);

                      if (ok) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("저장 완료!")));
                        Navigator.pushReplacementNamed(context, "/");
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("저장 실패")));
                      }
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
