import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_x/screens/onboarding_screen.dart';
import 'package:project_x/screens/sign_up_screen.dart';
import 'package:project_x/widgets/custom_bottom_nav_bar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await doc.get();
      if (!docSnapshot.exists) {
        // Save user data to Firestore if the user is new
        await doc.set({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'avatarUrl': user.photoURL,
          'following': [],
          'followers': [],
          'achievements':[],
          'plants': [],
          'bio' : '',
          'followerCount': 0,
          'followingCount' : 0,
          'postCount': 0,
        }, SetOptions(merge: true));
      }
    }
  });
  runApp(MyApp());
}

// Check if the user is already signed in or not.
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Together App',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: AnimatedSplashScreen(
          duration: 4000,
          splash:
              Image.asset("assets/images/splash.png", fit: BoxFit.scaleDown),
          nextScreen: user == null ? OnboardingScreen() : customNavBar(),
          backgroundColor: Colors.white,
          splashIconSize: double.maxFinite,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ),
    );
  }
}
