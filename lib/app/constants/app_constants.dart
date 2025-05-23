import '../../domain/entity/language_entry.dart';

abstract class AppConstants {
  static const appTitle = 'ShareLingo';
  static const vworldApiBaseUrl = 'https://api.vworld.kr/req';

  static const tags = [
    '어떻게 고쳐야 하나요?',
    '자연스럽게 번역해 주세요',
    '무슨 의미인가요?',
    '이런 표현들의 차이점은 뭐예요?',
    '숙제를 도와주세요',
    '오늘의 문장',
    '언어 교환',
  ];

  static const List<LanguageEntry> mostUsedLanguages = [
    LanguageEntry(koreanName: '영어', countryCode: 'US', languageCode: 'en'),
    LanguageEntry(koreanName: '한국어', countryCode: 'KR', languageCode: 'ko'),
    LanguageEntry(koreanName: '중국어', countryCode: 'CN', languageCode: 'zh'),
    LanguageEntry(koreanName: '일본어', countryCode: 'JP', languageCode: 'ja'),
    LanguageEntry(koreanName: '스페인어', countryCode: 'ES', languageCode: 'es'),
    LanguageEntry(koreanName: '프랑스어', countryCode: 'FR', languageCode: 'fr'),
  ];

  static const List<LanguageEntry> allLanguages = [
    LanguageEntry(koreanName: '네덜란드어', countryCode: 'NL', languageCode: 'nl'),
    LanguageEntry(koreanName: '노르웨이어', countryCode: 'NO', languageCode: 'no'),
    LanguageEntry(koreanName: '덴마크어', countryCode: 'DK', languageCode: 'da'),
    LanguageEntry(koreanName: '독일어', countryCode: 'DE', languageCode: 'de'),
    LanguageEntry(koreanName: '말레이어', countryCode: 'MY', languageCode: 'ms'),
    LanguageEntry(koreanName: '베트남어', countryCode: 'VN', languageCode: 'vi'),
    LanguageEntry(koreanName: '불가리아어', countryCode: 'BG', languageCode: 'bg'),
    LanguageEntry(koreanName: '세르비아어', countryCode: 'RS', languageCode: 'sr'),
    LanguageEntry(koreanName: '스웨덴어', countryCode: 'SE', languageCode: 'sv'),
    LanguageEntry(koreanName: '스페인어', countryCode: 'ES', languageCode: 'es'),
    LanguageEntry(koreanName: '아랍어', countryCode: 'SA', languageCode: 'ar'),
    LanguageEntry(koreanName: '우크라이나어', countryCode: 'UA', languageCode: 'uk'),
    LanguageEntry(koreanName: '우르두어', countryCode: 'PK', languageCode: 'ur'),
    LanguageEntry(koreanName: '웨일스어', countryCode: 'GB', languageCode: 'cy'),
    LanguageEntry(koreanName: '영어', countryCode: 'US', languageCode: 'en'),
    LanguageEntry(koreanName: '이탈리아어', countryCode: 'IT', languageCode: 'it'),
    LanguageEntry(koreanName: '인도네시아어', countryCode: 'ID', languageCode: 'id'),
    LanguageEntry(koreanName: '일본어', countryCode: 'JP', languageCode: 'ja'),
    LanguageEntry(koreanName: '중국어', countryCode: 'CN', languageCode: 'zh'),
    LanguageEntry(koreanName: '체코어', countryCode: 'CZ', languageCode: 'cs'),
    LanguageEntry(koreanName: '태국어', countryCode: 'TH', languageCode: 'th'),
    LanguageEntry(koreanName: '터키어', countryCode: 'TR', languageCode: 'tr'),
    LanguageEntry(koreanName: '페르시아어', countryCode: 'IR', languageCode: 'fa'),
    LanguageEntry(koreanName: '필리핀어', countryCode: 'PH', languageCode: 'tl'),
    LanguageEntry(koreanName: '폴란드어', countryCode: 'PL', languageCode: 'pl'),
    LanguageEntry(koreanName: '포르투갈어', countryCode: 'PT', languageCode: 'pt'),
    LanguageEntry(koreanName: '프랑스어', countryCode: 'FR', languageCode: 'fr'),
    LanguageEntry(koreanName: '핀란드어', countryCode: 'FI', languageCode: 'fi'),
    LanguageEntry(koreanName: '헝가리어', countryCode: 'HU', languageCode: 'hu'),
    LanguageEntry(koreanName: '힌디어', countryCode: 'IN', languageCode: 'hi'),
    LanguageEntry(koreanName: '한국어', countryCode: 'KR', languageCode: 'ko'),
  ];
}