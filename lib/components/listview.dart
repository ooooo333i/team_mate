import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:team_mate/components/info_container.dart';

class InfoListView extends StatefulWidget {
  const InfoListView({super.key});

  @override
  State<InfoListView> createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  List<dynamic> dataList = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String jsonString = await rootBundle.loadString('assets/data/data.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      dataList = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dataList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final student = dataList[index];
        return InfoContainer(
          
          name: student['name'],
          major: student['major'],
          task: student['task'],
          techStack: student['techStack'],
          info: student['info'],
          isPublic: student['isPublic'],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${student['name']} 클릭됨')),
            );
          },
        );
      },
    );
  }
}