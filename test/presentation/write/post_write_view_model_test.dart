import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/app_user.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/update_post_usecase.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

import '../../mock/mock_post_repository.dart';
import '../../mock/mock_upload_image_usecase.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class MockUpdatePostUseCase extends Mock implements UpdatePostUseCase {}

void main() {
  late MockPostRepository mockRepository;
  late MockUploadImageUseCase mockUploadImageUseCase;
  late MockUpdatePostUseCase mockUpdatePostUseCase;
  late CreatePostUseCase createPostUseCase;
  late PostWriteViewModel viewModel;
  late MockWidgetRef ref;
  late AppUser mockUser;

  setUpAll(() {
    registerFallbackValue(
      PostEntity(
        id: 'dummy',
        userName: 'user',
        userProfileImage: 'image.jpg',
        userNativeLanguage: 'KO',
        userTargetLanguage: 'EN',
        uid: 'dummy',
        content: 'dummy',
        imageUrl: [],
        tags: [],
        createdAt: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        deleted: false,
      ),
    );

    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockRepository = MockPostRepository();
    mockUploadImageUseCase = MockUploadImageUseCase();
    mockUpdatePostUseCase = MockUpdatePostUseCase();
    createPostUseCase = CreatePostUseCase(mockRepository);

    viewModel = PostWriteViewModel(
      createPostUseCase: createPostUseCase,
      uploadImageUseCase: mockUploadImageUseCase,
      updatePostUseCase: mockUpdatePostUseCase,
    );

    ref = MockWidgetRef();
    mockUser = AppUser(id: 'id', name: 'name');
  });

  test('submitPost 성공 시 AsyncData 상태로 변경됨', () async {
    final testPost = PostEntity(
      id: 'post-id',
      userName: 'user',
      userProfileImage: 'image.jpg',
      userNativeLanguage: 'KO',
      userTargetLanguage: 'EN',
      uid: 'test-uid',
      content: '테스트 글입니다',
      imageUrl: [],
      tags: ['kor', 'eng'],
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(() => ref.read(userGlobalViewModelProvider)).thenReturn(mockUser);
    when(() => mockRepository.createPost(any())).thenAnswer((_) async {});
    when(
      () => mockUploadImageUseCase.call(
        uid: any(named: 'uid'),
        imageBytes: any(named: 'imageBytes'),
      ),
    ).thenAnswer((_) async => '');

    await viewModel.submitPost(
      ref: ref,
      uid: testPost.uid,
      content: testPost.content,
      tags: testPost.tags,
      imageBytesList: [],
    );

    expect(viewModel.state, const AsyncData<void>(null));
  });
}
