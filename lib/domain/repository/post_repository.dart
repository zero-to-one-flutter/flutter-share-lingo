import 'dart:typed_data';

import '../entity/post_entity.dart';

abstract class PostRepository {
  Future<void> createPost(PostEntity post);
  Future<String> uploadImage(String uid, Uint8List imageBytes);
  Future<List<PostEntity>> fetchInitialPosts();
}
