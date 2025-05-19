import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_view_model.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/onboarding_input_decoration.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class InputBioTab extends ConsumerStatefulWidget {
  const InputBioTab({super.key});

  @override
  ConsumerState<InputBioTab> createState() => _InputBioTabState();
}

class _InputBioTabState extends ConsumerState<InputBioTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() == true) {
      final userGlobalViewModel = ref.read(
        userGlobalViewModelProvider.notifier,
      );
      userGlobalViewModel.setBio(_textController.text.trim());
      final onBoardingViewModel = ref.read(
        onboardingViewModelProvider.notifier,
      );
      onBoardingViewModel.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TitleSection(title: '언어 친구에게 자신을 소개해 보세요'),
              SizedBox(height: 12),
              TitleSubtitleText(
                '언어를 함께 배울 친구들이 당신을 이해할 수 있도록 소개를 작성해 주세요. 취미나 배우는 이유, 관심사 등을 자유롭게 표현하셔도 좋습니다',
              ),
              SizedBox(height: 28),
              _buildNameFormField(),

              SizedBox(height: 17),
              Center(
                child: Icon(
                  CupertinoIcons.info_circle,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Center(child: TitleSubtitleText('내용은 15자 이상 300자 이하로 입력해 주세요')),

              Spacer(),
              ElevatedButton(
                onPressed: _onNextPressed,
                child: const Text('다음으로'),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameFormField() {
    return TextFormField(
      minLines: 5,
      maxLines: 10,
      maxLength: 300,
      controller: _textController,
      decoration: onboardingInputDecoration(''),
      validator: (value) {
        final vm = ref.read(onboardingViewModelProvider.notifier);
        return vm.validateBio(value);
      },
    );
  }
}
