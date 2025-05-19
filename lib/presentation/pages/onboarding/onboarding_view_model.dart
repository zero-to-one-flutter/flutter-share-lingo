import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingViewModel extends AutoDisposeNotifier<int> {
  static const int totalPages = 3;

  @override
  int build() => 0;

  void nextPage() {
    if (state < totalPages - 1) state++;
  }

  void previousPage() {
    if (state > 0) state--;
  }
}

final onboardingViewModelProvider =
    AutoDisposeNotifierProvider<OnboardingViewModel, int>(
      OnboardingViewModel.new,
    );
