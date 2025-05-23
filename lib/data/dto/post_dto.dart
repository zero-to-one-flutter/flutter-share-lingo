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
  final String? userBio;
  final Timestamp? userBirthdate;
  final String? userHobbies;
  final String? userLanguageLearningGoal;
  final String content;
  final List<String> imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final Timestamp? updatedAt;
  final int likeCount;
  final int commentCount;
  final bool deleted;

  // 투표 관련 필드 추가
  final bool isPoll;
  final String? pollQuestion;
  final List<String>? pollOptions;
  final Map<String, int>? pollVotes;
  final Map<String, int>? userVotes;

  PostDto({
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
    required this.commentCount,
    required this.deleted,
    this.isPoll = false,
    this.pollQuestion,
    this.pollOptions,
    this.pollVotes,
    this.userVotes,
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
      userBio: map['userBio'],
      userBirthdate: map['userBirthdate'],
      userHobbies: map['userHobbies'],
      userLanguageLearningGoal: map['userLanguageLearningGoal'],
      content: map['content'] ?? '',
      imageUrl: List<String>.from(map['imageUrl'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt'] as Timestamp?,
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      deleted: map['deleted'] ?? false,

      // 투표 관련 매핑
      isPoll: map['isPoll'] ?? false,
      pollQuestion: map['pollQuestion'],
      pollOptions:
          map['pollOptions'] != null
              ? List<String>.from(map['pollOptions'])
              : null,
      pollVotes:
          map['pollVotes'] != null
              ? Map<String, int>.from(map['pollVotes'])
              : null,
      userVotes:
          map['userVotes'] != null
              ? Map<String, int>.from(map['userVotes'])
              : null,
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
      'userBio': userBio,
      'userBirthdate': userBirthdate,
      'userHobbies': userHobbies,
      'userLanguageLearningGoal': userLanguageLearningGoal,
      'content': content,
      'imageUrl': imageUrl,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'deleted': deleted,

      // 투표 관련 필드도 포함
      'isPoll': isPoll,
      'pollQuestion': pollQuestion,
      'pollOptions': pollOptions,
      'pollVotes': pollVotes,
      'userVotes': userVotes,
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
      userBio: userBio,
      userBirthdate: userBirthdate?.toDate(),
      userHobbies: userHobbies,
      userLanguageLearningGoal: userLanguageLearningGoal,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt?.toDate(),
      likeCount: likeCount,
      commentCount: commentCount,
      deleted: deleted,

      // 투표 필드 매핑
      isPoll: isPoll,
      pollQuestion: pollQuestion,
      pollOptions: pollOptions,
      pollVotes: pollVotes,
      userVotes: userVotes,
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
      userBio: entity.userBio,
      userBirthdate:
          entity.userBirthdate != null
              ? Timestamp.fromDate(entity.userBirthdate!)
              : null,
      userHobbies: entity.userHobbies,
      userLanguageLearningGoal: entity.userLanguageLearningGoal,
      content: entity.content,
      imageUrl: entity.imageUrl,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt:
          entity.updatedAt != null
              ? Timestamp.fromDate(entity.updatedAt!)
              : null,
      likeCount: entity.likeCount,
      commentCount: entity.commentCount,
      deleted: entity.deleted,

      //  투표 필드 매핑
      isPoll: entity.isPoll,
      pollQuestion: entity.pollQuestion,
      pollOptions: entity.pollOptions,
      pollVotes: entity.pollVotes,
      userVotes: entity.userVotes,
    );
  }
}
