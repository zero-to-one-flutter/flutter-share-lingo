import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/core/utils/format_time_ago.dart';
import 'package:share_lingo/core/utils/general_utils.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/vote_state.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';

class PollPostCard extends ConsumerStatefulWidget {
  final PostEntity post;
  final DateTime now;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const PollPostCard({
    super.key,
    required this.post,
    required this.now,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  ConsumerState<PollPostCard> createState() => _PollPostCardState();
}

class _PollPostCardState extends ConsumerState<PollPostCard> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final voteState = ref.watch(voteStateProvider)[post.id];
    final selectedIndex = voteState?.selectedIndex;
    final pollVotes = voteState?.pollVotes ?? {};
    final options = post.pollOptions ?? [];
    final totalVotes = pollVotes.values.fold<int>(0, (sum, v) => sum + v);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _topBar(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  post.pollQuestion ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.showDeleteButton && widget.onDelete != null)
                GestureDetector(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('투표 삭제'),
                            content: const Text('정말 투표를 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('취소'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('삭제'),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true && mounted) {
                      widget.onDelete!();
                    }
                  },
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < options.length; i++)
            _buildOption(
              i,
              options[i],
              pollVotes['$i'] ?? 0,
              totalVotes,
              selectedIndex,
            ),
        ],
      ),
    );
  }

  Widget _topBar() {
    final post = widget.post;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: AppCachedImage(
            imageUrl: post.userProfileImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  FormatTimeAgo.formatTimeAgo(
                    now: widget.now,
                    createdAt: post.createdAt,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  GeneralUtils.getLanguageCodeByName(
                    post.userNativeLanguage,
                  )!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
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
                  style: const TextStyle(
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
    );
  }

  Widget _buildOption(
    int index,
    String label,
    int count,
    int total,
    int? selectedIndex,
  ) {
    final alreadyVoted = selectedIndex != null;
    final percent = total == 0 ? 0 : ((count / total) * 100).round();

    return InkWell(
      onTap:
          alreadyVoted
              ? null
              : () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) return;

                try {
                  await ref
                      .read(votePostUseCaseProvider)
                      .call(
                        postId: widget.post.id,
                        uid: uid,
                        selectedIndex: index,
                      );

                  final updatedVotes = Map<String, int>.from(
                    ref.read(voteStateProvider)[widget.post.id]?.pollVotes ??
                        {},
                  );
                  updatedVotes['$index'] = (updatedVotes['$index'] ?? 0) + 1;

                  ref
                      .read(voteStateProvider.notifier)
                      .set(
                        widget.post.id,
                        VoteState(
                          pollVotes: updatedVotes,
                          selectedIndex: index,
                        ),
                      );
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미 투표하셨습니다.')),
                    );
                  }
                }
              },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: alreadyVoted ? Colors.grey.shade200 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedIndex == index ? Colors.blue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 15)),
            if (alreadyVoted)
              Text(
                '$percent%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
