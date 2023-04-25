import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_icon_button.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../widgets/PhotoPickerWidget.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({super.key, required this.user});

  final User user;

  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  XFile? image;
  final ImagePicker picker = ImagePicker();


  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }


  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }
  void _removeImage() {
    setState(() {
      image = null;
    });
  }

  void
  myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title:  Text(
                    style: FlutterFlowTheme.of(context).title1,
                    'Choose media'),
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
              ),
            ],
          );
        });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final content = _contentController.text.trim();
      String? imageUrl;
      final user = _auth.currentUser!;
      var postRef = _firestore.collection('posts').doc();

      if (image != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('post_pictures/${postRef.id}');
        final uploadTask = storageRef.putFile(File(image!.path));
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrl = downloadUrl.toString();
      }
      if (content.isNotEmpty) {

        _firestore.collection('posts').add({
          'id': postRef.id,
          'user': {
            'id': user.uid,
            'name': user.displayName ?? user.email!.split('@')[0],
            'avatarUrl': user.photoURL ?? '',
          },
          'content': content,
          'imageUrl':  imageUrl ?? '',
          'likes': 0,
          'likedBy':[],
          'comments': [],
          'timestamp': FieldValue.serverTimestamp(),
        });
        _contentController.clear();
      }
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: customNavBar(), type: PageTransitionType.bottomToTop));
    }
  }

  @override
  Widget build(BuildContext context) {
    int wordCount = 0;
    double fontSize = 24.0;
    String input = _contentController.text;
    List<String> words = input.split(' ');
    wordCount = words.length;
    fontSize = (wordCount > 10) ? 18 : 24;
    print(wordCount);
    print(fontSize);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: FlutterFlowIconButton(
              icon : Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: customNavBar(), type: PageTransitionType.bottomToTop));},),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).secondaryColor
            ),'Create Post'),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff304022),
                  ),
                  onPressed: _submitForm,
                  child:  Text(
                    'Post',
                    style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: FlutterFlowTheme.of(context).secondaryColor,
                    ),
                  ),
                )
            ),
          ),
      ],
        backgroundColor: const Color.fromRGBO(48, 64, 34, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoURL ?? 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80'),
                  radius: 30.0,
                ),

                title: Text(
                    widget.user.displayName as String,
                    style: FlutterFlowTheme.of(context).title1),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                child: TextFormField(
                  controller: _contentController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                  autofocus: true,
                  onChanged: (value) {
                      setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'What\'s happening?',
                    hintStyle: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: kPrimaryColor,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                  ),
                  style: FlutterFlowTheme.of(context).title1.override(
                    fontFamily: 'Poppins',
                    fontSize: fontSize,
                    color: FlutterFlowTheme.of(context).secondaryColor,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                ),
              ),
              Card(
                child: InkWell(
                  onTap: myAlert,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kBackgroundColor,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 180,
                    width: 400,
                    child: image == null
                        ? Icon(
                      Icons.add_photo_alternate_outlined,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      size: 35)
                        : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: 400,
                                height: 300,
                              ),
                            ),
                            Positioned(
                               top: 8,
                               right: 8,
                               child: InkWell(
                                 onTap: _removeImage,
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: Colors.white70,
                                     shape: BoxShape.circle,
                                   ),
                                   child: Icon(
                                     Icons.close,
                                     color: Colors.black,
                                     size: 20,
                                   ),
                                 ),
                               ),
                            )
                          ]
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
