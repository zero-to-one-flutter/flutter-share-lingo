import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }

  void onIndexChanged(int newIndex) {
    state = newIndex;
  }
}

final homeViewModelProvider = AutoDisposeNotifierProvider<HomeViewModel, int>(() {
  return HomeViewModel();
});
