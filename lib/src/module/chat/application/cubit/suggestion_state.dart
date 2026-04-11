part of 'suggestion_cubit.dart';

@freezed
abstract class SuggestionState with _$SuggestionState {
  const factory SuggestionState.initial({
    @Default([]) List<Suggestion> suggestions,
  }) = _Initial;
}
