/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:together/Normalhomescreen.dart';
import 'package:together/signin_page.dart';
import 'package:together/signup_page.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isemailverifaied=false;
  @override
  void initState() {

    super.initState();
    isemailverifaied=FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isemailverifaied){
      sendVerifictionEmail();
      checkEmailVerify();
    }

  }
  Future sendVerifictionEmail () async {
    try{
      final user=FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

    }catch(e){
      print(e);
      _showMyDialogVerifiy(e.toString());
    }

  }
  Future checkEmailVerify() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isemailverifaied=FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }
  Widget build(BuildContext context) =>isemailverifaied? MainHomeScreen():Scaffold(
    appBar: AppBar(
      title: Text("Verify Email"),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "A verifiction has been sent to this email",style: TextStyle(
            fontSize: 20,
          ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );

  Future<void> _showMyDialogVerifiy(String x) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('error'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
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
  Future<void> _showMyDialogVerify() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wait'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Check your Gmail'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        );
      },
    );
  }



}
*/
