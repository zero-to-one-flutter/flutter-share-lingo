import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_constants.dart';
import 'package:share_lingo/core/utils/navigation_util.dart';

import '../../user_global_view_model.dart';
import 'login_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _login(WidgetRef ref, BuildContext context) async {
    final loginState = ref.read(loginViewModelProvider);
    if (loginState.isLoading) return;

    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    final appUser = await loginViewModel.signIn();

    if (appUser != null && appUser.id.isNotEmpty && context.mounted) {
      ref.read(userGlobalViewModelProvider.notifier).setUser(appUser);
      NavigationUtil.navigateBasedOnProfile(context, appUser);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset('assets/icons/app_icon.png', height: 150),
              ),
              const SizedBox(height: 15),

              const Text(
                AppConstants.appTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              Text(
                '글로 하는 언어 교환, 지금 시작하세요',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  width: 310,
                  child: OutlinedButton(
                    onPressed: () => _login(ref, context),
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        // side: const BorderSide(color: Colors.grey),
                      ),
                      minimumSize: const Size(double.infinity, 53),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/google.png', height: 18),
                        const SizedBox(width: 16),
                        Text(
                          loginState.isLoading ? '로그인 중...' : '구글 계정으로 시작하기',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
