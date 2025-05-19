import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import '../../../../app/constants/app_colors.dart';
import '../onboarding_view_model.dart';

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
    final viewModel = ref.read(userGlobalViewModelProvider.notifier);

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
              _buildSelectedLanguageRow(selectedLang, viewModel),
              const SizedBox(height: 20),
              _buildLangSelectButton(
                context: context,
                ref: ref,
                isChange: true,
              ),
            ],

            const Spacer(),
            ElevatedButton(
              onPressed:
                  () => _onNextPressed(
                    selectedLang: selectedLang,
                    context: context,
                    ref: ref,
                  ),
              child: const Text('다음으로'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Container _buildSelectedLanguageRow(
    String selectedLang,
    UserGlobalViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(selectedLang),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              isNative
                  ? viewModel.setNativeLanguage('')
                  : viewModel.setTargetLanguage('');
            },
          ),
        ],
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
    // You would push to a language selection page here.
    // For now, simulate picking "Korean":
    final picked = await _fakeLanguagePicker(context);
    if (picked != null) {
      final vm = ref.read(userGlobalViewModelProvider.notifier);
      isNative ? vm.setNativeLanguage(picked) : vm.setTargetLanguage(picked);
    }
  }

  Future<String?> _fakeLanguagePicker(BuildContext context) async {
    // TODO: Replace with real navigator and selection screen
    return await showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Choose a language'),
            content: const Text('Simulated selection'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Korean'),
                child: const Text('Korean'),
              ),
            ],
          ),
    );
  }

  void _onNextPressed({
    required BuildContext context,
    required String? selectedLang,
    required WidgetRef ref,
  }) {
    if (selectedLang == null || selectedLang.isEmpty) {
      SnackbarUtil.showSnackBar(context, '언어를 선택해 주세요');
    } else {
      ref.read(onboardingViewModelProvider.notifier).nextPage();
    }
  }
}
