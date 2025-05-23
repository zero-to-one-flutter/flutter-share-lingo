import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/enable_location_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/input_bio_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/input_name_date_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/tabs/language_selection_tab.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/step_progress_header.dart';
import 'package:url_launcher/url_launcher.dart';

import 'onboarding_view_model.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogShown) {
      Future.delayed(Duration.zero, _showConsentDialog);
      _dialogShown = true;
    }
  }

  Future<void> _showConsentDialog() async {
    bool accepted = false;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: const Text("이용약관 및 개인정보처리방침"),
              content: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "앱 사용을 위해 아래 약관에 동의해 주세요.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 17),
                  GestureDetector(
                    onTap:
                        () => launchUrl(
                      Uri.parse('https://englim.me/share-lingo-page/terms'),
                    ),
                    child: Text(
                      "📜  이용약관 보기",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap:
                        () => launchUrl(
                      Uri.parse(
                        'https://englim.me/share-lingo-page',
                      ),
                    ),
                    child: Text(
                      "📄  개인정보처리방침 보기",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Transform.scale(
                          scale: 1.3, // makes the checkbox larger
                          child: CupertinoCheckbox(
                            value: accepted,
                            onChanged: (bool? value) {
                              setState(() => accepted = value ?? false);
                            },
                          ),
                        ),
                      ),
                      const Text("위 약관에 동의합니다.", style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("확인"),
                  onPressed:
                      accepted ? () => Navigator.of(context).pop() : null,
                  isDefaultAction: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      4 => EnableLocationTab(),
                      _ => InputNameDateTab(),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
