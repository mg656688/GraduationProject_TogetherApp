import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/post_model.dart';
import 'package:project_x/models/user_model.dart';
import 'package:project_x/screens/achivement.dart';
import 'package:project_x/widgets/community/post_item.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}


class _profileScreenState extends State<profileScreen>  with SingleTickerProviderStateMixin {
  User? _user = FirebaseAuth.instance.currentUser;
  CollectionReference _postsRef = FirebaseFirestore.instance.collection('posts');

  TabBar get _tabBar => TabBar(
    isScrollable: false,
    dividerColor: Colors.white,
    labelStyle: FlutterFlowTheme.of(context).subtitle2,
    indicatorColor: FlutterFlowTheme.of(context).primaryColor,
    controller: _tabController,
    tabs: [
      Tab(text: 'Your Posts', icon: Icon(Icons.grid_view_rounded,color: Colors.white,)),
      Tab(text: 'Achievements',icon: Icon(Icons.star,color: Colors.white)),
    ],
  );

  late TabController _tabController;
  final tab = [profileScreen()];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose(); // dispose the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body:  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: _tabBar.preferredSize,
                  child: Material(
                    child: _tabBar,
                    color: kPrimaryColor,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0,right: 300),
                    child: Text(style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).secondaryColor
                    ),'Profile'),
                  ),
                ],
                backgroundColor: kPrimaryColor,
                expandedHeight: 350.0,
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                            child: Expanded(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('users').doc(_user!.uid).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 30.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(data['avatarUrl']),
                                              ),
                                              SizedBox(width: 30.0),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                      ],
                                    );
                                  }
                                  return Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Expanded(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('users').doc(_user!.uid).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 50.0, right:8.0),
                                          child: Expanded(
                                            child: Row(
                                              children: [
                                                Text('${data['postCount']}', style: FlutterFlowTheme.of(context).subtitle1,),
                                                SizedBox(width: 60),
                                                Text('${data['followerCount']}', style: FlutterFlowTheme.of(context).subtitle1,),
                                                SizedBox(width: 80),
                                                Text('${data['followingCount']}', style: FlutterFlowTheme.of(context).subtitle1,),
                                                SizedBox(width: 15),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                                          child: Expanded(
                                            child: Row(
                                              children: [
                                                Text('Posts', style: FlutterFlowTheme.of(context).subtitle1,),
                                                SizedBox(width: 15),
                                                Text('Followers', style: FlutterFlowTheme.of(context).subtitle1,),
                                                SizedBox(width: 15),
                                                Text('Following', style: FlutterFlowTheme.of(context).subtitle1,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top : 140.0),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(_user!.uid).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }
                                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 340,
                                              child: Text(
                                                  data['name'],
                                                  style: FlutterFlowTheme.of(context).title3
                                              ),
                                            ),
                                            Container(
                                              width: 340,
                                              child: Text(
                                                data['bio'],
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: kTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Center(child: Center());
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _postsRef
                    .where('user.id', isEqualTo: _user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> data =
                      snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      final user =
                      UserModel.fromFirebaseUser(data['user']);
                      final post = Post.fromJson(data);
                      return PostItem(user: user, post: post);
                    },
                  );
                },
              ),
              achievementScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
