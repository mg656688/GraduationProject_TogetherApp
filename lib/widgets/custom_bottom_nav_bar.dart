import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_x/screens/community/add_post_screen.dart';
import 'package:project_x/screens/community/community_screen.dart';
import 'package:project_x/screens/plantingGuide/planting_guide_screen.dart';
import 'package:project_x/screens/profile_screen.dart';

import '../screens/pollution_report_screen.dart';

class customNavBar extends StatefulWidget {
  const customNavBar({Key? key}) : super(key: key);

  @override
  State<customNavBar> createState() => _customNavBarState();
}

class _customNavBarState extends State<customNavBar> {
  int currentIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    screens = [
      CommunityScreen(),
      plantingGuideScreen(),
      addPostScreen(user: user),
      pollutionReport(),
      profileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffE7F6F2),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home,
                size: 35, color: Color.fromRGBO(48, 64, 34, 100)),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_florist_outlined,
                  size: 35, color: Color.fromRGBO(48, 64, 34, 100)),
              label: "Planting"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded,
                size: 35, color: Color.fromRGBO(48, 64, 34, 100)),
            label: "Post",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.report,
                  size: 35, color: Color.fromRGBO(48, 64, 34, 100)),
              label: "Report"),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled,
                color: Color.fromRGBO(48, 64, 34, 100), size: 35),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.black,
      ),
      body: screens[currentIndex],
    );
  }
}
