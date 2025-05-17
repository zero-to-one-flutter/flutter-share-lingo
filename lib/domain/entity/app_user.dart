class AppUser {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? email;
  final String? profileImage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final String? bio;
  final DateTime? birthdate;
  final String? partnerPreference;
  final String? languageLearningGoal;

  AppUser({
    required this.id,
    required this.name,
    DateTime? createdAt,
    this.email,
    this.profileImage,
    this.nativeLanguage,
    this.targetLanguage,
    this.bio,
    this.birthdate,
    this.partnerPreference,
    this.languageLearningGoal,
  }) : createdAt = createdAt ?? DateTime.now();

  int? get age {
    if (birthdate == null) return null;
    final today = DateTime.now();
    int calculatedAge = today.year - birthdate!.year;
    if (today.month < birthdate!.month ||
        (today.month == birthdate!.month && today.day < birthdate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  AppUser copyWith({
    String? name,
    DateTime? createdAt,
    String? email,
    String? profileImage,
    String? nativeLanguage,
    String? targetLanguage,
    String? bio,
    DateTime? birthdate,
    String? partnerPreference,
    String? languageLearningGoal,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      bio: bio ?? this.bio,
      birthdate: birthdate ?? this.birthdate,
      partnerPreference: partnerPreference ?? this.partnerPreference,
      languageLearningGoal: languageLearningGoal ?? this.languageLearningGoal,
    );
  }
}
