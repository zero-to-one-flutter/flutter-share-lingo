import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/data_providers.dart';
import '../entity/app_user.dart';
import '../repository/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<AppUser?> execute() => _repository.signInWithGoogle();
}

final signInWithGoogleUseCaseProvider = Provider(
      (ref) => SignInWithGoogleUseCase(ref.read(authRepositoryProvider)),
);
