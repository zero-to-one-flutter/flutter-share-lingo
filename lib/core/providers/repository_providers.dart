import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_source/post_data_source.dart';
import '../../data/repository/post_repository_impl.dart';
import '../../domain/repository/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dataSource = ref.watch(postDataSourceProvider);
  return PostRepositoryImpl(dataSource);
});