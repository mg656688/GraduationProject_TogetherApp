import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_icon_button.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/post_model.dart';
import 'package:project_x/widgets/community/comment_item.dart';
import 'package:project_x/widgets/custom_bottom_nav_bar.dart';
import '../../models/comment_model.dart';
import '../../models/user_model.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final Post post;

  CommentScreen({required this.postId, required this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();

}

class _CommentScreenState extends State<CommentScreen> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();
  late Stream<QuerySnapshot> _comments = Stream.empty();


  @override
  void initState() {
    super.initState();
    if (widget.postId.isNotEmpty) {
      _comments = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots();
    }
    else print(widget.postId);
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
                builder: (context) => CustomNavBar(selectedIndex: 0),
              ),
                  (route) => false,
            );
            },
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            'Comments',
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _comments,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data = documents[index].data() as Map<String,
                        dynamic>;
                    log('Data : $data');
                    final comment = Comment.fromJson(data);
                    final user = UserModel.fromFirebaseUser(data['user']);
                    return CommentCard(comment: comment, user: user);
                  },
                );
              },
            ),
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 12),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Leave a comment..',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: kPrimaryColor,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send,
                  size: 26,),
                  onPressed: () {
                    _submitComment();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isNotEmpty && widget.postId.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'user': {
          'id': user.uid,
          'name': user.displayName ?? user.email!.split('@')[0],
          'avatarUrl': user.photoURL ?? '',
        },
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'postId': widget.postId
      });
      CollectionReference postsRef = _firestore.collection('posts');
      QuerySnapshot querySnapshot =
          await postsRef.where('id', isEqualTo: widget.postId).get();
      if (querySnapshot.docs.length > 0) {
        String docId = querySnapshot.docs[0].id;
        await postsRef.doc(docId).update({
          'comments': FieldValue.arrayUnion([content]),
        });
      }
      _commentController.clear();
    }
    else {
      print('Failed to post the comment');
      print(widget.postId);
    }
  }

  // Future<void> _updateCommentsCount(String post_id, String content) async {
  //   print(content);
  //   CollectionReference postsRef = _firestore.collection('posts');
  //   QuerySnapshot querySnapshot =
  //   await postsRef.where('id', isEqualTo: post_id).get();
  //   if (querySnapshot.docs.length > 0) {
  //     String docId = querySnapshot.docs[0].id;
  //     await postsRef.doc(docId).update({
  //       'comments': FieldValue.arrayUnion([content]),
  //     });
  //   }
  // }

}