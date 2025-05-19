import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'package:share_lingo/core/utils/ui_util.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/utils/dialogue_util.dart';
import '../onboarding_view_model.dart';
import '../widgets/language_selection_modal.dart';

class LanguageSelectionTab extends ConsumerWidget {
  final String title;
  final String subtitle;
  final bool isNative;

  const LanguageSelectionTab({
    required this.title,
    required this.subtitle,
    required this.isNative,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userGlobalViewModelProvider)!;

    final selectedLang = isNative ? user.nativeLanguage : user.targetLanguage;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TitleSection(title: title),
            const SizedBox(height: 12),
            TitleSubtitleText(subtitle),
            const SizedBox(height: 40),

            if (selectedLang == null || selectedLang.isEmpty)
              _buildLangSelectButton(context: context, ref: ref)
            else ...[
              _buildSelectedLanguageRow(selectedLang, context, ref),
              const SizedBox(height: 20),
              _buildLangSelectButton(
                context: context,
                ref: ref,
                isChange: true,
              ),
            ],

            const Spacer(),
            _buildNextButton(selectedLang, context, ref),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedLanguageRow(
    String selectedLang,
    BuildContext context,
    WidgetRef ref,
  ) {
    final userGlobalViewModel = ref.read(userGlobalViewModelProvider.notifier);
    final countryCode = UiUtil.getCountryCodeByName(selectedLang);

    return GestureDetector(
      onTap: () {
        _selectLanguage(context, ref);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (countryCode != null)
              Row(
                children: [
                  const SizedBox(width: 3),
                  CountryFlag.fromCountryCode(
                    countryCode,
                    height: 24,
                    width: 24,
                    shape: const Circle(),
                  ),
                  const SizedBox(width: 14),
                  Text(selectedLang),
                ],
              )
            else
              Text(selectedLang),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                isNative
                    ? userGlobalViewModel.setNativeLanguage('')
                    : userGlobalViewModel.setTargetLanguage('');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangSelectButton({
    required BuildContext context,
    required WidgetRef ref,
    bool isChange = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _selectLanguage(context, ref),
        child: Text(isChange ? '언어 변경하기' : '언어 선택하기'),
      ),
    );
  }

  void _selectLanguage(BuildContext context, WidgetRef ref) async {
    final otherLanguage =
        !isNative
            ? ref.read(userGlobalViewModelProvider)!.nativeLanguage
            : null;
    final languageEntry = await showLanguageSelectionDialog(
      context,
      otherLanguage,
    );
    if (languageEntry != null) {
      final String selectedLang = languageEntry.koreanName;
      final vm = ref.read(userGlobalViewModelProvider.notifier);
      isNative
          ? vm.setNativeLanguage(selectedLang)
          : vm.setTargetLanguage(selectedLang);
    }
  }

  ElevatedButton _buildNextButton(
    String? selectedLang,
    BuildContext context,
    WidgetRef ref,
  ) {
    return ElevatedButton(
      onPressed:
          (selectedLang == null || selectedLang.isEmpty)
              ? null
              : () => _onNextPressed(
                selectedLang: selectedLang,
                context: context,
                ref: ref,
              ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            (selectedLang == null || selectedLang.isEmpty)
                ? AppColors.inactiveButton
                : AppColors.buttonsBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      child: const Text('다음으로'),
    );
  }

  void _onNextPressed({
    required BuildContext context,
    required String? selectedLang,
    required WidgetRef ref,
  }) {
    final user = ref.read(userGlobalViewModelProvider);

    if (selectedLang == null || selectedLang.isEmpty) {
      SnackbarUtil.showSnackBar(context, '언어를 선택해 주세요');
    } else if (!isNative && selectedLang == user?.nativeLanguage) {
      DialogueUtil.showAppCupertinoDialog(
        context: context,
        title: '잘못된 선택',
        content: '모국어와 학습 언어는 같을 수 없습니다',
      );
    } else {
      ref.read(onboardingViewModelProvider.notifier).nextPage();
    }
  }
}
