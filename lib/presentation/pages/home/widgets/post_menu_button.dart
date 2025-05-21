import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_tab.dart';

class PostMenuButton extends ConsumerWidget {
  final PostEntity post;

  const PostMenuButton({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMyPost = post.uid == FirebaseAuth.instance.currentUser?.uid;
    if (!isMyPost) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'edit') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostWriteTab(post: post)),
          );
          if (result == true) {
            ref.invalidate(feedNotifierProvider);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('게시글이 수정되었습니다')));
          }
        } else if (value == 'delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('정말 삭제할까요?'),
                  content: const Text('삭제된 글은 복구할 수 없습니다.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        '삭제',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
          );

          if (confirm == true) {
            await ref.read(postRepositoryProvider).deletePost(post.id);
            ref.invalidate(feedNotifierProvider);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다')));
          }
        }
      },
      itemBuilder:
          (context) => const [
            PopupMenuItem(value: 'edit', child: Text('수정하기')),
            PopupMenuItem(value: 'delete', child: Text('삭제하기')),
          ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
