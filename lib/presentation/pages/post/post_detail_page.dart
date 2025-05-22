import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';
import 'package:share_lingo/presentation/widgets/comment_section.dart';

import '../home/tabs/feed/feed_view_model.dart';

class PostDetailPage extends ConsumerWidget {
  final PostEntity post;
  static String? currentPostId;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    currentPostId = post.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Post'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostItem(
              post: post,
              displayComments: false,
              now: ref.watch(timeAgoNotifierProvider),
            ),
            const Divider(),
            CommentSection(postId: post.id),
          ],
        ),
      ),
    );
  }
}
