import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_x/const/constant.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/post_model.dart';
import 'package:project_x/models/user_model.dart';
import 'package:project_x/screens/community/comment_screen.dart';
import 'package:project_x/screens/community/fullScreenImage_screen.dart';

class PostItem extends StatefulWidget {
  final UserModel user;
  final Post post;

  PostItem({required this.user, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.post.likedBy.contains(_user?.uid)) {
      _isLiked = true;
    }
    _likesCount = widget.post.likedBy.length;
  }

  void _toggleLike() {
    setState(() {

      if (_isLiked) {
        _likesCount -= 1;
      } else {
        _likesCount += 1;
      }
      _isLiked = !_isLiked;
    });
    updateLikes(widget.post, _user!.uid);
    log('user ${_user!.uid}');
  }

  void updateLikes(Post post, String userId) async {
    try {
      CollectionReference postsRef = _firestore.collection('posts');
      QuerySnapshot querySnapshot = await postsRef.where('id', isEqualTo: post.Id).get();
      String docId = querySnapshot.docs[0].id;
      print(docId);
      DocumentSnapshot postSnapshot = await postsRef.doc(docId).get();
      if (postSnapshot.exists) {
        if (post.likedBy.contains(userId)) {
          await postsRef.doc(docId).update({
            'likedBy': FieldValue.arrayRemove([userId]),
            'likes': post.likedBy.length - 1
          });
        } else {
          await postsRef.doc(docId).update({
            'likedBy': FieldValue.arrayUnion([userId]),
            'likes': post.likedBy.length + 1
          });
        }
      } else {
        print('Post document not found');
      }
    } catch (e) {
      print('Error updating likes: $e');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.avatarUrl),
              radius: 25.0,
            ),

            title: Text(
                widget.user.name,
                style: FlutterFlowTheme.of(context).bodyText1),
            subtitle: Text(
                timeAgoSinceDate(widget.post.timestamp),
                style: FlutterFlowTheme.of(context).bodySmall),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                  child: Text(
                      widget.post.content,
                      style: FlutterFlowTheme.of(context).bodyText1),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imageUrl: widget.post.imageUrl,
                        ),
                      ),
                    );
                  },
                  child: widget.post.imageUrl.isNotEmpty
                      ? Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    height: 300,
                    width: 500,
                  )
                      : SizedBox.shrink(),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 2,
                  endIndent: 2,
                  color: Colors.black38,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: _isLiked ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border),
                      onPressed: _toggleLike,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text('$_likesCount',
                      style: FlutterFlowTheme.of(context).bodyText2),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        'likes',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_comment_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(postId : widget.post.Id, post : widget.post),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        widget.post.comments.length.toString(),
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        'Comments',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


String timeAgoSinceDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays == 2) {
    return '2 days ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours == 1) {
    return 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes == 1) {
    return 'A minute ago';
  } else {
    return 'Just now';
  }
}

