import 'package:share_lingo/domain/repository/post_repository.dart';

class UnlikePostUseCase {
  final PostRepository repository;

  UnlikePostUseCase(this.repository);

  Future<void> execute(String postId, String userId) async {
    await repository.unlikePost(postId, userId);
  }
}
