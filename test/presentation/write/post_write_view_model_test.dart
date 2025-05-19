import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';

import '../../mock/mock_post_repository.dart';

void main() {
  late MockPostRepository mockRepository;
  late CreatePostUseCase useCase;
  late PostWriteViewModel viewModel;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = CreatePostUseCase(mockRepository);
    viewModel = PostWriteViewModel(useCase);
  });

  test('✅ submitPost 성공 시 AsyncData 상태로 변경됨', () async {
    // arrange
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

    // act
    when(
      () => mockRepository.createPost(any()),
    ).thenAnswer((_) async => Future.value());

    await viewModel.submitPost(
      uid: testPost.uid,
      content: testPost.content,
      tags: testPost.tags,
    );

    // assert
    expect(viewModel.debugState, const AsyncData<void>(null));
  });

  test('❌ submitPost 실패 시 AsyncError 상태로 변경됨', () async {
    when(
      () => mockRepository.createPost(any()),
    ).thenThrow(Exception('Firestore 에러'));

    await viewModel.submitPost(
      uid: 'test-uid',
      content: '에러 테스트',
      tags: ['error'],
    );

    expect(viewModel.debugState.hasError, true);
  });

  test('⚠️ 빈 content일 경우에도 호출 가능 (후처리 필요)', () async {
    when(
      () => mockRepository.createPost(any()),
    ).thenAnswer((_) async => Future.value());

    await viewModel.submitPost(uid: 'test-uid', content: '', tags: []);

    expect(viewModel.debugState, const AsyncData<void>(null));
  });
}
