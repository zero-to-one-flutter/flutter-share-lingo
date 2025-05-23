import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/entity/app_user.dart';

class FetchOlderPostsUsecase {
  final PostRepository repository;

  FetchOlderPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(
      PostEntity lastPost, {
        String? filter,
        AppUser? user,
      }) async {
    return await repository.fetchOlderPosts(lastPost, filter: filter, user: user);
  }
}
