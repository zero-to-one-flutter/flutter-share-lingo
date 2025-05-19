/*
import '../../domain/repository/post_repository.dart';
import '../data_source/post_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);
}
*/
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
}
