import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/general_utils.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_view_model.dart';
import 'package:share_lingo/presentation/widgets/input_decorations.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/subtitle_text.dart';
import 'package:share_lingo/presentation/pages/onboarding/widgets/title_section.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class InputNameDateTab extends ConsumerStatefulWidget {
  const InputNameDateTab({super.key});

  @override
  ConsumerState<InputNameDateTab> createState() => _InputNameTabState();
}

class _InputNameTabState extends ConsumerState<InputNameDateTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _birthdateController;
  DateTime? birthdate;

  @override
  void initState() {
    super.initState();
    final userName = ref.read(userGlobalViewModelProvider)!.name;
    _nameController = TextEditingController(text: userName);
    _birthdateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() == true) {
      final userGlobalViewModel = ref.read(
        userGlobalViewModelProvider.notifier,
      );
      userGlobalViewModel.setName(_nameController.text.trim());
      userGlobalViewModel.setBirthdate(birthdate!);
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
              TitleSection(title: '이름과 생년월일을 입력해 주세요'),
              SizedBox(height: 12),
              TitleSubtitleText('정확한 정보를 입력해 주시면 더 맞춤화된 서비스를 제공할 수 있습니다.'),
              SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 7),
                child: Text('이름'),
              ),
              _buildNameFormField(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 7),
                child: Text('생년월일'),
              ),
              _buildDateInputField(),
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
      maxLength: 28,
      controller: _nameController,
      decoration: getInputDecoration('이름을 입력해 주세요'),
      validator: (value) {
        final vm = ref.read(onboardingViewModelProvider.notifier);
        return vm.validateName(value);
      },
    );
  }

  Widget _buildDateInputField() {
    return TextFormField(
      controller: _birthdateController,
      decoration: getInputDecoration('생년월일을 선택하세요', isDate: true),
      readOnly: true,
      onTap: () async {
        birthdate = await GeneralUtils.pickBirthdate(context: context);
        if (birthdate != null) {
          setState(() {
            _birthdateController.text =
                "${birthdate!.year}년 ${birthdate!.month}월 ${birthdate!.day}일";
          });
        }
      },
      validator: (value) {
        final vm = ref.read(onboardingViewModelProvider.notifier);
        return vm.validateBirthdate(birthdate);
      },
    );
  }
}
