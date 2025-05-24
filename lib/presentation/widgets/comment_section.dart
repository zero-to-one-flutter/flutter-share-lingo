import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/core/providers/comment_providers.dart';
import 'package:share_lingo/domain/entity/comment.dart';
import 'package:share_lingo/data/dto/comment_dto.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../pages/report/comment_report_page.dart';

class CommentSection extends ConsumerStatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, TextEditingController> _editControllers = {};
  final Map<String, bool> _isEditing = {};
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    _commentController.dispose();
    for (var controller in _editControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(userGlobalViewModelProvider);
    if (user == null) return;

    final comment = Comment(
      id: '',
      uid: user.id,
      userName: user.name,
      userProfileImage: user.profileImage ?? '',
      content: content,
      createdAt: DateTime.now(),
    );

    final commentDto = CommentDto.fromEntity(comment);

    // Add the comment
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(commentDto.toMap());

    // Update the post's comment count
    // await FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(widget.postId)
    //     .update({'commentCount': FieldValue.increment(1)});

    _commentController.clear();
    setState(() {
      _showEmojiPicker = false;
    });
  }

  Future<void> _updateComment(String commentId, String content) async {
    if (content.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .update({'content': content});

    setState(() {
      _isEditing[commentId] = false;
    });
  }

  Future<void> _deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .delete();

    // Update the post's comment count
    // await FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(widget.postId)
    //     .update({'commentCount': FieldValue.increment(-1)});
  }

  Future<void> _toggleReaction(String commentId, String emoji) async {
    final user = ref.read(userGlobalViewModelProvider);
    if (user == null) return;

    final reactionRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .collection('reactions')
        .doc(user.id);

    final reactionDoc = await reactionRef.get();
    if (reactionDoc.exists) {
      if (reactionDoc.data()?['emoji'] == emoji) {
        // Remove reaction if it's the same emoji
        await reactionRef.delete();
      } else {
        // Update reaction if it's a different emoji
        await reactionRef.set({
          'emoji': emoji,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      // Add new reaction
      await reactionRef.set({
        'emoji': emoji,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _showReactionPicker(BuildContext context, String commentId) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _toggleReaction(commentId, emoji.emoji);
                Navigator.pop(context);
              },
              config: Config(
                height: 250,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax:
                      28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                categoryViewConfig: const CategoryViewConfig(),
                skinToneConfig: const SkinToneConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsStreamProvider(widget.postId));
    final currentUser = ref.watch(userGlobalViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        onPressed: () {
                          setState(() {
                            _showEmojiPicker = !_showEmojiPicker;
                          });
                        },
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _commentController.text += emoji.emoji;
              },
              textEditingController: _commentController,
              config: Config(
                height: 250,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax:
                      28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                categoryViewConfig: const CategoryViewConfig(),
                skinToneConfig: const SkinToneConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
        commentsAsync.when(
          data:
              (comments) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final isOwner = currentUser?.id == comment.uid;
                  _editControllers.putIfAbsent(
                    comment.id,
                    () => TextEditingController(text: comment.content),
                  );
                  _isEditing.putIfAbsent(comment.id, () => false);

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  comment.userProfileImage,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _formatTimeAgo(comment.createdAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.grey[200],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder:
                                        (context) => Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 24,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                          ),
                                          if (isOwner) ...[
                                            Card(
                                              margin:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  14,
                                                ),
                                              ),
                                              elevation: 0,
                                              color: Colors.white,
                                              child: ListTile(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 6,
                                                ),
                                                title: const Text(
                                                  '수정',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.edit,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _isEditing[comment.id] =
                                                    true;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Card(
                                              margin:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  14,
                                                ),
                                              ),
                                              elevation: 0,
                                              color: Colors.white,
                                              child: ListTile(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 6,
                                                ),
                                                title: const Text(
                                                  '삭제',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  final confirm = await showCupertinoDialog<
                                                      bool
                                                  >(
                                                    context: context,
                                                    builder:
                                                        (
                                                        dialogContext,
                                                        ) => CupertinoAlertDialog(
                                                      title: const Text(
                                                        '정말 삭제할까요?',
                                                      ),
                                                      content: const Text(
                                                        '삭제된 댓글은 복구할 수 없습니다.',
                                                      ),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          onPressed:
                                                              () => Navigator.pop(
                                                            dialogContext,
                                                            false,
                                                          ),
                                                          child:
                                                          const Text(
                                                            '취소',
                                                          ),
                                                        ),
                                                        CupertinoDialogAction(
                                                          isDestructiveAction:
                                                          true,
                                                          onPressed:
                                                              () => Navigator.pop(
                                                            dialogContext,
                                                            true,
                                                          ),
                                                          child:
                                                          const Text(
                                                            '삭제',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  if (confirm == true) {
                                                    _deleteComment(
                                                      comment.id,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                          if (!isOwner)
                                            Card(
                                              margin:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  14,
                                                ),
                                              ),
                                              elevation: 0,
                                              color: Colors.white,
                                              child: ListTile(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 6,
                                                ),
                                                title: const Text(
                                                  '신고',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.flag,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                          context,
                                                          ) => CommentReportPage(
                                                        postId:
                                                        widget
                                                            .postId,
                                                        commentId:
                                                        comment.id,
                                                        commentContent:
                                                        comment
                                                            .content,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_isEditing[comment.id] ?? false)
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _editControllers[comment.id],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed:
                                      () => _updateComment(
                                        comment.id,
                                        _editControllers[comment.id]?.text ??
                                            '',
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _isEditing[comment.id] = false;
                                      _editControllers[comment.id]?.text =
                                          comment.content;
                                    });
                                  },
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.content),
                                const SizedBox(height: 8),
                                StreamBuilder<QuerySnapshot>(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(widget.postId)
                                          .collection('comments')
                                          .doc(comment.id)
                                          .collection('reactions')
                                          .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }

                                    final reactions = snapshot.data!.docs;
                                    final reactionCounts = <String, int>{};
                                    for (var doc in reactions) {
                                      final emoji =
                                          (doc.data()
                                                  as Map<
                                                    String,
                                                    dynamic
                                                  >?)?['emoji']
                                              as String? ??
                                          '';
                                      reactionCounts[emoji] =
                                          (reactionCounts[emoji] ?? 0) + 1;
                                    }

                                    return Wrap(
                                      spacing: 8,
                                      children: [
                                        ...reactionCounts.entries.map(
                                          (entry) => InkWell(
                                            onTap:
                                                () => _toggleReaction(
                                                  comment.id,
                                                  entry.key,
                                                ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${entry.key} ${entry.value}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_reaction_outlined,
                                          ),
                                          onPressed:
                                              () => _showReactionPicker(
                                                context,
                                                comment.id,
                                              ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        SizedBox(height: 50,),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
