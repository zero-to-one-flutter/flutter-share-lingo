import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/data/data_source/post_remote_data_source.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late PostRemoteDataSource dataSource;

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    dataSource = PostRemoteDataSource(firestore: firestore);
  });

  test('✅ createPost 호출 시 Firestore 컬렉션 add 실행', () async {
    // given
    final dto = PostDto(
      uid: 'test-uid',
      content: '내용',
      imageUrl: '',
      tags: ['eng'],
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    // when
    when(() => firestore.collection('posts')).thenReturn(collection);
    when(
      () => collection.add(any()),
    ).thenAnswer((_) async => Future.value()); // sealed class 회피

    // then
    await dataSource.createPost(dto);
    verify(() => collection.add(dto.toMap())).called(1);
  });
}
