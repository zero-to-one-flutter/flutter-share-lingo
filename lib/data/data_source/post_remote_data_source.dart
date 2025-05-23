import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_lingo/data/dto/post_dto.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';

import '../../domain/entity/app_user.dart';

class PostRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PostRemoteDataSource({FirebaseFirestore? firestore, required this.storage})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createPost(PostDto postDto) async {
    await firestore.collection('posts').add(postDto.toMap());
  }

  Future<String> uploadImage(String uid, Uint8List bytes) async {
    final ref = storage.ref(
      'post_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final uploadTask = await ref.putData(bytes);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<List<PostDto>> fetchInitialPosts({
    String? filter,
    AppUser? user,
  }) async {
    Query<Map<String, dynamic>> base = firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(20);

    final query = _applyFilter(base, filter, user);
    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => PostDto.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<PostDto>> fetchOlderPosts(
    PostEntity lastPost, {
    String? filter,
    AppUser? user,
  }) async {
    Query<Map<String, dynamic>> base = firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .startAfter([lastPost.createdAt])
        .limit(20);

    final query = _applyFilter(base, filter, user);
    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => PostDto.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<PostDto>> fetchLatestPosts(
    PostEntity firstPost, {
    String? filter,
    AppUser? user,
  }) async {
    Query<Map<String, dynamic>> base = firestore
        .collection('posts')
        .orderBy('createdAt', descending: false)
        .startAfter([firstPost.createdAt])
        .limit(20);

    final query = _applyFilter(base, filter, user);
    final snapshot = await query.get();

    final reversedList =
        snapshot.docs
            .map((doc) => PostDto.fromMap(doc.id, doc.data()))
            .toList();
    return reversedList.reversed.toList();
  }

  Query<Map<String, dynamic>> _applyFilter(
    Query<Map<String, dynamic>> base,
    String? filter,
    AppUser? user,
  ) {
    if (filter == 'recommended' && user != null) {
      return base
          .where('userNativeLanguage', isEqualTo: user.targetLanguage)
          .where('userTargetLanguage', isEqualTo: user.nativeLanguage);
    } else if (filter == 'peers' && user != null) {
      return base
          .where('userNativeLanguage', isEqualTo: user.nativeLanguage)
          .where('userTargetLanguage', isEqualTo: user.targetLanguage);
    } else if (filter == 'nearby') {
      if (user == null || user.district == null || user.district!.isEmpty) {
        return base.where(
          'userDistrict',
          isEqualTo: '__none__',
        ); // unlikely to match anything
      }
      return base.where('userDistrict', isEqualTo: user.district);
    }
    return base;
  }

  Future<List<PostDto>> fetchCurrentPosts(
    PostEntity firstPost, {
    String? filter,
    AppUser? user,
  }) async {
    Query<Map<String, dynamic>> base = firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .startAfter([firstPost.createdAt])
        .limit(50);

    final query = _applyFilter(base, filter, user);
    final snapshot = await query.get();

    final doc = await firestore.collection('posts').doc(firstPost.id).get();
    if (!doc.exists) {
      return snapshot.docs
          .map((doc) => PostDto.fromMap(doc.id, doc.data()))
          .toList();
    }

    final firstPostDto = PostDto.fromMap(doc.id, doc.data()!);
    final dtoList =
        snapshot.docs
            .map((doc) => PostDto.fromMap(doc.id, doc.data()))
            .toList();
    return [firstPostDto, ...dtoList];
  }

  Future<void> updatePost({
    required String id,
    required String content,
    required List<String> imageUrls,
    List<String>? tags,
  }) async {
    await FirebaseFirestore.instance.collection('posts').doc(id).update({
      'content': content,
      'imageUrl': imageUrls,
      'tags': tags,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<PostDto>> fetchPostsByUid(String uid) async {
    final snapshot =
        await firestore
            .collection('posts')
            .where('uid', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => PostDto.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> deletePost(String id) async {
    await firestore.collection('posts').doc(id).delete();
  }

  // For Comments etc.
  Future<PostDto?> getPost(String id) async {
    final doc = await firestore.collection('posts').doc(id).get();
    if (!doc.exists) return null;
    return PostDto.fromMap(doc.id, doc.data()!);
  }

  Stream<int> getPostLikeCount(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<String>> getPostLikes(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<List<PostDto>> getPosts() async {
    final snapshot =
        await firestore
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get();
    return snapshot.docs
        .map((doc) => PostDto.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> likePost(String postId, String uid) async {
    await firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> unlikePost(String postId, String uid) async {
    await firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .delete();
  }

  Future<void> voteOnPost({
    required String postId,
    required String uid,
    required int selectedIndex,
  }) async {
    final postRef = firestore.collection('posts').doc(postId);

    await firestore.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(postRef);
        final data = snapshot.data() ?? {};

        final pollVotes = Map<String, dynamic>.from(data['pollVotes'] ?? {});
        final userVotes = Map<String, dynamic>.from(data['userVotes'] ?? {});

        if (userVotes.containsKey(uid)) {
          throw Exception('이미 투표한 사용자입니다.');
        }

        final indexStr = selectedIndex.toString();
        pollVotes[indexStr] = (pollVotes[indexStr] ?? 0) + 1;
        userVotes[uid] = selectedIndex;

        transaction.update(postRef, {
          'pollVotes': pollVotes,
          'userVotes': userVotes,
        });
      },
      maxAttempts: 5, // 최대 재시도 횟수
    );
  }
}
