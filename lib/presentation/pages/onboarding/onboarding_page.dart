import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/input_name_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/step_progress_header.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import 'onboarding_view_model.dart';

class OnboardingPage extends ConsumerWidget {
  final PageController _pageController = PageController();

  OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(currentPage);
    });

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              StepProgressHeader(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: OnboardingViewModel.totalPages,
                  itemBuilder: (context, index) {
                    return switch (index) {
                      0 => InputNameDateTab(ref.read(userGlobalViewModelProvider)!),
                      1 => InputNameDateTab(ref.read(userGlobalViewModelProvider)!),
                      _ => InputNameDateTab(ref.read(userGlobalViewModelProvider)!),
                    };
                  },
                ),
              ),
              // Continue Button
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              //   child: ElevatedButton(
              //     onPressed: viewModel.nextPage,
              //     child: const Text('다음으로'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
