import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AcivementScreen extends StatefulWidget {
  const AcivementScreen({Key? key}) : super(key: key);

  @override
  State<AcivementScreen> createState() => _AcivementScreenState();
}

class _AcivementScreenState extends State<AcivementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("ACHIVEMENTS"),
    );
  }
}
