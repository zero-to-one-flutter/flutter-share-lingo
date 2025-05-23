import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/entity/app_user.dart';

class FetchLastestPostsUsecase {
  final PostRepository repository;

  FetchLastestPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(
      PostEntity firstPost, {
        String? filter,
        AppUser? user,
      }) async {
    return await repository.fetchLatestPosts(firstPost, filter: filter, user: user);
  }
}
