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
        uid: 'uid',
        content: 'content',
        imageUrl: ['imageUrl'],
        tags: ['tags'],
        createdAt: DateTime.now(),
        likeCount: 1,
        commentCount: 2,
        deleted: false,
      ),
    );
  });

  test('FetchOlderPostsUsecase', () async {
    final lastPost = PostEntity(
      uid: 'uid',
      content: 'content',
      imageUrl: ['imageUrl'],
      tags: ['tags'],
      createdAt: DateTime.now(),
      likeCount: 1,
      commentCount: 2,
      deleted: false,
    );

    when(() => mockPostRepository!.fetchOlderPosts(any())).thenAnswer(
      (invocation) async => [
        PostEntity(
          uid: 'a12345',
          content: 'Nice to meet you',
          imageUrl: ['abc.jpg'],
          tags: ['help', 'request'],
          createdAt: DateTime.now(),
          likeCount: 1,
          commentCount: 4,
          deleted: false,
        ),
      ],
    );
    final result = await fetchOlderPostsUsecase!.execute(lastPost);

    expect(result.length, 1);
    expect(result.first.content, 'Nice to meet you');
    expect(result.first.imageUrl[0], 'abc.jpg');
  });
}
