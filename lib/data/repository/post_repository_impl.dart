import 'dart:typed_data';

import '../../domain/entity/app_user.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/repository/post_repository.dart';
import '../data_source/post_remote_data_source.dart';
import '../dto/post_dto.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createPost(PostEntity post) async {
    final dto = PostDto.fromEntity(post);
    await remoteDataSource.createPost(dto);
  }

  @override
  Future<String> uploadImage(String uid, Uint8List bytes) {
    return remoteDataSource.uploadImage(uid, bytes);
  }

  @override
  Future<List<PostEntity>> fetchInitialPosts({String? filter, AppUser? user}) async {
    final dtoList = await remoteDataSource.fetchInitialPosts(filter: filter, user: user);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> fetchOlderPosts(PostEntity lastPost, {String? filter, AppUser? user}) async {
    final dtoList = await remoteDataSource.fetchOlderPosts(lastPost, filter: filter, user: user);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> fetchLatestPosts(PostEntity firstPost, {String? filter, AppUser? user}) async {
    final dtoList = await remoteDataSource.fetchLatestPosts(firstPost, filter: filter, user: user);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> fetchCurrentUpdatedPosts(
    PostEntity firstPost,
  ) async {
    final dtoList = await remoteDataSource.fetchCurrentPosts(firstPost)
      ..where((p) => p.updatedAt != null).toList();
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> updatePost({
    required String id,
    required String content,
    required List<String> imageUrls,
    required List<String> tags,
  }) async {
    await remoteDataSource.updatePost(
      id: id,
      content: content,
      imageUrls: imageUrls,
      tags: tags,
    );
  }

  @override
  Future<List<PostEntity>> fetchPostsByUid(String uid) async {
    final dtoList = await remoteDataSource.fetchPostsByUid(uid);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> deletePost(String id) async {
    await remoteDataSource.deletePost(id);
  }

  /// For Detail page
  @override
  Future<PostEntity> getPost(String id) async {
    final dto = await remoteDataSource.getPost(id);
    if (dto == null) throw Exception('Post not found');
    return dto.toEntity();
  }

  // likes
  @override
  Future<void> likePost(String postId, String userId) async {
    await remoteDataSource.likePost(postId, userId);
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    await remoteDataSource.unlikePost(postId, userId);
  }

  @override
  Future<bool> isPostLiked(String postId, String userId) async {
    final likes = await remoteDataSource.getPostLikes(postId).first;
    return likes.contains(userId);
  }

  @override
  Stream<int> getPostLikeCount(String postId) {
    return remoteDataSource.getPostLikeCount(postId);
  }

  @override
  Stream<List<String>> getPostLikes(String postId) {
    return remoteDataSource.getPostLikes(postId);
  }

  @override
  Future<void> voteOnPost({
    required String postId,
    required String uid,
    required int selectedIndex,
  }) async {
    await remoteDataSource.voteOnPost(
      postId: postId,
      uid: uid,
      selectedIndex: selectedIndex,
    );
  }
}
