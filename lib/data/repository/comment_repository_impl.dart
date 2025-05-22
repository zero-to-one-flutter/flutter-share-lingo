import '../../domain/entity/comment.dart';
import '../../domain/repository/comment_repository.dart';
import '../data_source/comment_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource dataSource;

  CommentRepositoryImpl(this.dataSource);

  @override
  Stream<List<Comment>> getCommentsStream(String postId) {
    return dataSource
        .getCommentsStream(postId)
        .map((dtoList) => dtoList.map((dto) => dto.toEntity()).toList());
  }
}
