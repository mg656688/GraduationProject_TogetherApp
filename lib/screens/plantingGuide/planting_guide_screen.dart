import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/screens/plantingGuide/flowers_screen.dart';
import 'package:project_x/screens/plantingGuide/leaves_screen.dart';
import 'package:project_x/screens/plantingGuide/my_garden_screen.dart';
import 'package:project_x/widgets/planting_guide_card.dart';

import '../../main.dart';

class plantingGuideScreen extends StatefulWidget {
  const plantingGuideScreen({super.key});

  @override
  State<plantingGuideScreen> createState() => _plantingGuideScreenState();
}

class _plantingGuideScreenState extends State<plantingGuideScreen> {
  final User? user = auth.currentUser;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme
          .of(context)
          .primaryBackground,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(48, 64, 34, 100),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            'Planting Guide',
            style: FlutterFlowTheme
                .of(context)
                .title2
                .override(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 230, top: 10),
                child: Text(
                  "My Garden",
                  style: FlutterFlowTheme
                      .of(context)
                      .title2
                      .override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
          //     Card(
          //       child: ListTile(
          //         leading: Image.network('https://images.pexels.com/photos/7663957/pexels-photo-7663957.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
          //         title: Text('Go To Garden')
          //       ),
          //     ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: MyGardenPage(userId: user!.uid),
                            type: PageTransitionType.bottomToTop));
                  },
                  child:           Container(
                    margin: const EdgeInsets.only
                      (left: kDefaultPadding/2,
                      top: kDefaultPadding/3,
                      bottom: kDefaultPadding*0.4,
                      right: kDefaultPadding/2,

                    ),
                    width: 200,
                    child: Column(
                      children: [
                        Image.asset('assets/images/garden.jpeg'),
                        GestureDetector(
                          onTap:(){
                          },
                          child: Container(
                            padding: const EdgeInsets.all(kDefaultPadding/2),
                            decoration:  BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(offset: const Offset(0,10),blurRadius: 50,color: kPrimaryColor.withOpacity(0.3)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 20,),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: flowers(),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: PlantingGuideCard(size: size * 2.5,
                              plantName: 'Flowers\n',
                              sub: 'Just scan your flowers !',
                              image: 'assets/images/img_flower.png',)),


                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: const leaves(),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: PlantingGuideCard(size: size * 2.5,
                              plantName: 'Leaves\n',
                              sub: 'Identify your plants from its leaves !',
                              image: 'assets/images/img_leave.png',)),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}