import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_icon_button.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/user_model.dart';
import 'package:project_x/widgets/custom_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? _userModel;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          _userModel = UserModel.fromFirebaseUser(snapshot.data() as Map<String, dynamic>);
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void saveProfileChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && _userModel != null) {
        // Upload the profile image if it is selected
        if (_profileImage != null) {
          String fileName = user.uid + '-profile-image';
          Reference reference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
          UploadTask uploadTask = reference.putFile(_profileImage!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          _userModel!.avatarUrl = downloadUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(_userModel!.toJson());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CustomNavBar(selectedIndex: 4),
              ),
                  (route) => false,
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            'Edit Profile',
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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _userModel != null && _userModel!.avatarUrl.isNotEmpty
                        ? NetworkImage(_userModel!.avatarUrl) as ImageProvider
                        : const AssetImage('assets/images/default_profile_image.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(18, 12, 0, 0),
              child: Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 12),
              child: TextFormField(
                initialValue: _userModel?.name ?? '',
                onChanged: (value) {
                  setState(() {
                    _userModel?.name = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: kPrimaryColor,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),

            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(18, 12, 0, 0),
              child: Row(
                children: [
                  Text(
                    'Bio',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 12),
              child: TextFormField(
                initialValue: _userModel?.bio ?? '',
                onChanged: (value) {
                  setState(() {
                    _userModel?.bio = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: kPrimaryColor,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),

            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:  Color(0xff304022),
                ),
                onPressed: saveProfileChanges,
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight:  FontWeight.w600,
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
