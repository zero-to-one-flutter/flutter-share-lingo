import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class FetchOlderPostsUsecase {
  final PostRepository repository;

  FetchOlderPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(PostEntity lastPost) async {
    return await repository.fetchOlderPosts(lastPost);
  }
}
