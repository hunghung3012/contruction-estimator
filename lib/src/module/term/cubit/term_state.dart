part of 'term_cubit.dart';

@freezed
abstract class TermState with _$TermState {
  const factory TermState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaved,
    TermModel? term,
    @Default('') String title,
    @Default('') String markdownContent,
  }) = _TermState;
}
