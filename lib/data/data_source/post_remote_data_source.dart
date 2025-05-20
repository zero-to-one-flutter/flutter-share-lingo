import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

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
}
