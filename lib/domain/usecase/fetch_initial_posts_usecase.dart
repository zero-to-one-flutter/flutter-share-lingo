import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class FetchInitialPostsUsecase {
  final PostRepository repository;

  FetchInitialPostsUsecase(this.repository);

  Future<List<PostEntity>> execute() async {
    return await repository.fetchInitialPosts();
  }
}
