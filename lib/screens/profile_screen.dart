import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_x/flutter_flow/flutter_flow_icon_button.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/post_model.dart';
import 'package:project_x/models/user_model.dart';
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
  final List<Tab> _tabs = <Tab>[    Tab(text: 'Your Posts'),    Tab(text: 'Achievements'),  ];


  late TabController _tabController; // declare the variable as late

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2); // initialize the variable
  }

  @override
  void dispose() {
    _tabController.dispose(); // dispose the controller when the screen is disposed
    super.dispose();
  }



@override
  Widget build(BuildContext context) {
  return Scaffold(
      body:  DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              bottom: TabBar(
                  isScrollable: false,
                  dividerColor: Colors.white,
                  labelStyle: FlutterFlowTheme.of(context).subtitle2,
                  indicatorColor: FlutterFlowTheme.of(context).primaryColor,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.white60,
                  tabs: _tabs
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: FlutterFlowIconButton(
                    icon : Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: customNavBar(selectedIndex: 0), type: PageTransitionType.bottomToTop));},),
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
              ],
              backgroundColor: Colors.black26,
              expandedHeight: 250.0,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 15.0),
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
                                        padding: const EdgeInsets.only(top: 8.0, right:8.0),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            data['name'],
                                            style: FlutterFlowTheme.of(context).title3
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            data['bio'],
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // SliverPersistentHeader(
            //   delegate: _SliverAppBarDelegate(
            //
            //   ),
            //   pinned: true,
            // ),
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
          ],
        ),
      ),
      ),
  );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}