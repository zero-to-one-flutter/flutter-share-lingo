import '../../domain/repository/post_repository.dart';
import '../data_source/post_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);
}
