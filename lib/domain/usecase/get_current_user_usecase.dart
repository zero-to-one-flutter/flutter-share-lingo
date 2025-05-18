import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/data_providers.dart';
import '../entity/app_user.dart';
import '../repository/user_repository.dart';

class GetUserByIdUseCase {
  final UserRepository _repository;

  GetUserByIdUseCase(this._repository);

  Future<AppUser?> execute(String uid) {
    return _repository.getUserById(uid);
  }
}

final getUserByIdUseCaseProvider = Provider<GetUserByIdUseCase>(
      (ref) => GetUserByIdUseCase(ref.read(userRepositoryProvider)),
);