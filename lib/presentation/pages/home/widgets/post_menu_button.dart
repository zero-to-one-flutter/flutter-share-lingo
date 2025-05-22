import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_tab.dart';
import 'package:share_lingo/presentation/pages/report/report_page.dart';

class PostMenuButton extends ConsumerWidget {
  final PostEntity post;

  const PostMenuButton({super.key, required this.post});

  void _showPostOptions(BuildContext context, WidgetRef ref) {
    final isMyPost = post.uid == FirebaseAuth.instance.currentUser?.uid;
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMyPost) ...[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('수정하기'),
                    onTap: () async {
                      navigator.pop();
                      final result = await navigator.push(
                        MaterialPageRoute(
                          builder: (_) => PostWriteTab(post: post),
                        ),
                      );

                      if (result == true) {
                        ref.invalidate(feedNotifierProvider);
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('게시글이 수정되었습니다')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      '삭제하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      navigator.pop();
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('정말 삭제할까요?'),
                              content: const Text('삭제된 글은 복구할 수 없습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () => navigator.pop(false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => navigator.pop(true),
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await ref
                            .read(postRepositoryProvider)
                            .deletePost(post.id);
                        ref.invalidate(feedNotifierProvider);
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('게시글이 삭제되었습니다')),
                        );
                      }
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('신고하기'),
                    onTap: () async {
                      navigator.pop();
                      await navigator.push(
                        MaterialPageRoute(
                          builder:
                              (_) => ReportPage(
                                postId: post.id,
                                postContent: post.content,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 30,
      width: 30,
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        icon: Icon(CupertinoIcons.ellipsis),
        onPressed: () => _showPostOptions(context, ref),
      ),
    );
  }
}
