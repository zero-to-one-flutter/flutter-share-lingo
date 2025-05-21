import 'package:flutter/material.dart';

import '../../app/constants/app_constants.dart';

class GeneralUtils {
  static Future<DateTime?> pickBirthdate({
    required BuildContext context,
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();

    return await showDatePicker(
      context: context,
      locale: const Locale('ko'),
      initialDate: initialDate ?? now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.blueAccent,
              headerForegroundColor: Colors.white,
              // dayForegroundColor: WidgetStatePropertyAll(Colors.black87),
              todayForegroundColor: WidgetStatePropertyAll(Colors.white),
              todayBackgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static String? getCountryCodeByName(String name) {
    return AppConstants.allLanguages
        .firstWhere((entry) => entry.koreanName == name)
        .countryCode;
  }

  static String? getLanguageCodeByName(String name) {
    return AppConstants.allLanguages
        .firstWhere((entry) => entry.koreanName == name)
        .languageCode;
  }
}
