import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';
import 'package:share_lingo/presentation/widgets/comment_section.dart';

class PostDetailPage extends ConsumerWidget {
  final PostEntity post;
  static String? currentPostId;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          PostDetailPage.currentPostId = null;
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(title: const Text('Post'), elevation: 0),
          body: SingleChildScrollView(
            child: Column(
              children: [
                PostItem(post: post, displayComments: false),
                const Divider(),
                CommentSection(postId: post.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
