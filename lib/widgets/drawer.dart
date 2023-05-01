import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_x/flutter_flow/flutter_flow_util.dart';
import 'package:project_x/screens/sign_in_screen.dart';

class customDrawer extends StatefulWidget {
  const customDrawer({Key? key}) : super(key: key);

  @override
  State<customDrawer> createState() => _customDrawerState();
}

class _customDrawerState extends State<customDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(48, 64, 34, 100),
            ),
            accountName: Text(_auth.currentUser!.displayName.toString()),
            accountEmail: Text(_auth.currentUser!.email.toString()),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _auth.currentUser!.displayName.toString().substring(0, 1),
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // handle settings action
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context,
        PageTransition(child: SignIn(), type: PageTransitionType.bottomToTop));

    print('User signed out');
  }
}
