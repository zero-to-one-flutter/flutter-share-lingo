import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/throttler_util.dart';
import 'package:share_lingo/domain/entity/app_user.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';


class PostListContent extends ConsumerWidget {
  final String? uid;
  final String? filter;
  final AppUser? user;

  const PostListContent({super.key, this.uid, this.filter, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(
      feedNotifierProvider(FeedQueryArg(uid: uid, filter: filter)),
    );

    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('에러 발생: $err')),
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('게시글이 없습니다.'));
        }
        // throttler 사용
        final throttler = Throttler(
          duration: Duration(seconds: 1),
          callback: () {
            if (uid == null) {
              ref
                  .read(
                    feedNotifierProvider(
                      FeedQueryArg(uid: uid, filter: filter),
                    ).notifier,
                  )
                  .fetchOlderPosts();
            }
          },
        );
        // 무한 스크롤
        return NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent) {
                throttler.run();
              }
            }
            return true;
          },
          // 당겨서 새로고침
          child: RefreshIndicator(
            onRefresh: () {
              if (uid == null) {
                final throttler = Throttler(
                  duration: Duration(seconds: 1),
                  callback: () {
                    ref
                        .read(
                          feedNotifierProvider(
                            FeedQueryArg(uid: uid, filter: filter),
                          ).notifier,
                        )
                        .refreshAndUpdatePosts();
                  },
                );
                throttler.run();
              }
              return Future.value();
            },

            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 5,
                bottom: 100,
              ),
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: 8, width: double.infinity),
                    Divider(),
                  ],
                );
              },
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostItem(post: post, displayComments: true);
              },
            ),
          ),
        );
      },
    );
  }
}
