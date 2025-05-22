import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String id;
  final String uid;
  final String userName;
  final String userProfileImage;
  final String userNativeLanguage;
  final String userTargetLanguage;
  final String? userDistrict;
  final GeoPoint? userLocation;
  final String? userBio;
  final DateTime? userBirthdate;
  final String? userHobbies;
  final String? userLanguageLearningGoal;
  final String content;
  final List<String> imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  // final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final bool deleted;

  const PostEntity({
    required this.id,
    required this.uid,
    required this.userName,
    required this.userProfileImage,
    required this.userNativeLanguage,
    required this.userTargetLanguage,
    this.userDistrict,
    this.userLocation,
    this.userBio,
    this.userBirthdate,
    this.userHobbies,
    this.userLanguageLearningGoal,
    required this.content,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    // required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.deleted,
  });

  PostEntity copyWith({
    String? id,
    String? uid,
    String? userName,
    String? userProfileImage,
    String? userNativeLanguage,
    String? userTargetLanguage,
    String? content,
    List<String>? imageUrl,
    List<String>? tags,
    DateTime? createdAt,
    // DateTime? updatedAt,
    int? likeCount,
    int? commentCount,
    bool? deleted,
  }) {
    return PostEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      userNativeLanguage: userNativeLanguage ?? this.userNativeLanguage,
      userTargetLanguage: userTargetLanguage ?? this.userTargetLanguage,
      userDistrict: userDistrict,
      userLocation: userLocation,
      userBio: userBio,
      userBirthdate: userBirthdate,
      userHobbies: userHobbies,
      userLanguageLearningGoal: userLanguageLearningGoal,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      deleted: deleted ?? this.deleted,
    );
  }
}
