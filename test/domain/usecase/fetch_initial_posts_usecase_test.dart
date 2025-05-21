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
    final result = await fetchInitialPostsUsecase!.execute();

    expect(result.length, 1);
    expect(result.first.content, '내용입니다');
    expect(result.first.deleted, false);
  });
}
