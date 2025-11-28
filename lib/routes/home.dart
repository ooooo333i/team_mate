import 'package:flutter/material.dart';
import 'package:team_mate/components/profiles_page.dart';
import 'package:team_mate/components/liked_listview.dart';
import 'package:team_mate/components/bottom_navi_bar.dart';
import 'package:team_mate/components/user_drawer.dart';
import 'package:team_mate/services/token_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  // ✅ 변경: List<Widget> 명시 (StatefulWidget 아님)
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _checkToken();

    // ✅ pages 초기화
    pages = [
      const ProfilesPage(), // ProfilesPage (StatefulWidget)
      const LikedListview(), // LikedListview (StatefulWidget)
    ];
  }

  Future<void> _checkToken() async {
    final token = await TokenStorage.getAccessToken();
    debugPrint("[Home.initState] 토큰: $token");
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Team Mate'),
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