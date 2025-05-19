import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/data_providers.dart';
import '../repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> execute() => _repository.signOut();
}

final signOutUseCaseProvider = Provider(
      (ref) => SignOutUseCase(ref.read(authRepositoryProvider)),
);
