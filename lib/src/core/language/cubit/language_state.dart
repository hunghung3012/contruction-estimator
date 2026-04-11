part of 'language_cubit.dart';

@freezed
abstract class LanguageState with _$LanguageState {
  const factory LanguageState({
    @Default([]) List<Language> languages,
    @Default(Language.en) Language language,
  }) = _LanguageState;
}
