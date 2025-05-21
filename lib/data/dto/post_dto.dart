import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/post_entity.dart';

class PostDto {
  final String id;
  final String uid;
  final String userName;
  final String userProfileImage;
  final String userNativeLanguage;
  final String userTargetLanguage;
  final String? userDistrict;
  final GeoPoint? userLocation;
  final String content;
  final List<String> imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final bool deleted;

  PostDto({
    required this.id,
    required this.uid,
    required this.userName,
    required this.userProfileImage,
    required this.userNativeLanguage,
    required this.userTargetLanguage,
    this.userDistrict,
    this.userLocation,
    required this.content,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.deleted,
  });

  factory PostDto.fromMap(String id, Map<String, dynamic> map) {
    return PostDto(
      id: id,
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      userNativeLanguage: map['userNativeLanguage'] ?? '',
      userTargetLanguage: map['userTargetLanguage'] ?? '',
      userDistrict: map['userDistrict'],
      userLocation: map['userLocation'] as GeoPoint?,
      content: map['content'] ?? '',
      imageUrl: List<String>.from(map['imageUrl'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      deleted: map['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'userNativeLanguage': userNativeLanguage,
      'userTargetLanguage': userTargetLanguage,
      'userDistrict': userDistrict,
      'userLocation': userLocation,
      'content': content,
      'imageUrl': imageUrl,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'deleted': deleted,
    };
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      uid: uid,
      userName: userName,
      userProfileImage: userProfileImage,
      userNativeLanguage: userNativeLanguage,
      userTargetLanguage: userTargetLanguage,
      userDistrict: userDistrict,
      userLocation: userLocation,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likeCount: likeCount,
      commentCount: commentCount,
      deleted: deleted,
    );
  }

  static PostDto fromEntity(PostEntity entity) {
    return PostDto(
      id: entity.id,
      uid: entity.uid,
      userName: entity.userName,
      userProfileImage: entity.userProfileImage,
      userNativeLanguage: entity.userNativeLanguage,
      userTargetLanguage: entity.userTargetLanguage,
      userDistrict: entity.userDistrict,
      userLocation: entity.userLocation,
      content: entity.content,
      imageUrl: entity.imageUrl,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likeCount: entity.likeCount,
      commentCount: entity.commentCount,
      deleted: entity.deleted,
    );
  }
}
