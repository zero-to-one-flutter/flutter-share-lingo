import '../entity/comment.dart';

abstract class CommentRepository {
  Stream<List<Comment>> getCommentsStream(String postId);
}
