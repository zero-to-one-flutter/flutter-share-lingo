import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class PostDataSource {}

class PostDataSourceImpl implements PostDataSource {}

final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return PostDataSourceImpl();
});
