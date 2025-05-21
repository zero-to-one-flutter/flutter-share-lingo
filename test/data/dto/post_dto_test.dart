import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

void main() {
  test('PostDto <-> Entity 변환 테스트', () {
    final entity = PostEntity(
      id: 'testId',
      uid: 'test123',
      userName: 'user',
      userProfileImage: 'abcd.jpg',
      userNativeLanguage: 'KO',
      userTargetLanguage: 'EN',
      userDistrict: null,
      userLocation: null,
      content: '내용입니다',
      imageUrl: [],
      tags: ['kor'],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    final dto = PostDto.fromEntity(entity);
    final map = dto.toMap();

    expect(map['uid'], entity.uid);
    expect(map['content'], entity.content);
    expect(map['tags'], entity.tags);

    final restoredDto = PostDto.fromMap('testId', {
      'uid': 'test123',
      'userName': 'user',
      'userProfileImage': 'abcd.jpg',
      'userNativeLanguage': 'KO',
      'userTargetLanguage': 'EN',
      'userDistrict': null,
      'userLocation': null,
      'content': '내용입니다',
      'imageUrl': [],
      'tags': ['kor'],
      'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
      'updatedAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
      'likeCount': 0,
      'commentCount': 0,
      'deleted': false,
    });

    final restoredEntity = restoredDto.toEntity();

    expect(restoredEntity.id, 'testId');
    expect(restoredEntity.uid, 'test123'); // 여기서 에러 나면 map['uid']가 없음
    expect(restoredEntity.userName, 'user');
    expect(restoredEntity.content, '내용입니다');
  });
}
