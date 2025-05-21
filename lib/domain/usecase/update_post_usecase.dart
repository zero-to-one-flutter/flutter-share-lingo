// lib/domain/usecase/update_post_usecase.dart
import '../entity/post_entity.dart';
import '../repository/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<void> call({
    required String id,
    required String uid,
    required String userName,
    required String userProfileImage,
    required String userNativeLanguage,
    required String userTargetLanguage,
    required String content,
    required List<String> imageUrl,
    required List<String> tags,
    required DateTime createdAt,
    required int likeCount,
    required int commentCount,
  }) async {
    final post = PostEntity(
      id: id,
      uid: uid,
      userName: userName,
      userProfileImage: userProfileImage,
      userNativeLanguage: userNativeLanguage,
      userTargetLanguage: userTargetLanguage,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      likeCount: likeCount,
      commentCount: commentCount,
      deleted: false,
    );
    await repository.updatePost(post);
  }
}
