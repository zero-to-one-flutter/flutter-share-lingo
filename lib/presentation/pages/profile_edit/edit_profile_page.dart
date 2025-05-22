import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/presentation/widgets/input_decorations.dart';
import '../../../core/utils/dialogue_util.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../domain/entity/app_user.dart';
import '../../widgets/language_selection_modal.dart';
import '../../widgets/profile_images.dart';
import '../../widgets/selected_language_row.dart';
import 'edit_profile_view_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final AppUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController languageLearningGoalController;
  late TextEditingController hobbiesController;
  late TextEditingController birthdateController;

  final _formKey = GlobalKey<FormState>();
  DateTime? birthdate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    bioController = TextEditingController(text: widget.user.bio ?? '');
    hobbiesController = TextEditingController(text: widget.user.hobbies ?? '');
    languageLearningGoalController = TextEditingController(
      text: widget.user.languageLearningGoal ?? '',
    );
    birthdate = widget.user.birthdate;
    birthdateController = TextEditingController(
      text:
          birthdate != null
              ? "${birthdate!.year}년 ${birthdate!.month}월 ${birthdate!.day}일"
              : '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    hobbiesController.dispose();
    languageLearningGoalController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: Locale('ko'),
      initialDate: birthdate ?? now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              // Example crimson color
              onPrimary: Colors.white,
              // Text color on primary (e.g. header text)
              surface: Colors.white,
              // Dialog background color
              onSurface: Colors.black87, // Default text color
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.blueAccent,
              // crimson
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStatePropertyAll(Colors.black87),
              todayForegroundColor: WidgetStatePropertyAll(Colors.white),
              todayBackgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthdate = picked;
      birthdateController.text =
          "${picked.year}년 ${picked.month}월 ${picked.day}일";
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await DialogueUtil.showAppCupertinoDialog(
      context: context,
      title: '저장',
      content: '변경사항을 저장하시겠습니까?',
      showCancel: true,
    );
    if (confirm != AppDialogResult.confirm) return;

    final vm = ref.read(editProfileViewModelProvider(widget.user).notifier);
    final stateRead = ref.read(editProfileViewModelProvider(widget.user));

    final updatedUser = widget.user.copyWith(
      name: nameController.text,
      nativeLanguage: stateRead.nativeLanguage,
      targetLanguage: stateRead.targetLanguage,
      district: stateRead.district,
      location: stateRead.location,
      bio: bioController.text,
      hobbies: hobbiesController.text,
      languageLearningGoal: languageLearningGoalController.text,
      birthdate: birthdate,
    );

    await vm.saveProfile(updatedUser);

    if (!mounted) return;
    SnackbarUtil.showSnackBar(context, '프로필이 성공적으로 저장되었습니다.');

    Navigator.of(context).pop();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      try {
        await ref
            .read(editProfileViewModelProvider(widget.user).notifier)
            .updateProfileImage(pickedFile);
        // SnackbarUtil.showSnackBar(context, '이미지가 성공적으로 업로드되었습니다.');
      } catch (e) {
        if (!mounted) return;
        SnackbarUtil.showSnackBar(
          context,
          '이미지 업로드 중 오류가 발생했습니다: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _changeLanguage({required bool isNative}) async {
    final otherLang =
        isNative
            ? ref.read(editProfileViewModelProvider(widget.user)).targetLanguage
            : ref
                .read(editProfileViewModelProvider(widget.user))
                .nativeLanguage;

    final result = await showLanguageSelectionDialog(context, otherLang);
    if (result == null) return;

    final vm = ref.read(editProfileViewModelProvider(widget.user).notifier);
    isNative
        ? vm.setNativeLanguage(result.koreanName)
        : vm.setTargetLanguage(result.koreanName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileViewModelProvider(widget.user));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final confirm = await DialogueUtil.showAppCupertinoDialog(
            context: context,
            title: '나가시겠습니까?',
            content: '변경사항이 저장되지 않을 수 있습니다.',
            showCancel: true,
          );

          if (confirm == AppDialogResult.confirm) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
          }
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('프로필 수정'),
            actions: [
              TextButton(
                onPressed: state.isSaving ? null : _saveProfile,
                child:
                    state.isSaving
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(
                          '저장',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileImages(
                    profileImageUrl: state.profileImageUrl,
                    geoPoint: widget.user.location,
                    isEditable: true,
                    onImageTap: _pickImage,
                    isLoading: state.isUploadingImage,
                  ),
                  InkWell(
                    onTap: !state.isUploadingImage ? _pickImage : null,
                    child: const SizedBox(height: 60, width: double.infinity),
                  ),

                  _buildLabeledField(
                    '이름',
                    nameController,
                    hintText: '이름을 입력하세요',
                    validator: (value) {
                      if (value == null || value.isEmpty) return '이름을 입력하세요';
                      if (value.length < 2) return '이름은 2자 이상이여야 합니다';
                      return null;
                    },
                  ),

                  // Languages
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('모국어', style: TextStyle(fontSize: 15)),
                        const SizedBox(height: 8),
                        SelectedLanguageRow(
                          language: state.nativeLanguage!,
                          onTap: () => _changeLanguage(isNative: true),
                        ),
                        const SizedBox(height: 20),
                        const Text('학습 언어', style: TextStyle(fontSize: 15)),
                        const SizedBox(height: 8),
                        SelectedLanguageRow(
                          language: state.targetLanguage!,
                          onTap: () => _changeLanguage(isNative: false),
                        ),
                      ],
                    ),
                  ),

                  _buildLabeledField(
                    '자기소개',
                    bioController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                    validator: (value) {
                      final vm = ref.read(
                        editProfileViewModelProvider(widget.user).notifier,
                      );
                      return vm.validateBio(value);
                    },
                  ),
                  _buildLabeledField(
                    '언어 학습 목표는 무엇인가요?',
                    languageLearningGoalController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                    // validator: (value) {
                    //   final vm = ref.read(
                    //     editProfileViewModelProvider(widget.user).notifier,
                    //   );
                    //   return vm.validateLanguageLearningGoal(value);
                    // },
                  ),

                  _buildLabeledField(
                    '취미는 무엇인가요?',
                    hobbiesController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                  ),

                  _buildDateField('생년월일', birthdateController),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 20,
                      top: 14,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '지역',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                // color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.district == null
                                      ? '위치 새로고침 버튼을 누르세요'
                                      : state.district!.isEmpty
                                      ? '현재는 대한민국의 지역만 지원됩니다'
                                      : state.district!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(40, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed:
                                    () =>
                                        ref
                                            .read(
                                              editProfileViewModelProvider(
                                                widget.user,
                                              ).notifier,
                                            )
                                            .refreshDistrict(),
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    String label,
    TextEditingController controller, {
    int? minLines,
    int maxLines = 1,
    int? maxLength,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            decoration: getInputDecoration(hintText),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: _pickBirthdate,
            decoration: getInputDecoration('생년월일을 선택하세요', isDate: true),
          ),
        ],
      ),
    );
  }
}
