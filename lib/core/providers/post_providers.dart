import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_lingo/data/repository/post_repository_impl.dart';
import 'package:share_lingo/domain/repository/post_repository.dart';
import 'package:share_lingo/domain/usecase/post/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/post/update_post_usecase.dart';
import 'package:share_lingo/data/data_source/post_remote_data_source.dart';

final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  return PostRemoteDataSource(storage: FirebaseStorage.instance);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dataSource = ref.watch(postRemoteDataSourceProvider);
  return PostRepositoryImpl(dataSource);
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return CreatePostUseCase(repository);
});

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return UpdatePostUseCase(repository);
});
