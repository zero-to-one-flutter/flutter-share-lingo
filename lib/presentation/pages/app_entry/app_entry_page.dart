import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/navigation_util.dart';
import 'package:share_lingo/presentation/pages/app_entry/app_entry_view_model.dart';

import '../../../core/providers/data_providers.dart';
import '../../user_global_view_model.dart';
import '../login/login_page.dart';

class AppEntryPage extends ConsumerWidget {
  const AppEntryPage({super.key});

  void _resolveAuthAndRoute(WidgetRef ref, BuildContext context) {
    ref.listen(authStateChangesProvider, (prev, next) {
      next.whenData((firebaseUserId) async {
        final splashViewModel = ref.read(appEntryViewModelProvider.notifier);
        if (firebaseUserId == null) {
          _navigateToLoginPage(context); // Not logged in → go to login page
        } else {
          // Logged in → check Firestore profile
          final userInFirestore = await splashViewModel.loadUser(
            firebaseUserId,
          );
          if (userInFirestore == null) {
            // User not in Firestore → log out and go to LoginPage again
            await splashViewModel.signOut();
            if (context.mounted) {
              _navigateToLoginPage(context);
            }
          } else {
            // User in Firestore. Check if profile completed and navigate
            // to ProfileEditPage or HomePage
            final userGlobalViewModel = ref.read(
              userGlobalViewModelProvider.notifier,
            );
            userGlobalViewModel.setUser(userInFirestore);
            if (context.mounted) {
              NavigationUtil.navigateBasedOnProfile(context, userInFirestore);
            }
          }
        }
      });
    });
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _resolveAuthAndRoute(ref, context);

    return const Scaffold(
      body: Center(child: CupertinoActivityIndicator(radius: 20)),
    );
  }
}
