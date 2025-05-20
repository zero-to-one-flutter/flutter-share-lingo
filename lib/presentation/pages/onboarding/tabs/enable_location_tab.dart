import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_view_model.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/onboarding_input_decoration.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

import '../../../../app/constants/app_colors.dart';

class EnableLocationTab extends ConsumerStatefulWidget {
  const EnableLocationTab({super.key});

  @override
  ConsumerState<EnableLocationTab> createState() => _EnableLocationTabState();
}

class _EnableLocationTabState extends ConsumerState<EnableLocationTab> {

  void _onNextPressed() {
    // if (_formKey.currentState?.validate() == true) {
    final userGlobalViewModel = ref.read(userGlobalViewModelProvider.notifier);
    // userGlobalViewModel.setLocation();
    final onBoardingViewModel = ref.read(onboardingViewModelProvider.notifier);
    onBoardingViewModel.nextPage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.buttonsBlue,
                    size: 70,
                  ),
                  SizedBox(height: 20),
                  TitleSection(title: '위치 권한을 허용해 주세요'),
                  SizedBox(height: 12),
                  TitleSubtitleText(
                    '같은 지역에 있는 사용자들을 쉽게 찾을 수 있게 합니다',
                  ),
                  SizedBox(height: 70)
                ],
              ),
            ),

            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNextPressed,
                    child: const Text('위치 켜기'),
                  ),
                ),
                SizedBox(height: 2),
                TextButton(
                  onPressed: () {
                    // 위치 없이 진행 로직
                  },
                  child: const Text('위치 없이 진행하기'),
                ),
                SizedBox(height: 19),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
