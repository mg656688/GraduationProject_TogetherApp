import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/const/constants.dart';
import 'package:project_x/screens/community/community_screen.dart';
import 'package:project_x/screens/forgot_password_screen.dart';
import 'package:project_x/screens/sign_up_screen.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool sec = true;

  var visible = const Icon(Icons.visibility, color: Color(0xff4c5166));

  var visibleoff = const Icon(Icons.visibility_off, color: Color(0xff4c5166));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.hasData) {
            return  CommunityScreen();
          } else {
            return Login();
          }
        },
      ),
    );
  }

  Widget Login() {
    Size size = MediaQuery.of(context).size;
    return  Stack(
        children: [
          Image.asset(
            'assets/images/sign_in.jpg',
            fit: BoxFit.cover,
            height: size.height,
            width: size.width,
          ),
          SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Card(
                margin: EdgeInsets.fromLTRB(0,220,0,0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildemail(),
                      const SizedBox(
                        height: 15,
                      ),
                      buildPassword(),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            SignIn();
                          }
                        },
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: const Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: const ForgotPassword(),
                                  type: PageTransitionType.bottomToTop));
                        },
                        child: Center(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: 'Forgot Password? ',
                                style: TextStyle(
                                  color: Constants.blackColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Reset Here',
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ]),
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
                          await signInWithGoogle();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff296e48),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                child:Image.asset('assets/images/google.png'),
                              ),
                            ),
                            Text(
                              'Sign In with Google',
                              style: TextStyle(
                                color: Constants.whiteColor,
                                fontSize: 18.0,
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
                                  child: const SignUp(), type: PageTransitionType.bottomToTop));
                        },
                        child: Center(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: 'New to Together? ',
                                style: TextStyle(
                                  color: Constants.blackColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
    );
  }

  Widget buildemail() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            decoration: BoxDecoration(
                color: const Color(0xffE3E3E3),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                  )
                ]),
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else if (value.length < 6) {
                  return "~Enter valid email";
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
                contentPadding: EdgeInsets.only(left: 10, top: 16),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff4c5166),
                ),
                hintText: "Email Address",
                helperStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPassword() {
    return  Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            decoration: BoxDecoration(
                color: const Color(0xffE3E3E3),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                  )
                ]),
            child: TextFormField(
              controller: passwordController,
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
              obscureText: sec,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                prefixIcon: const Icon(
                  Icons.key_outlined,
                  color: Color(0xff4c5166),
                ),
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        sec = !sec;
                      });
                    },
                    icon: sec ? visible : visibleoff),
                hintText: "Password",
                helperStyle: const TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future SignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      _showMyDialog(e.toString());
    }
  }

  Future<void> _showMyDialog(String x) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(x),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =  await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
