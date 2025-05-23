import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/fetch_current_updated_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_initial_posts_usecase.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/fetch_lastest_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_older_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_posts_by_uid_usecase.dart';

class FeedNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<PostEntity>, String?> {
  late final FetchInitialPostsUsecase initialPostsUsecase;
  late final FetchOlderPostsUsecase olderPostsUsecase;
  late final FetchLastestPostsUsecase latestPostsUsecase;
  late final FetchCurrentUpdatedPostsUsecase currentUpdatedPostsUsecase;
  late final PostRepository repository;

  bool _isInitialized = false;

  @override
  Future<List<PostEntity>> build(String? uid) async {
    if (uid != null) {
      return await ref.read(fetchPostsByUidUsecaseProvider).execute(uid);
    }

    // 중복 초기화 방지
    if (!_isInitialized) {
      initialPostsUsecase = ref.read(fetchInitialPostsUsecaseProvider);
      olderPostsUsecase = ref.read(fetchOlderPostsUsecaseProvider);
      latestPostsUsecase = ref.read(fetchLatestPostsUsecaseProvider);
      currentUpdatedPostsUsecase = ref.read(fetchCurrentUpdatedPostsUsecase);
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
      if (arg != null) {
        return await ref.read(fetchPostsByUidUsecaseProvider).execute(arg!);
      }
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

  Future<List<PostEntity>> refreshAndUpdatePosts() async {
    PostEntity? firstPost;

    if (state.asData == null) return [];
    final currentPosts = state.asData!.value;
    firstPost = currentPosts.isNotEmpty ? currentPosts.first : null;

    // 새 포스트 20개 가져오기
    if (firstPost != null) {
      // 기존 포스트 최신 50개만 남기기
      List<PostEntity> remainPosts = currentPosts.take(50).toList();
      try {
        final latestPosts = await latestPostsUsecase.execute(firstPost);
        if (latestPosts.isEmpty) return [];

        latestPosts.removeWhere((post) => post.uid == firstPost!.uid);
        // 서버에서 firstpost 기준 기존글 50개만 가지고 오기
        final currentUpdatedPosts = await currentUpdatedPostsUsecase.execute(
          firstPost,
        );

        final updateMap = {for (var post in currentUpdatedPosts) post.id: post};

        final updatedRemainPosts =
            remainPosts.map((post) {
              if (updateMap.containsKey(post.id)) {
                return updateMap[post.id]!;
              }
              return post;
            }).toList();

        state = AsyncData([...latestPosts, ...updatedRemainPosts]);
      } catch (e, st) {
        log('에러 발생');
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

final feedNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<FeedNotifier, List<PostEntity>, String?>(FeedNotifier.new);

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
