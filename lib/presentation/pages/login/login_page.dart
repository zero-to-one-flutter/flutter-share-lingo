import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_constants.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _login() async {
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loginState = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: Color(0XFF3478F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/app_logo_rounded.png',
                height: 120,
              ),
              const SizedBox(height: 10),

              // 앱 이름 또는 환영 텍스트
              const Text(
                AppConstants.appTitle,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),

              Text(
                '글로 하는 언어 교환, 지금 시작하세요',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              const SizedBox(height: 50),

              // 구글 로그인 버튼
              Center(
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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
                          false ? '로그인 중...' : '구글 계정으로 시작하기',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}