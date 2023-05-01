import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';

class pollutionReport extends StatefulWidget {
  const pollutionReport({super.key});

  @override
  _pollutionReportState createState() => _pollutionReportState();
}

class _pollutionReportState extends State<pollutionReport> {

  XFile? image;

  final ImagePicker picker = ImagePicker();


  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(48, 64, 34, 100),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            'Pollution Report',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                myAlert();
              },
              child: const Text('Select pollution image'),
            ),
            const SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image, you type like this.
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: 300,
                  height: 300,
                ),
              ),
            )
                : const Text(
              "No Report",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20,),
            TextButton(

                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(22),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primaryColor,

                ),
                onPressed: (){
                  uploadImageToServer(image!);
                  Fluttertoast.showToast(
                      msg: "Reported Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }, child: const Text(
              "Report Now",style: TextStyle(
                color: Colors.white
            ),
            )),
            const SizedBox(height:20),
          ],
        ),
      ),
    );
  }

  uploadImageToServer(XFile imageFile)async
  {
    if (kDebugMode) {
      print("attempting to connect to server......");
    }
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    if (kDebugMode) {
      print(length);
    }

    var uri = Uri.parse('http://10.0.2.2:9874/report');
    if (kDebugMode) {
      print("connection established.");
    }
    var request = http.MultipartRequest("POST", uri);

    // Request permission to get location
    await Permission.location.request();

    // Get the user's location
    final position = await Geolocator.getCurrentPosition();

    // Convert the location to a JSON object
    final location = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
    final locationJson = jsonEncode(location);

    // Send the data to the server
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'location': locationJson,
      'file' : basename(imageFile.path),
    });
    final response = await http.post(uri, headers: headers, body: body);
    if (kDebugMode) {
      print(response.statusCode);
    }

  }

}



