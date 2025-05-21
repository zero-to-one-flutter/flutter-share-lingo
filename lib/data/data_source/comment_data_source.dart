import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/comment_dto.dart';

abstract class CommentDataSource {
  Stream<List<CommentDto>> getCommentsStream(String postId);
}

class CommentRemoteDataSource implements CommentDataSource {
  final FirebaseFirestore firestore;

  CommentRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<CommentDto>> getCommentsStream(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CommentDto.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
}
