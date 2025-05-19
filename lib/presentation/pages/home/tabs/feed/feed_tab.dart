import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';

import '../../../../../app/constants/app_colors.dart';
import '../../../../widgets/app_cached_image.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final postsAsync = ref.watch(postsProvider);

        return Column(
          children: [
            AppBar(title: Text('바꾸기')),
            Expanded(
              child: postsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('에러 발생: $err')),
                data: (snapshot) {
                  final docs = snapshot.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 5,
                      bottom: 100,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final post = docs[index].data();
                      final content = post['content'] ?? '';
                      final imageUrl = post['imageUrl'] ?? '';

                      return InkWell(
                        highlightColor: AppColors.lightGrey,
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: AppCachedImage(
                                imageUrl:
                                    imageUrl.isNotEmpty
                                        ? imageUrl
                                        : 'https://picsum.photos/200/200?random=$index',
                                width: 66,
                                height: 66,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTopRow(),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Text(
                                      content,
                                      style: const TextStyle(
                                        color: Color(0xFF424242),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    indent: 0,
                                    height: 35,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Row _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '김민수',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('한국어', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Icon(Icons.sync_alt_outlined, color: Colors.black, size: 17),
                  const SizedBox(width: 5),
                  Text('영어', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                backgroundColor: Colors.blue.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(
                '팔로우',
                style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
