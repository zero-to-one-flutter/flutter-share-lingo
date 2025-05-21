import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_lastest_posts_usecase.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  MockPostRepository? mockPostRepository;
  FetchLastestPostsUsecase? fetchLatestPostsUsecase;

  setUp(() {
    mockPostRepository = MockPostRepository();
    fetchLatestPostsUsecase = FetchLastestPostsUsecase(mockPostRepository!);
  });

  // PostEntity type 등록
  setUpAll(() {
    registerFallbackValue(
      PostEntity(
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
      ),
    );
  });

  test('FetchLastestPostsUsecase', () async {
    final firstPost = PostEntity(
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

    when(() => mockPostRepository!.fetchLatestPosts(any())).thenAnswer(
      (invocation) async => [
        PostEntity(
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
        ),
      ],
    );
    final result = await fetchLatestPostsUsecase!.execute(firstPost);

    expect(result.length, 1);
    expect(result.first.content, '내용입니다');
    expect(result.first.commentCount, 0);
  });
}
