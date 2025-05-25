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
  final DateTime? updatedAt;
  final int likeCount;
  final List<String> likedBy;
  final int commentCount;
  final bool deleted;

  //  투표 관련 필드 추가
  final bool isPoll;
  final String? pollQuestion;
  final List<String>? pollOptions;
  final Map<String, int>? pollVotes;
  final Map<String, int>? userVotes;

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
    this.updatedAt,
    required this.likeCount,
    this.likedBy = const [],
    required this.commentCount,
    required this.deleted,
    //  투표 관련 필드 추가
    this.isPoll = false,
    this.pollQuestion,
    this.pollOptions,
    this.pollVotes,
    this.userVotes,
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
    DateTime? updatedAt,
    int? likeCount,
    List<String>? likedBy,

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
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
      commentCount: commentCount ?? this.commentCount,
      deleted: deleted ?? this.deleted,
    );
  }
}
