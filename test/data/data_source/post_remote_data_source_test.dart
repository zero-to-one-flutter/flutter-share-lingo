import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/data/data_source/post_remote_data_source.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

//  sealed class는 Mock 금지 → Fake는 허용됨
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class FakeDocumentReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late PostRemoteDataSource dataSource;

  //  FakeDocumentReference는 반드시 등록
  setUpAll(() {
    registerFallbackValue(FakeDocumentReference());
  });

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    dataSource = PostRemoteDataSource(firestore: firestore);
  });

  test('Firestore add 호출 테스트', () async {
    final dto = PostDto(
      uid: 'test',
      content: '테스트',
      imageUrl: '',
      tags: ['flutter'],
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    //  mock 설정
    when(() => firestore.collection('posts')).thenReturn(collection);
    when(
      () => collection.add(any()),
    ).thenAnswer((_) async => FakeDocumentReference()); // 절대 null 아님

    //  실행
    await dataSource.createPost(dto);

    //  검증
    verify(() => collection.add(dto.toMap())).called(1);
  });
}
