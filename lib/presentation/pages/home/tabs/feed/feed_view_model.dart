import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/domain/usecase/get_recent_posts_usecase.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';

class FeedNotifier extends AsyncNotifier<List<PostEntity>> {
  late final FetchInitialPostsUsecase usecase;

  @override
  Future<List<PostEntity>> build() async {
    usecase = ref.read(fetchInitialPostsUsecaseProvider);
    return await _fetchInitialPosts();
  }

  Future<List<PostEntity>> _fetchInitialPosts() async {
    try {
      final posts = await usecase.execute();
      return posts;
    } catch (e, st) {
      // state를 에러 상태로 설정
      state = AsyncError(e, st);
      return [];
    }
  }

  // 다시 불러올 때
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await _fetchInitialPosts());
  }
}

final feedNotifierProvider =
    AsyncNotifierProvider<FeedNotifier, List<PostEntity>>(() => FeedNotifier());
