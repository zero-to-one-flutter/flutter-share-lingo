import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_initial_posts_usecase.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/fetch_older_posts_usecase.dart';

class FeedNotifier extends AutoDisposeAsyncNotifier<List<PostEntity>> {
  late final FetchInitialPostsUsecase initialPostsUsecase;
  late final FetchOlderPostsUsecase olderPostsUsecase;
  late final PostRepository repository;

  @override
  Future<List<PostEntity>> build() async {
    initialPostsUsecase = ref.read(fetchInitialPostsUsecaseProvider);
    olderPostsUsecase = ref.read(fetchOlderPostsUsecaseProvider);
    repository = ref.read(postRepositoryProvider);
    return await _fetchInitialPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading(); // UI에서 로딩 상태 보이게
    state = await AsyncValue.guard(() async {
      return await _fetchInitialPosts();
    });
  }

  Future<List<PostEntity>> _fetchInitialPosts() async {
    try {
      final posts = await initialPostsUsecase.execute();
      return posts;
    } catch (e, st) {
      // state를 에러 상태로 설정
      state = AsyncError(e, st);
      return [];
    }
  }

  Future<List<PostEntity>> fetchOlderPosts() async {
    PostEntity? lastPost;

    if (state.asData == null) return [];

    final currentPosts = state.asData!.value;
    lastPost = currentPosts.isNotEmpty ? currentPosts.last : null;

    if (lastPost != null) {
      try {
        final olderPosts = await olderPostsUsecase.execute(lastPost);
        if (olderPosts.isEmpty) return [];

        state = AsyncData([...currentPosts, ...olderPosts]);
        return olderPosts;
      } catch (e, st) {
        state = AsyncError(e, st);
        return [];
      }
    }
    return [];
  }
}

final feedNotifierProvider =
    AsyncNotifierProvider.autoDispose<FeedNotifier, List<PostEntity>>(
      () => FeedNotifier(),
    );
