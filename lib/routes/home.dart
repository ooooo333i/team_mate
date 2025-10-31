import 'package:flutter/material.dart';
import 'package:team_mate/components/listview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pushNamed(context, '/infosetting');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: InfoListView(),
    );
  }
}
