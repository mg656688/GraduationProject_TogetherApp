import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/screens/plantingGuide/my_garden_screen.dart';
import 'package:project_x/widgets/custom_bottom_nav_bar.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../main.dart';

class leavesInfoScreen extends StatefulWidget {
  final String prediction;

  const leavesInfoScreen(this.prediction, {Key? key});

  @override
  _leavesInfoScreenState createState() => _leavesInfoScreenState();
}

class _leavesInfoScreenState extends State<leavesInfoScreen> {
  bool isLoading = true;
  bool isSavedToGarden = false;
  bool isDataLoaded = false;

  late String plantName;
  late String commonName;
  late String info;
  late String lightNeed;
  late String lightDetails;
  late String plantingRequirements;
  late String wateringNeed;
  late String wateringDetails;
  late String temperature;
  late String temperatureDetails;
  late String diseases;
  late String plantPhotoUrl;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();


  void initState() {
    super.initState();
    getaData(widget.prediction);
    checkPlantIsSaved();
  }

  checkPlantIsSaved() {
    // Check if the plant is already saved in the user's garden
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favPlants')
        .where('name', isEqualTo: widget.prediction)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isSavedToGarden = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }


  Future<void> getaData(String prediction) async {
    if (!isDataLoaded) {
      var db = await mongo.Db.create(
          "mongodb+srv://admin:admin1234@together.cvq6ffb.mongodb.net/plantinfo?retryWrites=true&w=majority");
      await db.open();

      var collection = await db.collection("Leaves");
      var plantData =
          await collection.findOne(mongo.where.eq("plant_name", prediction));
      db.close();
      if (kDebugMode) {
        print(plantData);
      }

      setState(() {
        plantName = plantData?['plant_name'] as String;
        commonName = plantData?['common_name'] as String;
        info = plantData?['about_info'] as String;
        lightNeed = plantData?['light_need'] as String;
        plantingRequirements = plantData?['planting_requirements'] as String;
        wateringNeed = plantData?['watering_need'] as String;
        wateringDetails = plantData?['watering_details'] as String;
        temperature = plantData?['temperature'] as String;
        temperatureDetails = plantData?['temperature_details'] as String;
        diseases = plantData?['diseases'];
        plantPhotoUrl = plantData?['plant_photo_url'] as String;
        isLoading = false;
        isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
                  PageTransition(
                      child: MyGardenPage(userId: user!.uid),
                      type: PageTransitionType.leftToRightWithFade));
            },
          ),
          title: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
            child: Text(
              'Plant Information',
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
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
        )),
      );
    } else {
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
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: MyGardenPage(userId: user!.uid),
                        type: PageTransitionType.bottomToTop));
              },
            ),
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
              child: Text(
                'Plant Information',
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
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                child: Image.network(
                  plantPhotoUrl,
                  width: 396,
                  height: 210,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          plantName,
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF19311C),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'About',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Common Name',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                          child: Text(
                            commonName,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: kPrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: Text(
                              info,
                              textAlign: TextAlign.justify,
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 15),
                          child: Text(
                            'How to care for $plantName',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFB3BCAB),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 0, 0),
                                  child: Text(
                                    'Light',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF304022),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 10, 0, 0),
                                  child: Text(
                                    lightNeed,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 0, 0),
                                  child: Text(
                                    'Watering',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF304022),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    wateringNeed,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 10, 10),
                                    child: Text(
                                      wateringDetails,
                                      textAlign: TextAlign.justify,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    'Temperature ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF304022),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    temperature,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 10, 0),
                                    child: Text(
                                      temperatureDetails,
                                      textAlign: TextAlign.justify,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!isSavedToGarden)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 2),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 40),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    var plantType = 'leaf';
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('favPlants')
                                        .add({
                                      'name': widget.prediction,
                                      'imageUrl': plantPhotoUrl,
                                      'type': plantType,
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child:
                                                MyGardenPage(userId: user!.uid),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  },
                                  child: Text(
                                    'Add to Garden',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )));
    }
  }
}
