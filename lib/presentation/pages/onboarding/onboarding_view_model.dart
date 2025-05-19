import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/ui_validators/user_validator.dart';

class OnboardingViewModel extends AutoDisposeNotifier<int> {
  static const int totalPages = 4;

  @override
  int build() => 0;

  void nextPage() {
    if (state < totalPages - 1) state++;
  }

  void previousPage() {
    if (state > 0) state--;
  }

  String? validateName(String? name) => UserValidator.validateName(name);

  String? validateBirthdate(DateTime? birthdate) =>
      UserValidator.validateBirthdate(birthdate);

  String? validateBio(String? bio) => UserValidator.validateBio(bio);
}

final onboardingViewModelProvider =
    AutoDisposeNotifierProvider<OnboardingViewModel, int>(
      OnboardingViewModel.new,
    );
