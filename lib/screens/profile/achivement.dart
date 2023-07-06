import 'package:flutter/material.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';

class achievementScreen extends StatefulWidget {
  const achievementScreen({Key? key}) : super(key: key);

  @override
  State<achievementScreen> createState() => _achievementScreenState();
}

class _achievementScreenState extends State<achievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              child: Text(style: FlutterFlowTheme.of(context).bodyText2
                  ,"ACHIEVEMENTS"))),
    );
  }
}
