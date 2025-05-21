import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_initial_posts_usecase.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/fetch_lastest_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_older_posts_usecase.dart';

class FeedNotifier extends AutoDisposeAsyncNotifier<List<PostEntity>> {
  late final FetchInitialPostsUsecase initialPostsUsecase;
  late final FetchOlderPostsUsecase olderPostsUsecase;
  late final FetchLastestPostsUsecase latestPostsUsecase;
  late final PostRepository repository;

  @override
  Future<List<PostEntity>> build() async {
    initialPostsUsecase = ref.read(fetchInitialPostsUsecaseProvider);
    olderPostsUsecase = ref.read(fetchOlderPostsUsecaseProvider);
    latestPostsUsecase = ref.read(fetchLatestPostsUsecaseProvider);
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

        olderPosts.removeWhere((post) => post.uid == lastPost!.uid);

        state = AsyncData([...currentPosts, ...olderPosts]);
        return olderPosts;
      } catch (e, st) {
        state = AsyncError(e, st);
        return [];
      }
    }
    return [];
  }

  Future<List<PostEntity>> fetchLatestPosts() async {
    PostEntity? firstPost;

    if (state.asData == null) return [];
    final currentPosts = state.asData!.value;
    firstPost = currentPosts.isNotEmpty ? currentPosts.first : null;

    if (firstPost != null) {
      try {
        final latestPosts = await latestPostsUsecase.execute(firstPost);
        if (latestPosts.isEmpty) return [];

        latestPosts.removeWhere((post) => post.uid == firstPost!.uid);

        state = AsyncData([...latestPosts, ...currentPosts]);
        return latestPosts;
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
