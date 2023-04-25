import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/models/user_model.dart';

final _firestore = FirebaseFirestore.instance;

class Post {
  Post({
    required this.Id,
    required this.content,
    required this.imageUrl,
    required this.user,
    required this.likes,
    required this.comments,
    required this.timestamp,
    required this.likedBy,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      Id: data['id'],
      content: data['content'],
      imageUrl: data['imageUrl'] ?? '',
      user: UserModel.fromFirebaseUser(data['user']),
      likes: data['likes'] ?? 0,
      comments: List<String>.from(data['comments'] ?? []),
      timestamp: data['timestamp'] == null
          ? DateTime.now()
          : (data['timestamp'] as Timestamp).toDate(),
      likedBy: Set<String>.from(data['likedBy'] ?? []),
    );
  }

  List<String> comments;
  String content;
  String Id;
  String imageUrl;
  int likes;
  final DateTime timestamp;
  UserModel user;
  Set<String> likedBy;

  Map<String, dynamic> toJson() => {
    'id': Id,
    'content': content,
    'imageUrl': imageUrl,
    'user': user.toJson(),
    'likes': likes,
    'comments': comments,
    'timestamp': timestamp.toIso8601String(),
    'likedBy': List<String>.from(likedBy),
  };

  // void toggleLike(String userId) {
  //   if (likedBy.contains(userId)) {
  //     likedBy.remove(userId);
  //     likes = likes - 1;
  //   } else {
  //     likedBy.add(userId);
  //     likes = likes + 1;
  //   }
  // }


  void addComment(String comment) {
    comments.add(comment);
  }
}
