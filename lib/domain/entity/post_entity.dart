import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
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
  final int likeCount;
  final int commentCount;
  final bool deleted;

  PostEntity({
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
    required this.likeCount,
    required this.commentCount,
    required this.deleted,
  });
}
