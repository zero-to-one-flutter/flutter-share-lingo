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
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle at the top
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 12),
              ),

              if (isMyPost) ...[
                _optionCard(
                  text: '수정하기',
                  icon: Icons.edit,
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
                _optionCard(
                  text: '삭제하기',
                  icon: Icons.delete,
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () async {
                    navigator.pop();
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
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
                      await ref.read(postRepositoryProvider).deletePost(post.id);
                      ref.invalidate(feedNotifierProvider);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('게시글이 삭제되었습니다')),
                      );
                    }
                  },
                ),
              ] else ...[
                _optionCard(
                  text: '신고하기',
                  icon: Icons.flag,
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () async {
                    navigator.pop();
                    await navigator.push(
                      MaterialPageRoute(
                        builder: (_) => ReportPage(
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
        );
      },
    );
  }

  Widget _optionCard({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(icon, color: iconColor ?? Colors.black87),
        onTap: onTap,
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
