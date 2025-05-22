import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/comment.dart';

class CommentDto {
  final String id;
  final String uid;
  final String userName;
  final String userProfileImage;
  final String content;
  final Timestamp createdAt;

  CommentDto({
    required this.id,
    required this.uid,
    required this.userName,
    required this.userProfileImage,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromMap(String id, Map<String, dynamic> map) {
    return CommentDto(
      id: id,
      uid: map['uid'],
      userName: map['userName'],
      userProfileImage: map['userProfileImage'],
      content: map['content'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'userName': userName,
    'userProfileImage': userProfileImage,
    'content': content,
    'createdAt': createdAt,
  };

  Comment toEntity() {
    return Comment(
      id: id,
      uid: uid,
      userName: userName,
      userProfileImage: userProfileImage,
      content: content,
      createdAt: createdAt.toDate(),
    );
  }

  static CommentDto fromEntity(Comment comment) {
    return CommentDto(
      id: comment.id,
      uid: comment.uid,
      userName: comment.userName,
      userProfileImage: comment.userProfileImage,
      content: comment.content,
      createdAt: Timestamp.fromDate(comment.createdAt),
    );
  }
}
