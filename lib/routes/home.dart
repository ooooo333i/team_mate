import 'package:flutter/material.dart';
import 'package:team_mate/components/profiles_page.dart';
import 'package:team_mate/components/liked_listview.dart';
import 'package:team_mate/components/bottom_navi_bar.dart';
import 'package:team_mate/components/user_drawer.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final pages = [
    ProfilesPage(),     // 필터 + 리스트
    LikedListview(),    // 좋아요 목록 화면
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey, // 🔑 드로어 열기 위해 필요
      appBar: AppBar(
        title: const Text('Team Mate'),
        /*
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/loginpage');
          },
          icon: const Icon(Icons.account_box),
        ),
        */
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.info),
          ),
        ],
      
      ),
      endDrawer: const UserDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}