import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/models/post_model.dart';
import 'package:project_x/models/user_model.dart';
import 'package:project_x/widgets/community/post_item.dart';
import 'package:project_x/widgets/drawer.dart';


class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _firestore = FirebaseFirestore.instance;
  var _postsSnapshot = null;

  Future<void> _refreshPosts() async {
    // Get the latest posts
    final snapshot = await _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    // Update the UI with the new data
    setState(() {
      _postsSnapshot = snapshot; // Store the new snapshot data
    });
  }

  // Future<void> _refreshPosts() async {
  //   // Get the latest posts
  //   final snapshot = await _firestore
  //       .collection('posts')
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //   // Update the UI with the new data
  //   setState(() {
  //     _posts = snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
  //     print(_posts);
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Together'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(48, 64, 34, 100),
      ),
      drawer: customDrawer(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child:StreamBuilder<QuerySnapshot>(
                stream: _postsSnapshot != null ? Stream.fromFuture(Future.value(_postsSnapshot)) :
                _firestore.collection('posts').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
                    return Center(child: Text('No posts available.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      final user = UserModel.fromFirebaseUser(data['user']);
                      final post = Post.fromJson(data);
                      return PostItem(user: user, post: post);
                    },
                  );
                },
              ),
              // child: StreamBuilder<QuerySnapshot>(
              //   stream: _firestore
              //       .collection('posts')
              //       .orderBy('timestamp', descending: true)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return Center(child: Text('Error: ${snapshot.error}'));
              //     }
              //     if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
              //       return Center(child: Text('No posts available.'));
              //     }
              //     return ListView.builder(
              //       itemCount: snapshot.data!.docs.length,
              //       itemBuilder: (context, index) {
              //         final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              //         final user = UserModel.fromFirebaseUser(data['user']);
              //         final post = Post.fromJson(data);
              //         return PostItem(user: user, post: post);
              //       },
              //     );
              //     //   return ListView.builder(
              //     //     itemCount: _posts.length,
              //     //     itemBuilder: (context, index) {
              //     //       final user = UserModel.fromFirebaseUser(_posts[index].user as Map<String, dynamic>);
              //     //       final post = Post.fromJson(_posts[index] as Map<String, dynamic>);
              //     //       return PostItem(user: user, post: post);
              //     //     },
              //     //   );
              //     // },
              //   },
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
