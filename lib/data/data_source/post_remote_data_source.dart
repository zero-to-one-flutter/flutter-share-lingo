import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

class PostRemoteDataSource {
  final FirebaseFirestore firestore;

  PostRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createPost(PostDto postDto) async {
    await firestore.collection('posts').add(postDto.toMap());
  }
}
