import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository _postRepository;

  UpdatePostUseCase(this._postRepository);

  Future<void> call(PostEntity post) async {
    await _postRepository.updatePost(post);
  }
}
