import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/entity/app_user.dart';

class FetchInitialPostsUsecase {
  final PostRepository repository;

  FetchInitialPostsUsecase(this.repository);

  Future<List<PostEntity>> execute({String? filter, AppUser? user}) async {
    return await repository.fetchInitialPosts(filter: filter, user: user);
  }
}
