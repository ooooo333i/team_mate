import 'package:flutter/material.dart';
import 'package:team_mate/components/listview.dart';
import 'package:team_mate/components/filter_block.dart';
import 'package:team_mate/components/user_drawer.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,   // Scaffold에 key 연결

      endDrawer: const UserDrawer(),  // 오른쪽 Drawer UI
      appBar: AppBar(
        title: Text('Team Mate'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/loginpage');
          },
          icon: const Icon(Icons.account_box),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();  
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      
      ),
      
      body: Column(
        children: [
          FilterBlock(
            onFilterChanged: (filters) {
              // 필터가 변경될 때 처리할 로직
              print("Selected Major: ${filters['major']}");
              print("Search Query: ${filters['search']}");
            },
          ),
          Expanded(child: InfoListView()),
        ],
      ),
    );
  }
}
