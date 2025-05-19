import '../entity/post_entity.dart';
import '../repository/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<void> call(PostEntity post) async {
    await repository.createPost(post);
  }
}
