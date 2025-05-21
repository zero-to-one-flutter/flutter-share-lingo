import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class FetchLastestPostsUsecase {
  final PostRepository repository;

  FetchLastestPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(PostEntity firstPost) async {
    return await repository.fetchLatestPosts(firstPost);
  }
}
