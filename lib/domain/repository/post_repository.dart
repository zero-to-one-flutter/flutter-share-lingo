import '../entity/post_entity.dart';

abstract class PostRepository {
  Future<void> createPost(PostEntity post);
}
