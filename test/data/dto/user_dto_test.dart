import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_lingo/data/dto/user_dto.dart';
import 'package:share_lingo/domain/entity/app_user.dart';

void main() {
  final DateTime testDate = DateTime(2025, 05, 17);
  final Timestamp testTimestamp = Timestamp.fromDate(testDate);

  group('UserDto', () {
    test('fromMap converts map data to UserDto correctly', () {
      // Arrange
      final String id = 'test-user-id';
      final Map<String, dynamic> userData = {
        'name': 'Test User',
        'createdAt': testTimestamp,
        'email': 'test@example.com',
        'profileImage': 'https://example.com/profile.jpg',
        'nativeLanguage': 'English',
        'targetLanguage': 'Korean',
        'bio': 'Test bio',
        'birthdate': testTimestamp,
        'hobbies': 'Casual',
        'languageLearningGoal': 'Fluency'
      };

      // Act
      final userDto = UserDto.fromMap(id, userData);

      // Assert
      expect(userDto.id, equals(id));
      expect(userDto.name, equals('Test User'));
      expect(userDto.createdAt, equals(testTimestamp));
      expect(userDto.email, equals('test@example.com'));
      expect(userDto.profileImage, equals('https://example.com/profile.jpg'));
      expect(userDto.nativeLanguage, equals('English'));
      expect(userDto.targetLanguage, equals('Korean'));
      expect(userDto.bio, equals('Test bio'));
      expect(userDto.birthdate, equals(testTimestamp));
      expect(userDto.hobbies, equals('Casual'));
      expect(userDto.languageLearningGoal, equals('Fluency'));
    });

    test('fromMap handles missing optional fields', () {
      // Arrange
      final String id = 'test-user-id';
      final Map<String, dynamic> userData = {
        'name': 'Test User',
        'createdAt': testTimestamp,
      };

      // Act
      final userDto = UserDto.fromMap(id, userData);

      // Assert
      expect(userDto.id, equals(id));
      expect(userDto.name, equals('Test User'));
      expect(userDto.createdAt, equals(testTimestamp));
      expect(userDto.email, isNull);
      expect(userDto.profileImage, isNull);
      expect(userDto.nativeLanguage, isNull);
      expect(userDto.targetLanguage, isNull);
      expect(userDto.bio, isNull);
      expect(userDto.birthdate, isNull);
      expect(userDto.hobbies, isNull);
      expect(userDto.languageLearningGoal, isNull);
    });

    test('fromEntity converts AppUser to UserDto correctly', () {
      // Arrange
      final appUser = AppUser(
        id: 'test-user-id',
        name: 'Test User',
        createdAt: testDate,
        email: 'test@example.com',
        profileImage: 'https://example.com/profile.jpg',
        nativeLanguage: 'English',
        targetLanguage: 'Korean',
        bio: 'Test bio',
        birthdate: testDate,
        hobbies: 'Casual',
        languageLearningGoal: 'Fluency',
      );

      // Act
      final userDto = UserDto.fromEntity(appUser);

      // Assert
      expect(userDto.id, equals(appUser.id));
      expect(userDto.name, equals(appUser.name));
      expect(userDto.createdAt, equals(Timestamp.fromDate(appUser.createdAt)));
      expect(userDto.email, equals(appUser.email));
      expect(userDto.profileImage, equals(appUser.profileImage));
      expect(userDto.nativeLanguage, equals(appUser.nativeLanguage));
      expect(userDto.targetLanguage, equals(appUser.targetLanguage));
      expect(userDto.bio, equals(appUser.bio));
      expect(userDto.birthdate, equals(Timestamp.fromDate(appUser.birthdate!)));
      expect(userDto.hobbies, equals(appUser.hobbies));
      expect(userDto.languageLearningGoal, equals(appUser.languageLearningGoal));
    });

    test('toMap converts UserDto to map correctly', () {
      // Arrange
      final userDto = UserDto(
        id: 'test-user-id',
        name: 'Test User',
        createdAt: testTimestamp,
        email: 'test@example.com',
        profileImage: 'https://example.com/profile.jpg',
        nativeLanguage: 'English',
        targetLanguage: 'Korean',
        bio: 'Test bio',
        birthdate: testTimestamp,
        hobbies: 'Casual',
        languageLearningGoal: 'Fluency',
      );

      // Act
      final map = userDto.toMap();

      // Assert
      expect(map['name'], equals('Test User'));
      expect(map['createdAt'], equals(testTimestamp));
      expect(map['email'], equals('test@example.com'));
      expect(map['profileImage'], equals('https://example.com/profile.jpg'));
      expect(map['nativeLanguage'], equals('English'));
      expect(map['targetLanguage'], equals('Korean'));
      expect(map['bio'], equals('Test bio'));
      expect(map['birthdate'], equals(testTimestamp));
      expect(map['hobbies'], equals('Casual'));
      expect(map['languageLearningGoal'], equals('Fluency'));
      // id should not be in the map as it's the document ID
      expect(map.containsKey('id'), isFalse);
    });

    test('toEntity converts UserDto to AppUser correctly', () {
      // Arrange
      final userDto = UserDto(
        id: 'test-user-id',
        name: 'Test User',
        createdAt: testTimestamp,
        email: 'test@example.com',
        profileImage: 'https://example.com/profile.jpg',
        nativeLanguage: 'English',
        targetLanguage: 'Korean',
        bio: 'Test bio',
        birthdate: testTimestamp,
        hobbies: 'Casual',
        languageLearningGoal: 'Fluency',
      );

      // Act
      final appUser = userDto.toEntity();

      // Assert
      expect(appUser.id, equals(userDto.id));
      expect(appUser.name, equals(userDto.name));
      expect(appUser.createdAt, equals(userDto.createdAt.toDate()));
      expect(appUser.email, equals(userDto.email));
      expect(appUser.profileImage, equals(userDto.profileImage));
      expect(appUser.nativeLanguage, equals(userDto.nativeLanguage));
      expect(appUser.targetLanguage, equals(userDto.targetLanguage));
      expect(appUser.bio, equals(userDto.bio));
      expect(appUser.birthdate, equals(userDto.birthdate?.toDate()));
      expect(appUser.hobbies, equals(userDto.hobbies));
      expect(appUser.languageLearningGoal, equals(userDto.languageLearningGoal));
    });
  });
}