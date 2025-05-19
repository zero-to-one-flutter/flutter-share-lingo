import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';

import '../../mock/mock_post_repository.dart';

void main() {
  late MockPostRepository mockRepository;
  late CreatePostUseCase useCase;
  late PostWriteViewModel viewModel;

  setUpAll(() {
    // ✅ PostEntity fallback 등록
    registerFallbackValue(
      PostEntity(
        uid: 'dummy',
        content: 'dummy',
        imageUrl: '',
        tags: [],
        createdAt: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        deleted: false,
      ),
    );
  });

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = CreatePostUseCase(mockRepository);
    viewModel = PostWriteViewModel(useCase);
  });

  test('✅ submitPost 성공 시 AsyncData 상태로 변경됨', () async {
    final testPost = PostEntity(
      uid: 'test-uid',
      content: '테스트 글입니다',
      imageUrl: '',
      tags: ['kor', 'eng'],
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(
      () => mockRepository.createPost(any()),
    ).thenAnswer((_) async => Future.value());

    await viewModel.submitPost(
      uid: testPost.uid,
      content: testPost.content,
      tags: testPost.tags,
    );

    expect(viewModel.state, const AsyncData<void>(null));
  });
}
