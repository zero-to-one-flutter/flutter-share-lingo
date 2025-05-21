// lib/domain/usecase/update_post_usecase.dart
import '../repository/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<void> call({
    required String id,
    required String content,
    required List<String> imageUrls,
  }) async {
    await repository.updatePost(id: id, content: content, imageUrls: imageUrls);
  }
}
