import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/post_dto.dart';

class PostRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;
  final String _collection = 'posts';

  Future<void> createPost(PostDto postDto) async {
    await _firestore.collection(_collection).add(postDto.toMap());
  }
}
