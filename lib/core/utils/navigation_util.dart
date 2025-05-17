import 'package:flutter/material.dart';

import '../../domain/entity/app_user.dart';
import '../../presentation/pages/home/home_page.dart';

abstract class NavigationUtil {
  static void navigateBasedOnProfile(BuildContext context, AppUser? appUser) {
    final hasLanguages =
        appUser?.nativeLanguage != null && appUser?.targetLanguage != null;

    // TODO: Navigate to ProfileEditPage when hasLanguages is false
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => hasLanguages ? const HomePage() : const HomePage(),
      ),
    );
  }
}
