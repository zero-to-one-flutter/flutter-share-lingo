class Comment {
  final String id;
  final String uid;
  final String userName;
  final String userProfileImage;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.uid,
    required this.userName,
    required this.userProfileImage,
    required this.content,
    required this.createdAt,
  });
}
