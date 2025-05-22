import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/app_user.dart';

class UserDto {
  final String id;
  final String name;
  final Timestamp createdAt;
  final String? email;
  final String? profileImage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final String? bio;
  final Timestamp? birthdate;
  final String? hobbies;
  final String? languageLearningGoal;
  final String? district;
  final GeoPoint? location;

  UserDto({
    required this.id,
    required this.name,
    required this.createdAt,
    this.email,
    this.profileImage,
    this.nativeLanguage,
    this.targetLanguage,
    this.bio,
    this.birthdate,
    this.hobbies,
    this.languageLearningGoal,
    this.district,
    this.location,
  });

  factory UserDto.fromMap(String id, Map<String, dynamic> map) {
    return UserDto(
      id: id,
      name: map['name'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      email: map['email'],
      profileImage: map['profileImage'],
      nativeLanguage: map['nativeLanguage'],
      targetLanguage: map['targetLanguage'],
      bio: map['bio'],
      birthdate: map['birthdate'],
      hobbies: map['hobbies'],
      languageLearningGoal: map['languageLearningGoal'],
      district: map['district'],
      location: map['location'],

    );
  }

  factory UserDto.fromEntity(AppUser user) {
    return UserDto(
      id: user.id,
      name: user.name,
      createdAt: Timestamp.fromDate(user.createdAt),
      email: user.email,
      profileImage: user.profileImage,
      nativeLanguage: user.nativeLanguage,
      targetLanguage: user.targetLanguage,
      bio: user.bio,
      birthdate: user.birthdate != null ? Timestamp.fromDate(user.birthdate!) : null,
      hobbies: user.hobbies,
      languageLearningGoal: user.languageLearningGoal,
      district: user.district,
      location: user.location,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createdAt': createdAt,
      'email': email,
      'profileImage': profileImage,
      'nativeLanguage': nativeLanguage,
      'targetLanguage': targetLanguage,
      'bio': bio,
      'birthdate': birthdate,
      'hobbies': hobbies,
      'languageLearningGoal': languageLearningGoal,
      'district': district,
      'location': location,
    };
  }

  AppUser toEntity() {
    return AppUser(
      id: id,
      name: name,
      createdAt: createdAt.toDate(),
      email: email,
      profileImage: profileImage,
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
      bio: bio,
      birthdate: birthdate?.toDate(),
      hobbies: hobbies,
      languageLearningGoal: languageLearningGoal,
      district: district,
      location: location,
    );
  }
}
