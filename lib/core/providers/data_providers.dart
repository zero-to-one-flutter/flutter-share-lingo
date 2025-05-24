import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_lingo/domain/usecase/fetch_current_updated_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_initial_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_lastest_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/fetch_older_posts_usecase.dart';
import 'package:share_lingo/domain/usecase/like_post_useCase.dart';
import 'package:share_lingo/domain/usecase/unlike_post_usecase.dart';
import 'package:share_lingo/domain/usecase/update_post_usecase.dart';
import 'package:share_lingo/domain/usecase/upload_image_usecase.dart';
import 'package:share_lingo/domain/usecase/vote_post_usecase.dart';

import '../../app/constants/app_constants.dart';
import '../../data/data_source/firebase_auth_data_source.dart';
import '../../data/data_source/google_sign_in_data_source.dart';
import '../../data/data_source/image_storage_data_source.dart';
import '../../data/data_source/location_data_source.dart';
import '../../data/data_source/user_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../data/repository/image_repository_impl.dart';
import '../../data/repository/location_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/image_repository.dart';
import '../../domain/repository/location_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../data/repository/user_repository_impl.dart';
import '../../data/data_source/post_remote_data_source.dart';
import '../../data/repository/post_repository_impl.dart';
import '../../domain/repository/post_repository.dart';
import '../../domain/usecase/create_post_usecase.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final googleSignInProvider = Provider((ref) => GoogleSignIn());
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final googleSignInDataSourceProvider = Provider<GoogleSignInDataSource>(
  (ref) => GoogleSignInDataSourceImpl(ref.read(googleSignInProvider)),
);

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>(
  (ref) => FirebaseAuthDataSourceImpl(ref.read(firebaseAuthProvider)),
);

final userFirestoreDataSourceProvider = Provider<UserFirestoreDataSource>(
  (ref) => UserFirestoreDataSource(ref.read(firestoreProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(googleSignInDataSourceProvider),
    ref.read(firebaseAuthDataSourceProvider),
    ref.read(userFirestoreDataSourceProvider),
  ),
);

final authStateChangesProvider = StreamProvider<String?>(
  (ref) => ref.read(authRepositoryProvider).authStateChanges(),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.read(userFirestoreDataSourceProvider)),
);

final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  return PostRemoteDataSource(
    storage: FirebaseStorage.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remoteDataSource = ref.read(postRemoteDataSourceProvider);
  return PostRepositoryImpl(remoteDataSource);
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return CreatePostUseCase(repository);
});
final uploadImageUseCaseProvider = Provider<UploadImageUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return UploadImageUseCase(repository);
});

final fetchInitialPostsUsecaseProvider = Provider(
  (ref) => FetchInitialPostsUsecase(ref.read(postRepositoryProvider)),
);

final fetchOlderPostsUsecaseProvider = Provider(
  (ref) => FetchOlderPostsUsecase(ref.read(postRepositoryProvider)),
);

final fetchLatestPostsUsecaseProvider = Provider(
  (ref) => FetchLastestPostsUsecase(ref.read(postRepositoryProvider)),
);

final fetchCurrentUpdatedPostsUsecase = Provider(
  (ref) => FetchCurrentUpdatedPostsUsecase(ref.read(postRepositoryProvider)),
);

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return UpdatePostUseCase(repository);
});

// Location
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.vworldApiBaseUrl,
      validateStatus: (status) => status != null && status < 500,
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );
});

final locationDataSourceProvider = Provider<LocationDataSource>(
  (ref) => VworldLocationDataSource(ref.read(dioProvider)),
);

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocationRepositoryImpl(ref.read(locationDataSourceProvider)),
);

// Image
final imageStorageDataSourceProvider = Provider<ImageStorageDataSource>(
  (ref) => FirebaseImageStorageDataSource(FirebaseStorage.instance),
);

final imageRepositoryProvider = Provider<ImageRepository>(
  (ref) => ImageRepositoryImpl(ref.read(imageStorageDataSourceProvider)),
);

final votePostUseCaseProvider = Provider(
  (ref) => VotePostUseCase(ref.read(postRepositoryProvider)),
);

final likePostUsecaseProvider = Provider<LikePostUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return LikePostUseCase(repository);
});

final unlikePostUsecaseProvider = Provider<UnlikePostUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return UnlikePostUseCase(repository);
});
