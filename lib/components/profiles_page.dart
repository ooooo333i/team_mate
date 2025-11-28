import 'package:flutter/material.dart';
import 'package:team_mate/components/filter_block.dart';
import 'package:team_mate/components/listview.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  Map<String, dynamic> currentFilter = {
    'major': '전체',
    'tech': [],
  };

  void _onFilterChanged(Map<String, dynamic> filter) {
    setState(() {
      currentFilter = filter;
    });
    debugPrint('[ProfilesPage] 필터 변경: $currentFilter');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBlock(onFilterChanged: _onFilterChanged),
        Expanded(
          child: InfoListView(filter: currentFilter), // ✅ 필터 전달
        ),
      ],
    );
  }
}
