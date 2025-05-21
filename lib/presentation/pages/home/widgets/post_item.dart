import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/core/providers/comment_providers.dart';
import 'package:share_lingo/core/utils/format_time_ago.dart';
import 'package:share_lingo/core/utils/general_utils.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_tab.dart';
import 'package:share_lingo/presentation/pages/home/widgets/expandable_text.dart';
import 'package:share_lingo/presentation/pages/post/post_detail_page.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';
import 'package:share_lingo/presentation/pages/report/report_page.dart';

import '../../../../domain/entity/app_user.dart';
import '../../profile/profile_page.dart';

class PostItem extends ConsumerStatefulWidget {
  final PostEntity post;
  final bool displayComments;

  const PostItem({
    super.key,
    required this.post,
    required this.displayComments,
  });

  @override
  ConsumerState<PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem> {
  Stream<PostEntity>? _postStream;

  @override
  void initState() {
    super.initState();
    _postStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.id)
        .snapshots()
        .map((doc) => PostEntity.fromFirestore(doc));
  }

  void _showPostOptions(BuildContext context, PostEntity post) {
    final user = ref.read(userGlobalViewModelProvider);
    if (user == null) return;

    final isOwner = user.id == post.uid;

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isOwner) ...[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('수정'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostWriteTab(post: post),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      '삭제',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context, post);
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('신고'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ReportPage(
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

  void _showDeleteConfirmation(BuildContext context, PostEntity post) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('게시물 삭제'),
            content: const Text('이 게시물을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.id)
                        .delete();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('게시물이 삭제되었습니다')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('게시물 삭제 중 오류가 발생했습니다: $e')),
                      );
                    }
                  }
                },
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostEntity>(
      stream: _postStream,
      initialData: widget.post,
      builder: (context, snapshot) {
        final post = snapshot.data ?? widget.post;

        final List<String> images =
            post.imageUrl
                .where((url) => url.trim().isNotEmpty)
                .take(3)
                .toList();

        return InkWell(
          highlightColor: AppColors.lightGrey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                _topBar(post),
                SizedBox(height: 10),
                ExpandableText(post.content, trimLines: 4),
                if (images.isNotEmpty) SizedBox(height: 10),
                _imageBox(images),
                _tagBar(post),
                !widget.displayComments
                    ? SizedBox.shrink()
                    : Column(
                      children: [
                        SizedBox(height: 15),
                        _buildCommentCount(post.id),
                      ],
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(PostEntity post) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProfilePage(
                      user: AppUser(
                        id: post.uid,
                        name: post.userName,
                        createdAt: DateTime.now(),
                        email: '',
                        profileImage: post.userProfileImage,
                        nativeLanguage: post.userNativeLanguage,
                        targetLanguage: post.userTargetLanguage,
                        bio: '',
                        birthdate: DateTime.now(),
                        partnerPreference: '',
                        languageLearningGoal: '',
                        district: post.userDistrict,
                        location: post.userLocation,
                      ),
                    ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(post.userProfileImage),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        GeneralUtils.getLanguageCodeByName(
                          post.userNativeLanguage,
                        )!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Icon(
                          Icons.sync_alt_outlined,
                          size: 16,
                          color: Colors.black26,
                        ),
                      ),
                      Text(
                        GeneralUtils.getLanguageCodeByName(
                          post.userTargetLanguage,
                        )!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () => _showPostOptions(context, post),
          icon: const Icon(Icons.keyboard_control_rounded),
        ),
      ],
    );
  }

  Widget _imageBox(List<String> images) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    double sizedBoxHeight = 8;
    double sizedBoxWidth = 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;

        switch (images.length) {
          case 1:
            content = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            );
            break;

          case 2:
            content = Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;

          case 3:
            content = Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
            break;
          default:
            content = const SizedBox.shrink();
        }

        return Column(
          children: [AspectRatio(aspectRatio: 9 / 5, child: content)],
        );
      },
    );
  }

  Widget _tagBar(PostEntity post) {
    final tags = post.tags;
    return Column(
      children: [
        tags.isEmpty ? SizedBox.shrink() : SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              tags.map((text) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.widgetBackgroundBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '# $text',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommentCount(String postId) {
    final commentCountAsync = ref.watch(postCommentCountProvider(postId));

    return commentCountAsync.when(
      data:
          (count) => Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_outlined,
                color: Colors.grey[500],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '$count',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
