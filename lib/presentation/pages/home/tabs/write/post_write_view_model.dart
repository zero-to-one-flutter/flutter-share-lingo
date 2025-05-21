import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/upload_image_usecase.dart';

class PostWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final CreatePostUseCase createPostUseCase;
  final UploadImageUseCase uploadImageUseCase;

  PostWriteViewModel({
    required this.createPostUseCase,
    required this.uploadImageUseCase,
  }) : super(const AsyncData(null));

  Future<void> submitPost({
    required String uid,
    required String content,
    required List<String> tags,
    required List<Uint8List> imageBytesList,
  }) async {
    state = const AsyncLoading();

    try {
      final imageUrls = await Future.wait(
        imageBytesList.map(
          (imageBytes) => uploadImageUseCase(uid: uid, imageBytes: imageBytes),
        ),
      );

      final post = PostEntity(
        uid: uid,
        content: content,
        imageUrl: imageUrls,
        tags: tags,
        createdAt: DateTime.now(),
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
}

final postWriteViewModelProvider =
    StateNotifierProvider.autoDispose<PostWriteViewModel, AsyncValue<void>>((
      ref,
    ) {
      final createUseCase = ref.read(createPostUseCaseProvider);
      final uploadUseCase = ref.read(uploadImageUseCaseProvider);
      return PostWriteViewModel(
        createPostUseCase: createUseCase,
        uploadImageUseCase: uploadUseCase,
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
