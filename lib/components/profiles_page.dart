import 'package:flutter/material.dart';
import 'package:team_mate/components/filter_block.dart';
import 'package:team_mate/components/listview.dart';

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBlock(
          onFilterChanged: (filters) {
            print("Selected Major: ${filters['major']}");
            print("Search Query: ${filters['search']}");
          },
        ), // ← 이거 너가 따로 만들던 필터 위젯
        Expanded(child: InfoListView()), // ← 프로필 리스트
      ],
    );
  }
}
