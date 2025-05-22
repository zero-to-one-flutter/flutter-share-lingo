/*
import '../../domain/repository/post_repository.dart';
import '../data_source/post_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);
}
*/
import 'dart:typed_data';

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
  Future<List<PostEntity>> fetchInitialPosts() async {
    final dtoList = await remoteDataSource.fetchInitialPosts();
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> fetchOlderPosts(PostEntity lastPost) async {
    final dtoList = await remoteDataSource.fetchOlderPosts(lastPost);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> fetchLatestPosts(PostEntity firstPost) async {
    final dtoList = await remoteDataSource.fetchLatestPosts(firstPost);
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
}
