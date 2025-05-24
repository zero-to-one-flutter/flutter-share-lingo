import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_lingo/core/utils/logger.dart';

import '../../../domain/entity/app_user.dart';
import '../../../domain/usecase/sign_in_with_google_usecase.dart';

class LoginState {
  final bool isLoading;
  final bool hasAgreedToTerms;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.hasAgreedToTerms = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? hasAgreedToTerms,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      hasAgreedToTerms: hasAgreedToTerms ?? this.hasAgreedToTerms,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  static const String _agreementKey = 'user_agreed_to_terms';

  @override
  LoginState build() {
    return const LoginState();
  }

  Future<void> loadAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    final agreed = prefs.getBool(_agreementKey) ?? false;
    state = state.copyWith(hasAgreedToTerms: agreed);
  }

  Future<void> setAgreement(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_agreementKey, value);
    state = state.copyWith(hasAgreedToTerms: value);
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
    } catch (e, stack) {
      logError(e, stack);
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
