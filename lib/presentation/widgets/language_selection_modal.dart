import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../app/constants/app_constants.dart';
import '../../domain/entity/language_entry.dart';

Future<LanguageEntry?> showLanguageSelectionDialog(
  BuildContext context,
  String? otherLanguage,
) {
  final statusBarHeight = MediaQuery.of(context).padding.top;

  return showModalBottomSheet<LanguageEntry>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: statusBarHeight + 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: LanguageSelectionDialog(otherLanguage: otherLanguage),
      );
    },
  );
}

class LanguageSelectionDialog extends StatelessWidget {
  final String? otherLanguage;

  const LanguageSelectionDialog({super.key, this.otherLanguage});

  @override
  Widget build(BuildContext context) {
    final mostUsed = List.from(AppConstants.mostUsedLanguages)
      ..removeWhere((entry) => entry.koreanName == otherLanguage);
    final allLanguages = List.from(AppConstants.allLanguages)
      ..removeWhere((entry) => entry.koreanName == otherLanguage);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            controller: controller,
            children: [
              const SizedBox(height: 12),
              _buildDragHandle(),
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),
              _buildSectionTitle('자주 쓰는 언어'),
              const SizedBox(height: 10),
              ...mostUsed.map((entry) => _buildLanguageTile(context, entry)),
              const SizedBox(height: 24),
              _buildSectionTitle('기타 언어'),
              const SizedBox(height: 10),
              ...allLanguages.map(
                (entry) => _buildLanguageTile(context, entry),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      '언어를 선택하세요',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildLanguageTile(BuildContext context, LanguageEntry entry) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, entry);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CountryFlag.fromCountryCode(
              entry.countryCode,
              height: 27,
              width: 27,
              shape: const Circle(),
            ),
            const SizedBox(width: 16),
            Text(entry.koreanName, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
