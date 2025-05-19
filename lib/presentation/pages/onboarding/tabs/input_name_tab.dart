// first_name_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_view_model.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

import '../../../../domain/entity/app_user.dart';

class InputNameTab extends ConsumerStatefulWidget {
  final AppUser user;

  const InputNameTab(this.user, {super.key});

  @override
  ConsumerState<InputNameTab> createState() => _InputNameTabState();
}

class _InputNameTabState extends ConsumerState<InputNameTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() == true) {
      final name = _nameController.text.trim();
      final userGlobalViewModel = ref.read(
        userGlobalViewModelProvider.notifier,
      );
      userGlobalViewModel.setUser(widget.user.copyWith(name: name));
      final onBoardingViewModel = ref.read(onboardingViewModelProvider.notifier);
      onBoardingViewModel.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _Title(),
            SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.only(left: 5, bottom: 7),
              child: Text('이름'),
            ),
            _buildForm(),
            Spacer(),
            ElevatedButton(
              onPressed: _onNextPressed,
              child: const Text('다음으로'),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: '김민수',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: _buildBorder(radius: 18, color: Colors.grey[300]!),
          focusedBorder: _buildBorder(radius: 12, color: AppColors.buttonsBlue),
          errorBorder: _buildBorder(radius: 12, color: Colors.red),
          focusedErrorBorder: _buildBorder(radius: 12, color: Colors.red),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return '이름을 입력해 주세요';
          if (value.length < 2) return '2글자 이상 입력해야 해요';
          return null;
        },
      ),
    );
  }

  OutlineInputBorder _buildBorder({
    required double radius,
    required Color color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이름이나 닉네임을 입력해 주세요',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E1E1E),
      ),
    );
  }
}
