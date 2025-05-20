import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/data_providers.dart';
import '../entity/app_user.dart';
import '../repository/user_repository.dart';

class SaveUserToDatabaseUseCase {
  final UserRepository _repository;

  SaveUserToDatabaseUseCase(this._repository);

  Future<void> execute(AppUser user) => _repository.saveUserToDatabase(user);
}

final saveUserToDatabaseUseCaseProvider = Provider<SaveUserToDatabaseUseCase>(
  (ref) => SaveUserToDatabaseUseCase(ref.read(userRepositoryProvider)),
);
