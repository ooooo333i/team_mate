import 'package:flutter/material.dart';

class FilterBlock extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;

  const FilterBlock({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<FilterBlock> createState() => _FilterBlockState();
}

class _FilterBlockState extends State<FilterBlock> {
  String selectedMajor = "전체";
  List<String> selectedTech = [];

  final majors = [
    "전체",
    "컴퓨터공학과",
    "소프트웨어학과",
    "정보보안학과",
    "AI학과",
    "데이터사이언스학과",
  ];

  final techList = [
    "Flutter", "React", "Java", "Spring",
    "Python", "Django", "C++", "Figma",
  ];

  void updateFilter() {
    widget.onFilterChanged({
      "major": selectedMajor,
      "tech": selectedTech,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전공 필터 (작게)
          Row(
            children: [
              const Text(
                "전공:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedMajor,
                    isDense: true,
                    items: majors.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(m, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() => selectedMajor = v!);
                      updateFilter();
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 기술 스택 (Chips, 작고 컴팩트하게)
          const Text(
            "기술 스택:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Wrap(
            spacing: 6,
            runSpacing: -6,
            children: techList.map((tech) {
              final bool isSelected = selectedTech.contains(tech);
              return ChoiceChip(
                label: Text(
                  tech,
                  style: TextStyle(fontSize: 12),
                ),
                selected: isSelected,
                selectedColor: Colors.green.shade200,
                backgroundColor: Colors.grey.shade200,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedTech.add(tech);
                    } else {
                      selectedTech.remove(tech);
                    }
                  });
                  updateFilter();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}