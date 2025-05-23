import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class FetchCurrentUpdatedPostsUsecase {
  final PostRepository repository;

  FetchCurrentUpdatedPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(PostEntity firstPost) async {
    return await repository.fetchCurrentUpdatedPosts(firstPost);
  }
}
