import 'package:share_lingo/domain/repository/post_repository.dart';

class LikePostUseCase {
  final PostRepository repository;

  LikePostUseCase(this.repository);

  Future<void> execute(String postId, String userId) async {
    await repository.likePost(postId, userId);
  }
}
