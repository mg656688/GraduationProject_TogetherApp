class UserModel {
  String id;
  String name;
  String email;
  String avatarUrl;
  List  following;
  List  followers;
  int followingCount;
  int followerCount;
  int postCount;
  List  achievements;
  String bio;
  List  plants;



  UserModel(
      {required this.id,
        required this.name,
        required this.email,
        required this.avatarUrl,
        required this.following,
        required this.followers,
        required this.achievements,
        required this.bio,
        required this.plants,
        required this.followerCount,
        required this.followingCount,
        required this.postCount});

  factory UserModel.fromFirebaseUser(Map<String, dynamic> data) {
    return UserModel(
        id: data['id'],
        name: data['name'],
        email: data['email'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        following:data['following'] ?? [],
        followers:data['followers'] ?? [],
        achievements: data['achievements'] ?? [],
        bio: data['bio'] ?? '',
        plants:data['plants'] ?? [],
        followerCount: data['followerCount'] ?? 0,
        followingCount: data['followingCount'] ?? 0,
        postCount: data['postCount'] ?? 0);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'following': following,
    'followers': followers,
    'achievements':achievements,
    'bio': bio,
    'postCount' : postCount,
    'followingCount': followingCount,
    'followerCount': followerCount,
    'plants': plants,
  };
}