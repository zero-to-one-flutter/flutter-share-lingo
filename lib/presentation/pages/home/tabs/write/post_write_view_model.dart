import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';

class PostWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final CreatePostUseCase createPostUseCase;

  PostWriteViewModel(this.createPostUseCase) : super(const AsyncData(null));

  Future<void> submitPost({
    required String uid,
    required String content,
    required List<String> tags,
    String imageUrl = '',
  }) async {
    state = const AsyncLoading();

    final post = PostEntity(
      uid: uid,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: DateTime.now(), // 실제 저장은 serverTimestamp로 덮어씀
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    try {
      await createPostUseCase(post);
      state = const AsyncData(null);
    } catch (e, st) {
      print("Firestore 저장 실패: $e");
      print(st);
      state = AsyncError(e, st);
    }
  }
}

final postWriteViewModelProvider =
    StateNotifierProvider<PostWriteViewModel, AsyncValue<void>>((ref) {
      final useCase = ref.read(createPostUseCaseProvider);
      return PostWriteViewModel(useCase);
    });

final postsProvider = StreamProvider.autoDispose((ref) {
  final snapshots =
      FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots();

  return snapshots;
});
