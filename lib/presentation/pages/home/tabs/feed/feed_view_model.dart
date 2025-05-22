import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
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

  bool _isInitialized = false;

  @override
  Future<List<PostEntity>> build() async {
    // 중복 초기화 방지
    if (!_isInitialized) {
      initialPostsUsecase = ref.read(fetchInitialPostsUsecaseProvider);
      olderPostsUsecase = ref.read(fetchOlderPostsUsecaseProvider);
      latestPostsUsecase = ref.read(fetchLatestPostsUsecaseProvider);
      repository = ref.read(postRepositoryProvider);
      _isInitialized = true;
    }

    return await _fetchInitialPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final posts = await _fetchInitialPosts();
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<PostEntity>> _fetchInitialPosts() async {
    try {
      final posts = await initialPostsUsecase.execute();
      return posts;
    } catch (e, st) {
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

  List<ImageProvider> getCachedImageProviders(PostEntity post) =>
      post.imageUrl
          .where((e) => e.trim().isNotEmpty)
          .take(3)
          .map((e) => CachedNetworkImageProvider(e))
          .toList();
}

final feedNotifierProvider =
    AsyncNotifierProvider.autoDispose<FeedNotifier, List<PostEntity>>(
      () => FeedNotifier(),
    );

class TimeAgoNotifier extends AutoDisposeNotifier<DateTime> {
  @override
  DateTime build() {
    _startTimer();
    return DateTime.now();
  }

  void _startTimer() {
    Timer.periodic(const Duration(minutes: 1), (_) {
      state = DateTime.now(); // 매 분마다 상태 갱신
    });
  }
}

final timeAgoNotifierProvider =
    NotifierProvider.autoDispose<TimeAgoNotifier, DateTime>(
      () => TimeAgoNotifier(),
    );
