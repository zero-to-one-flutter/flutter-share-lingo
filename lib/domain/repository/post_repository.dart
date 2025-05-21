import 'dart:typed_data';

import '../entity/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<PostEntity> getPost(String id);
  Future<void> createPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(String id);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<bool> isPostLiked(String postId, String userId);
  Stream<int> getPostLikeCount(String postId);
  Stream<List<String>> getPostLikes(String postId);
  Future<List<PostEntity>> fetchPostsByUid(String uid);
  Future<String> uploadImage(String uid, Uint8List imageBytes);
  Future<List<PostEntity>> fetchInitialPosts();
  Future<List<PostEntity>> fetchOlderPosts(PostEntity lastPost);
  Future<List<PostEntity>> fetchLatestPosts(PostEntity firstPost);
}
