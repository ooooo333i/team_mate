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
  bool isExpanded = false; // 확장 상태 여부

  final majors = [
    "전체",
    "컴퓨터공학과",
    "소프트웨어학과",
    
    "AI로봇학과",
    
  ];

  final techList = [
    "C",
    "PYTHON",
    "JAVA",
    "REACT",
    "FLUTTER",
    "ANDROID",
    "SPRING",
    "NODE.JS",
    "AI",
    "UNITY",
    "UNREAL"
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
          // 전공 필터
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
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 기술 스택: 확장 상태일 때만 보여줌
          if (isExpanded) ...[
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
                    style: const TextStyle(fontSize: 12),
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
        ],
      ),
    );
  }
}