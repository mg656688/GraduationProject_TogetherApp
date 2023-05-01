import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class achievementScreen extends StatefulWidget {
  const achievementScreen({Key? key}) : super(key: key);

  @override
  State<achievementScreen> createState() => _achievementScreenState();
}

class _achievementScreenState extends State<achievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("ACHIEVEMENTS"),
    );
  }
}
