import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:page_transition/page_transition.dart';
import 'package:project_x/const/constants.dart';
import 'package:project_x/screens/sign_in_screen.dart';

import '../const/constant.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkeyup = GlobalKey<FormState>();
  var emailSignupController=TextEditingController();
  var passwordSignupController=TextEditingController();
  bool secsignup = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  var visiblesignup = const Icon(Icons.visibility, color: Color(0xff4c5166));

  var visibleoffsignup = const Icon(Icons.visibility_off, color: Color(0xff4c5166));
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SignUPBody(),
    );
  }
  Future SignUp() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailSignupController.text, password: passwordSignupController.text);

    }on FirebaseAuthException catch(e){
      print(e);
      Utils.showSnackBar(e.message);

    }

  }
  Widget SignUPBody(){
    Size size = MediaQuery.of(context).size;
    return  Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/Sign up-bro 1.png')),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: emailSignupController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, top: 14),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xff4c5166),
                  ),
                  hintText: "Email Address",
                  helperStyle: TextStyle(color: Colors.black38),
                ),
              ),

              TextFormField(
                controller: passwordSignupController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else if (value.length < 6) {
                    return "Password should be at least 6 characters";
                  } else if (value.length > 15) {
                    return "Password should not be greater than 15 characters";
                  } else {
                    return null;
                  }
                },
                obscureText: secsignup,
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10, top: 14),
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Color(0xff4c5166),
                  ),
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          secsignup = !secsignup;
                        });
                      },
                      icon: secsignup ? visiblesignup : visibleoffsignup),
                  hintText: "Password",
                  helperStyle: const TextStyle(color: Colors.black38),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  SignUp();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SignIn()),
                  );

                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: kSearchColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await signUpWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSearchColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                        child:Image.asset('assets/images/google.png'),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Constants.whiteColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: SignIn(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Have an Account? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: kSearchColor,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ));

  }


  Future<UserCredential> signUpWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}


class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey=GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text){
    if(text==null) return ;
    final snackBar=SnackBar(content: Text(text),backgroundColor: Colors.red,);
    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}
