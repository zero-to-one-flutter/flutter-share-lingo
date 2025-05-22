import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/poll_post_card.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';
import 'package:share_lingo/presentation/widgets/comment_section.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final PostEntity post;
  static String? currentPostId;

  const PostDetailPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final ref = this.ref;
    PostDetailPage.currentPostId = post.id;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Post'), elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PostItem(post: post, displayComments: false),
              if (post.isPoll)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PollPostCard(post: post, now: DateTime.now()),
                ),
              const Divider(),
              CommentSection(postId: post.id),
            ],
          ),
        ),
      ),
    );
  }
}
