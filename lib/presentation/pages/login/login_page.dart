import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_constants.dart';
import 'package:share_lingo/core/firebase_service.dart';
import 'package:share_lingo/core/utils/navigation_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../user_global_view_model.dart';
import 'login_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = ref.read(loginViewModelProvider.notifier);
      await viewModel.loadAgreement(); // load value from SharedPreferences

      final state = ref.read(loginViewModelProvider);
      if (!state.hasAgreedToTerms) {
        _showConsentDialog();
      }
    });
  }

  Future<void> _showConsentDialog() async {
    bool accepted = false;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {},
              child: CupertinoAlertDialog(
                title: const Text("이용약관 및 개인정보처리방침"),
                content: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "앱 사용을 위해 아래 약관에 동의해 주세요.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 17),
                    GestureDetector(
                      onTap:
                          () => launchUrl(
                            Uri.parse(
                              'https://englim.me/share-lingo-page/terms',
                            ),
                          ),
                      child: Text(
                        "📜  이용약관 보기",
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.activeBlue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap:
                          () => launchUrl(
                            Uri.parse('https://englim.me/share-lingo-page'),
                          ),
                      child: Text(
                        "📄  개인정보처리방침 보기",
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.activeBlue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Transform.scale(
                            scale: 1.3, // makes the checkbox larger
                            child: CupertinoCheckbox(
                              value: accepted,
                              onChanged: (bool? value) {
                                setState(() => accepted = value ?? false);
                              },
                            ),
                          ),
                        ),
                        const Text(
                          "위 약관에 동의합니다.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed:
                        accepted
                            ? () {
                              ref
                                  .read(loginViewModelProvider.notifier)
                                  .setAgreement(true);
                              Navigator.of(context).pop();
                            }
                            : null,
                    isDefaultAction: true,
                    child: const Text("확인"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _login(WidgetRef ref, BuildContext context) async {
    // if (kDebugMode) {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.remove('user_agreed_to_terms');
    // }
    final loginState = ref.read(loginViewModelProvider);
    if (loginState.isLoading || !loginState.hasAgreedToTerms) return;

    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    final appUser = await loginViewModel.signIn();

    if (appUser != null && appUser.id.isNotEmpty && context.mounted) {
      ref.read(userGlobalViewModelProvider.notifier).setUser(appUser);
      await FirebaseService.analytics.logEvent(
        name: 'login_success',
        parameters: {
          'method': 'google',
          'user_id': appUser.id,
          'user_name': appUser.name,
        },
      );
      if (!context.mounted) return;
      NavigationUtil.navigateBasedOnProfile(context, appUser);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset('assets/icons/app_icon.png', height: 130),
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
