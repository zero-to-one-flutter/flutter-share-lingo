import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

import '../entity/app_user.dart';

class FetchCurrentUpdatedPostsUsecase {
  final PostRepository repository;

  FetchCurrentUpdatedPostsUsecase(this.repository);

  Future<List<PostEntity>> execute(
    PostEntity firstPost, {
    String? filter,
    AppUser? user,
  }) async {
    return await repository.fetchCurrentUpdatedPosts(
      firstPost,
      filter: filter,
      user: user,
    );
  }
}
