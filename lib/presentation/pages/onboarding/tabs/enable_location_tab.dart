import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/dialogue_util.dart';
import 'package:share_lingo/core/utils/navigation_util.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import '../../../../app/constants/app_colors.dart';
import 'enable_location_view_model.dart';

class EnableLocationTab extends ConsumerStatefulWidget {
  const EnableLocationTab({super.key});

  @override
  ConsumerState<EnableLocationTab> createState() => _EnableLocationTabState();
}

class _EnableLocationTabState extends ConsumerState<EnableLocationTab> {
  Future<void> _onEnableLocationPressed(BuildContext context) async {
    final vm = ref.read(locationViewModelProvider.notifier);
    await vm.fetchLocation();

    final state = ref.read(locationViewModelProvider);
    if (state.geoPoint != null) {
      final userVM = ref.read(userGlobalViewModelProvider.notifier);
      userVM.setLocation(state.geoPoint!);

      if (context.mounted) {
        await _saveUserAndNavigate(context);
      }
    }
  }

  Future<void> _onSkipPressed(BuildContext context) async {
    await _saveUserAndNavigate(context);
  }

  Future<void> _saveUserAndNavigate(BuildContext context) async {
    final userVM = ref.read(userGlobalViewModelProvider.notifier);
    await userVM.saveUserToDatabase();

    if (context.mounted) {
      await DialogueUtil.showAppCupertinoDialog(
        context: context,
        title: '회원가입 완료',
        content: '🎉 회원가입이 완료되었습니다!\n이제 언어 친구들을 만나보세요.',
      );
    }
    if (context.mounted) {
      NavigationUtil.navigateBasedOnProfile(
        context,
        ref.read(userGlobalViewModelProvider)!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationViewModelProvider);

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
                  const SizedBox(height: 20),
                  const TitleSection(title: '위치 권한을 허용해 주세요'),
                  const SizedBox(height: 12),
                  const TitleSubtitleText('같은 지역에 있는 사용자들을 쉽게 찾을 수 있게 합니다'),

                  const SizedBox(height: 70),
                ],
              ),
            ),
            _buildBottomLayout(state),
          ],
        ),
      ),
    );
  }

  Column _buildBottomLayout(LocationState state) {
    return Column(
      children: [
        if (state.errorMessage != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                () =>
                    state.isLoading ? null : _onEnableLocationPressed(context),
            child:
                state.isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('위치 사용하기'),
          ),
        ),
        const SizedBox(height: 2),
        TextButton(
          onPressed: () => _onSkipPressed(context),
          child: const Text('위치 없이 진행하기'),
        ),
        const SizedBox(height: 19),
      ],
    );
  }
}
