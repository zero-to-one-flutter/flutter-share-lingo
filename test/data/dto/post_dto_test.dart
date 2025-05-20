import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

void main() {
  test('PostDto <-> Entity 변환 테스트', () {
    final entity = PostEntity(
      uid: 'test123',
      content: '내용입니다',
      imageUrl: [],
      tags: ['kor'],
      createdAt: DateTime(2023, 1, 1),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    final dto = PostDto.fromEntity(entity);
    final map = dto.toMap();

    // createdAt은 FieldValue.serverTimestamp()로 고정되므로 비교 불가
    expect(map['uid'], entity.uid);
    expect(map['authorId'], entity.uid); // 🔥 authorId 필드도 확인
    expect(map['content'], entity.content);
    expect(map['tags'], entity.tags);
    expect(map['imageUrl'], entity.imageUrl);
    expect(map['likeCount'], entity.likeCount);
    expect(map['commentCount'], entity.commentCount);
    expect(map['deleted'], entity.deleted);

    // fromMap + toEntity 테스트 (createdAt은 실제 Timestamp 사용)
    final restoredDto = PostDto.fromMap({
      'uid': 'test123',
      'content': '내용입니다',
      'imageUrl': [],
      'tags': ['kor'],
      'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
      'likeCount': 0,
      'commentCount': 0,
      'deleted': false,
    });
    final restoredEntity = restoredDto.toEntity();
    expect(restoredEntity.uid, 'test123');
    expect(restoredEntity.content, '내용입니다');
    expect(restoredEntity.tags, ['kor']);
    expect(
      restoredEntity.createdAt.isAtSameMomentAs(DateTime(2023, 1, 1)),
      isTrue,
    );
  });
}
