import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/app_user.dart';
import '../../../domain/usecase/sign_in_with_google_usecase.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  const LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<AppUser?> signIn() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).execute();
      if (user == null) {
        state = state.copyWith(isLoading: false);
        return null;
      }
      state = state.copyWith(isLoading: false);
      return user;
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Login failed\n${e.toString()}",
      );
      rethrow;
    }
  }
}

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  () => LoginViewModel(),
);
