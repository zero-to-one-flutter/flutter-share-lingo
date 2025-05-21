import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockRepository;
  late CreatePostUseCase useCase;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = CreatePostUseCase(mockRepository);
  });

  test('CreatePostUseCase - 성공 케이스', () async {
    final post = PostEntity(
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
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(
      () => mockRepository.createPost(post),
    ).thenAnswer((_) async => Future.value());

    await useCase(post);

    verify(() => mockRepository.createPost(post)).called(1);
  });

  test('CreatePostUseCase - 예외 발생 시 throw', () async {
    final post = PostEntity(
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
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(() => mockRepository.createPost(post)).thenThrow(Exception('에러'));

    expect(() async => await useCase(post), throwsA(isA<Exception>()));
  });
}
