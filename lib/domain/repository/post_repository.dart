import 'dart:typed_data';

import '../entity/post_entity.dart';

abstract class PostRepository {
  Future<void> createPost(PostEntity post);
  Future<String> uploadImage(String uid, Uint8List imageBytes);
  Future<List<PostEntity>> fetchInitialPosts();
  Future<List<PostEntity>> fetchOlderPosts(PostEntity lastPost);
  Future<List<PostEntity>> fetchLatestPosts(PostEntity firstPost);
  Future<void> updatePost({
    required String id,
    required String content,
    required List<String> imageUrls,
    required List<String> tags,
  });
  Future<List<PostEntity>> fetchPostsByUid(String uid);
  Future<void> deletePost(String id);
}
