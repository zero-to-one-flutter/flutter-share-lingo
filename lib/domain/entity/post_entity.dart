class PostEntity {
  final String uid;
  final String content;
  final String imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool deleted;

  PostEntity({
    required this.uid,
    required this.content,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.deleted,
  });
}
