import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';

import '../../../../../app/constants/app_colors.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final feedAsync = ref.watch(feedNotifierProvider);

        return Column(
          children: [
            AppBar(
              title: Text(
                'ShareLingo',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: feedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('에러 발생: $err')),
                data: (data) {
                  final posts = data;
                  log('${posts.length}');
                  if (posts.isEmpty) {
                    return const Center(child: Text('게시글이 없습니다.'));
                  }
                  return NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent) {
                          log('fetchOlderPosts 호출됨');
                          ref
                              .read(feedNotifierProvider.notifier)
                              .fetchOlderPosts();
                          log('${posts.length}');
                        }
                      }
                      return true;
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
                        final content = post.content;
                        final imageUrl = post.imageUrl;
                        final tags = post.tags;
                        final commentCount = post.commentCount;

                        return PostItem(
                          content: content,
                          imageUrl: imageUrl,
                          tags: tags,
                          commentCount: commentCount,
                          displayComments: true,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
