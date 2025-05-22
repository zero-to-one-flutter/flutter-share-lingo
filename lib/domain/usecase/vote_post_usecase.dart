import 'package:share_lingo/domain/repository/post_repository.dart';

class VotePostUseCase {
  final PostRepository repository;

  VotePostUseCase(this.repository);

  Future<void> call({
    required String postId,
    required String uid,
    required int selectedIndex,
  }) async {
    await repository.voteOnPost(
      postId: postId,
      uid: uid,
      selectedIndex: selectedIndex,
    );
  }
}
