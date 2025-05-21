import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/presentation/widgets/post_card.dart';
import '../../../domain/entity/post_entity.dart';

final myPostsProvider = FutureProvider.family<List<PostEntity>, String>((
  ref,
  uid,
) async {
  return await ref.read(postRepositoryProvider).fetchPostsByUid(uid);
});

class MyPostsSection extends ConsumerWidget {
  final String uid;

  const MyPostsSection({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(myPostsProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            '내가 작성한 글',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        postAsync.when(
          data:
              (posts) => ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  //    return PostCard(post: post, isMyPost: true);
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('오류 발생: $e')),
        ),
      ],
    );
  }
}
