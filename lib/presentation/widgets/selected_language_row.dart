import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../core/utils/general_utils.dart';

class SelectedLanguageRow extends StatelessWidget {
  final String language;
  final VoidCallback onTap;
  final IconData icon;

  const SelectedLanguageRow({
    super.key,
    required this.language,
    required this.onTap,
    this.icon = Icons.change_circle,
  });

  @override
  Widget build(BuildContext context) {
    final countryCode = GeneralUtils.getCountryCodeByName(language);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (countryCode != null)
              Row(
                children: [
                  CountryFlag.fromCountryCode(
                    countryCode,
                    height: 24,
                    width: 24,
                    shape: const Circle(),
                  ),
                  const SizedBox(width: 12),
                  Text(language),
                ],
              )
            else
              Text(language),
            Icon(icon, color: AppColors.buttonsBlue,),
          ],
        ),
      ),
    );
  }
}
