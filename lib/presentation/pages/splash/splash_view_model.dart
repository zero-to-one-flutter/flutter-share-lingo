import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/app_user.dart';
import '../../../domain/usecase/get_current_user_usecase.dart';
import '../../../domain/usecase/sign_out_use_case.dart';

class SplashViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<AppUser?> loadUser(String uid) {
    return ref.read(getUserByIdUseCaseProvider).execute(uid);
  }

  Future<void> signOut() async {
    await ref.read(signOutUseCaseProvider).execute();
  }
}

final splashViewModelProvider = NotifierProvider<SplashViewModel, void>(
  () => SplashViewModel(),
);
