import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/vote_state.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/poll_post_card.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_item.dart';
import 'package:share_lingo/presentation/widgets/comment_section.dart';

import '../home/tabs/feed/feed_view_model.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final PostEntity post;
  static String? currentPostId;

  const PostDetailPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late PostEntity _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    PostDetailPage.currentPostId = _post.id;

    // 투표 상태 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final selected = _post.userVotes?[uid]; //사용자 투표 선택 불러오기
      ref
          .read(voteStateProvider.notifier)
          .set(
            _post.id,
            VoteState(
              pollVotes: _post.pollVotes ?? {},
              selectedIndex: selected,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          log('left detailPage');
          ref
              .read(feedNotifierProvider(FeedQueryArg()).notifier)
              .refreshAndUpdatePosts();
        }
      },
     */
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Post'), elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PostItem(post: _post, displayComments: false),
              if (_post.isPoll)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PollPostCard(post: _post, now: DateTime.now()),
                ),
              const Divider(),
              CommentSection(postId: _post.id),
            ],
          ),
        ),
      ),
    );
  }
}
