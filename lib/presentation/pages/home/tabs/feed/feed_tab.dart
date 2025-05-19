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
                      return SizedBox(
                        height: 25,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Divider(),
                        ),
                      );
                    },
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      // final post = docs[index].data();
                      // 추후 사용
                      // final content = post['content'] ?? '';
                      // final imageUrl = post['imageUrl'] ?? '';
                      // final tags = post['tags'] ?? [];
                      return PostItem();
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
