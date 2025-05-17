import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/data_source/firebase_auth_data_source.dart';
import '../../data/data_source/google_sign_in_data_source.dart';
import '../../data/data_source/post_data_source.dart';
import '../../data/data_source/user_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../data/repository/post_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/post_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../data/repository/user_repository_impl.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dataSource = ref.watch(postDataSourceProvider);
  return PostRepositoryImpl(dataSource);
});

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
      (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final userRepositoryProvider = Provider<UserRepository>(
      (ref) => UserRepositoryImpl(ref.watch(userFirestoreDataSourceProvider)),
);