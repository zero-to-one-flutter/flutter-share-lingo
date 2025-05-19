import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/input_bio_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/language_selection_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/input_name_date_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/step_progress_header.dart';
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
                      0 => InputNameDateTab(),
                      1 => LanguageSelectionTab(
                        title: '모국어를 선택해 주세요',
                        subtitle: '어릴 때부터 익숙하게 사용해 온 언어입니다. 나중에 변경할 수 있습니다',
                        isNative: true,
                      ),
                      2 => LanguageSelectionTab(
                        title: '학습 언어를 선택해 주세요',
                        subtitle: '지금 공부 중이거나 관심 있는 언어입니다',
                        isNative: false,
                      ),
                    3 => InputBioTab(),
                      _ => InputNameDateTab(),
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
