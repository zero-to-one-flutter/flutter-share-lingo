class UserValidator {
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) return '이름을 입력해 주세요';
    if (name.trim().length < 2) return '2글자 이상 입력해야 해요';
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
}