import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/flutter_flow/flutter_flow_icon_button.dart';
import 'package:project_x/flutter_flow/flutter_flow_util.dart';
import 'package:project_x/screens/plantingGuide/flowers_info_screen.dart';
import 'package:project_x/screens/plantingGuide/leaves_info_screen.dart';
import 'package:project_x/screens/plantingGuide/planting_guide_screen.dart';
import 'package:project_x/widgets/custom_bottom_nav_bar.dart';
import 'package:project_x/widgets/plant_card.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class MyGardenPage extends StatelessWidget {
  final String userId;

  const MyGardenPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        leading: FlutterFlowIconButton(
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomNavBar(selectedIndex: 1),
              ),
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            'My Garden',
            style: FlutterFlowTheme.of(context).title2.override(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favPlants')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomNavBar(selectedIndex: 1),
                      ),
                    );
                  },
                ),
                title: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                  child: Text(
                    'My Garden',
                    style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
                actions: const [],
                centerTitle: false,
                elevation: 2,
              ),
              body: Center(
                  child: CircularProgressIndicator()
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Text('Your garden is Empty'),
              ),
            );
          }

          final List<QueryDocumentSnapshot> flowers = [];
          final List<QueryDocumentSnapshot> leaves = [];

          for (final doc in snapshot.data!.docs) {
            final plant = doc.data() as Map<String, dynamic>;
            final String type = plant['type'];

            if (type == 'flower') {
              flowers.add(doc);
            } else if (type == 'leaf') {
              leaves.add(doc);
            }
          }

          return ListView(
            children: [
              if (flowers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flowering Plants',
                        style: FlutterFlowTheme.of(context).title1
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: flowers.length,
                        itemBuilder: (BuildContext context, int index) {
                          final plant =
                          flowers[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: flowerInfoScreen(plant['name']),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: PlantCard(
                              name: plant['name'] ?? 'not found',
                              imageUrl: plant['imageUrl'] ?? '',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (leaves.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leafy Plants',
                        style: FlutterFlowTheme.of(context).title1
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: leaves.length,
                        itemBuilder: (BuildContext context, int index) {
                          final plant =
                          leaves[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: leavesInfoScreen(plant['name']),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: PlantCard(
                              name: plant['name'] ?? 'not found',
                              imageUrl: plant['imageUrl'] ?? '',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
