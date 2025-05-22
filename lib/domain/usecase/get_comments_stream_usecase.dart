import '../entity/comment.dart';
import '../repository/comment_repository.dart';

class GetCommentsStreamUseCase {
  final CommentRepository repository;

  GetCommentsStreamUseCase(this.repository);

  Stream<List<Comment>> execute(String postId) {
    return repository.getCommentsStream(postId);
  }
}
