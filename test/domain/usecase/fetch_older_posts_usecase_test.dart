import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_older_posts_usecase.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  MockPostRepository? mockPostRepository;
  FetchOlderPostsUsecase? fetchOlderPostsUsecase;

  setUp(() {
    mockPostRepository = MockPostRepository();
    fetchOlderPostsUsecase = FetchOlderPostsUsecase(mockPostRepository!);
  });

  // PostEntity type 등록
  setUpAll(() {
    registerFallbackValue(
      PostEntity(
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
        // updatedAt: DateTime(2023, 1, 1),
        likeCount: 0,
        commentCount: 0,
        deleted: false,
      ),
    );
  });

  test('FetchOlderPostsUsecase', () async {
    final lastPost = PostEntity(
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
      // updatedAt: DateTime(2023, 1, 1),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(() => mockPostRepository!.fetchOlderPosts(any())).thenAnswer(
      (invocation) async => [
        PostEntity(
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
          // updatedAt: DateTime(2023, 1, 1),
          likeCount: 0,
          commentCount: 0,
          deleted: false,
        ),
      ],
    );
    final result = await fetchOlderPostsUsecase!.execute(lastPost);

    expect(result.length, 1);
    expect(result.first.content, '내용입니다');
    expect(result.first.userProfileImage, 'abcd.jpg');
  });
}
