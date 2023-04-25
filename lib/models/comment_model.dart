import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/models/user_model.dart';

class Comment {
  final String id;
  final String postId;
  final String content;
  final UserModel user;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      user: UserModel.fromFirebaseUser(json['user']),
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId':postId,
      'username': user.toJson(),
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp)
    };
  }
}
String timeAgoSinceDateComment(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 2) {
    return '${difference.inDays}d';
  } else if (difference.inDays == 2) {
    return '2d';
  } else if (difference.inDays == 1) {
    return '1d';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours}h';
  } else if (difference.inHours == 1) {
    return '1h';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes}m';
  } else if (difference.inMinutes == 1) {
    return '1m';
  } else {
    return 'Just now';
  }
}
