import 'package:flutter/material.dart';

class InfoSetting extends StatefulWidget {
  const InfoSetting({super.key});

  @override
  State<InfoSetting> createState() => _InfoSettingState();
}

class _InfoSettingState extends State<InfoSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infomation Setting"),
      ),
    );
  }
}