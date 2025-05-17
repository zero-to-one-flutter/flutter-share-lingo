import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/sign_in_with_google_usecase.dart';
import '../../user_global_view_model.dart';

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

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).execute();
      if (user == null) {
        return;
        // throw Exception("Login canceled");
      }
      ref.read(userGlobalViewModelProvider.notifier).setUser(user);
      state = state.copyWith(isLoading: false);
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
