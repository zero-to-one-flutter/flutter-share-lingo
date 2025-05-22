import 'dart:typed_data';

import '../entity/app_user.dart';
import '../entity/post_entity.dart';

abstract class PostRepository {
  Future<void> createPost(PostEntity post);
  Future<String> uploadImage(String uid, Uint8List imageBytes);
  Future<List<PostEntity>> fetchInitialPosts({String? filter, AppUser? user});
  Future<List<PostEntity>> fetchOlderPosts(PostEntity lastPost, {String? filter, AppUser? user});
  Future<List<PostEntity>> fetchLatestPosts(PostEntity firstPost, {String? filter, AppUser? user});
  Future<void> updatePost({
    required String id,
    required String content,
    required List<String> imageUrls,
    required List<String> tags,
  });
  Future<List<PostEntity>> fetchPostsByUid(String uid);
  Future<void> deletePost(String id);

  /// Fetch post for detail page
  Future<PostEntity> getPost(String id);

  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<bool> isPostLiked(String postId, String userId);
  Stream<int> getPostLikeCount(String postId);
  Stream<List<String>> getPostLikes(String postId);
}
