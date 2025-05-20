import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_initial_posts_usecase.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  MockPostRepository? mockPostRepository;
  FetchInitialPostsUsecase? fetchInitialPostsUsecase;

  setUp(() {
    mockPostRepository = MockPostRepository();
    fetchInitialPostsUsecase = FetchInitialPostsUsecase(mockPostRepository!);
  });

  test('FetchInitialPostsUsecase test', () async {
    when(() => mockPostRepository!.fetchInitialPosts()).thenAnswer(
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
    final result = await fetchInitialPostsUsecase!.execute();

    expect(result.length, 1);
    expect(result.first.content, 'Nice to meet you');
    expect(result.first.deleted, false);
  });
}
