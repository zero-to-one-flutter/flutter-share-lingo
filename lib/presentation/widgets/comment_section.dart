import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/core/providers/comment_providers.dart';
import 'package:share_lingo/domain/entity/comment.dart';
import 'package:share_lingo/data/dto/comment_dto.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';

class CommentSection extends ConsumerStatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
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
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({'commentCount': FieldValue.increment(1)});

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsStreamProvider(widget.postId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: _addComment),
            ],
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
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(comment.userProfileImage),
                    ),
                    title: Text(comment.userName),
                    subtitle: Text(comment.content),
                    trailing: Text(
                      _formatTimeAgo(comment.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
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
