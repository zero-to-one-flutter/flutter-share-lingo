import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/upload_image_usecase.dart';
import 'package:share_lingo/domain/usecase/update_post_usecase.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class PostWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final CreatePostUseCase createPostUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final UpdatePostUseCase updatePostUseCase;

  PostWriteViewModel({
    required this.createPostUseCase,
    required this.uploadImageUseCase,
    required this.updatePostUseCase,
  }) : super(const AsyncData(null));

  Future<void> submitPost({
    required WidgetRef ref,
    required String uid,
    required String content,
    required List<String> tags,
    required List<Uint8List> imageBytesList,
  }) async {
    state = const AsyncLoading();

    try {
      final user = ref.read(userGlobalViewModelProvider);
      if (user == null) {
        state = AsyncError("유저 정보 없음", StackTrace.current);
        return;
      }

      final imageUrls = await Future.wait(
        imageBytesList.map(
          (imageBytes) => uploadImageUseCase(uid: uid, imageBytes: imageBytes),
        ),
      );

      final post = PostEntity(
        id: '',
        uid: uid,
        userName: user.name,
        userProfileImage: user.profileImage ?? '',
        userNativeLanguage: user.nativeLanguage ?? '',
        userTargetLanguage: user.targetLanguage ?? '',
        userDistrict: user.district,
        userLocation: user.location,
        content: content,
        imageUrl: imageUrls,
        tags: tags,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        deleted: false,
      );

      await createPostUseCase(post);
      state = const AsyncData(null);
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  //  수정용 메서드 추가
  Future<void> updatePost({
    required String id,
    required String content,
    required String uid,
    required String userName,
    required String userProfileImage,
    required String userNativeLanguage,
    required String userTargetLanguage,
    required List<String> imageUrl,
    required List<String> tags,
    required DateTime createdAt,
    required int likeCount,
    required int commentCount,
  }) async {
    state = const AsyncLoading();
    try {
      await updatePostUseCase(
        id: id,
        content: content,
        uid: uid,
        userName: userName,
        userProfileImage: userProfileImage,
        userNativeLanguage: userNativeLanguage,
        userTargetLanguage: userTargetLanguage,
        imageUrl: imageUrl,
        tags: tags,
        createdAt: createdAt,
        likeCount: likeCount,
        commentCount: commentCount,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final postWriteViewModelProvider =
    StateNotifierProvider.autoDispose<PostWriteViewModel, AsyncValue<void>>((
      ref,
    ) {
      final createUseCase = ref.read(createPostUseCaseProvider);
      final uploadUseCase = ref.read(uploadImageUseCaseProvider);
      final updateUseCase = ref.read(updatePostUseCaseProvider);
      return PostWriteViewModel(
        createPostUseCase: createUseCase,
        uploadImageUseCase: uploadUseCase,
        updatePostUseCase: updateUseCase,
      );
    });

final postsProvider = StreamProvider.autoDispose((ref) {
  final snapshots =
      FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots();
  return snapshots;
});
