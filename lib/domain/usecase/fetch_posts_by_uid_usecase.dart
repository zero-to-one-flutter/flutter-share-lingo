import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';

class FetchPostsByUidUsecase {
  final PostRepository repository;

  FetchPostsByUidUsecase(this.repository);

  Future<List<PostEntity>> execute(String uid) async {
    return await repository.fetchPostsByUid(uid);
  }
}

final fetchPostsByUidUsecaseProvider = Provider(
      (ref) => FetchPostsByUidUsecase(ref.read(postRepositoryProvider)),
);
