import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/data_source/comment_data_source.dart';
import '../../data/repository/comment_repository_impl.dart';
import '../../domain/entity/comment.dart';
import '../../domain/usecase/get_comments_stream_usecase.dart';

final commentDataSourceProvider = Provider<CommentDataSource>((ref) {
  return CommentRemoteDataSource();
});

final commentRepositoryProvider = Provider<CommentRepositoryImpl>((ref) {
  final dataSource = ref.watch(commentDataSourceProvider);
  return CommentRepositoryImpl(dataSource as CommentRemoteDataSource);
});

final getCommentsStreamUseCaseProvider = Provider<GetCommentsStreamUseCase>((
  ref,
) {
  final repository = ref.watch(commentRepositoryProvider);
  return GetCommentsStreamUseCase(repository);
});

final commentsStreamProvider = StreamProvider.family<List<Comment>, String>((
  ref,
  postId,
) {
  final useCase = ref.watch(getCommentsStreamUseCaseProvider);
  return useCase.execute(postId);
});

final postCommentCountProvider = StreamProvider.family<int, String>((
  ref,
  postId,
) {
  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .snapshots()
      .map((doc) => doc.data()?['commentCount'] ?? 0);
});
