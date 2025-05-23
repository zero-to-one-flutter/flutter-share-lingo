class UserValidator {
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) return '이름을 입력해 주세요';
    if (name.trim().length < 2) return '1글자 이상 입력해 주세요';
    return null;
  }

  static String? validateBirthdate(DateTime? birthdate) {
    if (birthdate == null) return '생년월일을 선택해 주세요';

    final now = DateTime.now();
    final age = now.year - birthdate.year -
        ((now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)) ? 1 : 0);

    if (age < 18) return '만 18세 이상만 가입할 수 있어요';
    return null;
  }

  static String? validateBio(String? bio) {
    if (bio == null || bio.trim().isEmpty) return '자기소개를 입력해 주세요';
    if (bio.trim().length < 15) return '15글자 이상 입력해야 합니다';
    return null;
  }

  static String? validateGoal(String? bio) {
    if (bio == null || bio.trim().isEmpty) return '언어 학습 목표를 입력해 주세요';
    if (bio.trim().length < 2) return '2글자 이상 입력해야 합니다';
    return null;
  }
}