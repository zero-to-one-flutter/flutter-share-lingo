import 'package:flutter/material.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_page.dart';

import '../../domain/entity/app_user.dart';
import '../../presentation/pages/home/home_page.dart';

abstract class NavigationUtil {
  static void navigateBasedOnProfile(BuildContext context, AppUser? appUser) {
    final isProfileCompleted = appUser?.nativeLanguage != null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => isProfileCompleted ? const HomePage() : OnboardingPage(),
      ),
    );
  }
}
