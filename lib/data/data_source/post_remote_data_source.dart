import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_lingo/data/dto/post_dto.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';

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

  Future<List<PostDto>> fetchInitialPosts() async {
    final snapshot =
        await firestore
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .limit(20)
            .get();
    final posts =
        snapshot.docs.map((doc) => PostDto.fromMap(doc.data())).toList();

    return posts;
  }

  Future<List<PostDto>> fetchOlderPosts(PostEntity lastPost) async {
    final snapshot =
        await firestore
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .startAfter([lastPost.createdAt])
            .limit(20)
            .get();

    return snapshot.docs.map((doc) => PostDto.fromMap(doc.data())).toList();
  }

  Future<List<PostDto>> fetchLatestPosts(PostEntity firstPost) async {
    final snapshot =
        await firestore
            .collection('posts')
            .orderBy('createdAt', descending: false)
            .startAfter([firstPost.createdAt])
            .limit(20)
            .get();

    final reversedList =
        snapshot.docs.map((doc) => PostDto.fromMap(doc.data())).toList();
    return reversedList.reversed.toList();
  }
}
