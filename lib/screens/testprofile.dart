import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:project_x/screens/achivement.dart';
import 'package:project_x/screens/profile_screen.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class TestProfileScreen extends StatefulWidget {
  const TestProfileScreen({Key? key}) : super(key: key);

  @override
  State<TestProfileScreen> createState() => _TestProfileScreenState();
}

class _TestProfileScreenState extends State<TestProfileScreen> with SingleTickerProviderStateMixin{
  final tabList = ['Your Posts', 'Achievements'];
  late TabController _tabController;
  final tab = [profileScreen()];
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color.fromRGBO(48, 64, 34, 100),
        leading: FlutterFlowIconButton(
          icon : Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: customNavBar(selectedIndex: 0), type: PageTransitionType.bottomToTop));},),
        bottom: TabBar(
          tabs: tabList.map((item) {
            return Tab(
              text: item,
            );
          }).toList(),
          labelStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          indicator: PointTabIndicator(
            position: PointTabIndicatorPosition.bottom,
            color: Color.fromRGBO(59, 121, 55, 1),
            insets: EdgeInsets.only(bottom: 8),
          ),
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          profileScreen(),
          achievementScreen(),
        ],
      ),
      );
  }
}
