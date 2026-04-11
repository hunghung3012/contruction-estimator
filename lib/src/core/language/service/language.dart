import 'dart:ui';

enum Language { en, vi }

const _languageCodeMap = {Language.en: 'en', Language.vi: 'vi'};

final _codeToLanguageMap = {
  for (var entry in _languageCodeMap.entries) entry.value: entry.key,
};

Language languageFromCode(String? code) {
  if (code == null) return Language.en;

  final normalized = code.toLowerCase().split('-').first;

  return _codeToLanguageMap[normalized] ?? Language.en;
}

extension LanguageX on Language {
  String get code => _languageCodeMap[this]!;

  Locale get locale => Locale(code);
}

extension StringX on String {
  Language toLanguage() => languageFromCode(this);
}

extension LocaleX on Locale {
  Language toLanguage() => languageFromCode(languageCode);
}
