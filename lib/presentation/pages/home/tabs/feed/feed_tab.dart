import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';

import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';

import '../../../../../app/constants/app_colors.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final postsAsync = ref.watch(postsProvider);

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
              child: postsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('에러 발생: $err')),
                data: (snapshot) {
                  final docs = snapshot.docs;

                  return ListView.separated(
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
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      // TODO: 클린아키텍처 적용
                      final post = docs[index].data();
                      final content = post['content'] ?? '';
                      final imageUrl = List<String>.from(
                        post['imageUrl'] ?? [],
                      );
                      final tags = List<String>.from(post['tags'] ?? []);
                      final commentCount = post['commentCount'] ?? 0;

                      return PostItem(
                        content: content,
                        imageUrl: imageUrl,
                        tags: tags,
                        commentCount: commentCount,
                        displayComments: true,
                      );
                    },
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
