import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/post_entity.dart';

class PostDto {
  final String uid;
  final String content;
  final List<String> imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool deleted;

  PostDto({
    required this.uid,
    required this.content,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.deleted,
  });

  factory PostDto.fromMap(Map<String, dynamic> map) {
    return PostDto(
      uid: map['uid'] ?? '',
      content: map['content'] ?? '',
      imageUrl: List<String>.from(map['imageUrl'] ?? []),

      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      deleted: map['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'authorId': uid,
      'content': content,
      'imageUrl': imageUrl,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(), // 업로드 시점 기준
      'likeCount': likeCount,
      'commentCount': commentCount,
      'deleted': deleted,
    };
  }

  PostEntity toEntity() {
    return PostEntity(
      uid: uid,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: createdAt,
      likeCount: likeCount,
      commentCount: commentCount,
      deleted: deleted,
    );
  }

  static PostDto fromEntity(PostEntity entity) {
    return PostDto(
      uid: entity.uid,
      content: entity.content,
      imageUrl: entity.imageUrl,
      tags: entity.tags,
      createdAt: entity.createdAt,
      likeCount: entity.likeCount,
      commentCount: entity.commentCount,
      deleted: entity.deleted,
    );
  }
}
