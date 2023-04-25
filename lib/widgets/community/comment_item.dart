import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
import 'package:project_x/models/comment_model.dart';
import 'package:project_x/models/user_model.dart';
import '../../const/constant.dart';
import '../../responsive/responsive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  final UserModel user;

  CommentCard({
    super.key,
    required this.comment,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Responsive(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(
                      comment.user.avatarUrl,
                    ),
                    radius: 22,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: BoxConstraints(maxWidth: c_width),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${comment.user.name}',
                            style: FlutterFlowTheme.of(context).bodyText1
                          ),
                          Text(
                              textAlign: TextAlign.left,
                              comment.content,
                              style: FlutterFlowTheme.of(context).bodySmall,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 3, 0, 0),
              child: Row(
                children: [
                  SizedBox(width: 2),
                  Text(
                    timeAgoSinceDateComment(comment.timestamp),
                    style: FlutterFlowTheme.of(context).bodyText2
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }




}