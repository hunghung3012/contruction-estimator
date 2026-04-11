import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/suggestion.dart';

part 'suggestion_state.dart';
part 'suggestion_cubit.freezed.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  SuggestionCubit() : super(SuggestionState.initial()) {
    init();
  }

  void init() {
    emit(
      SuggestionState.initial(
        suggestions: [
          Suggestion(
            name: 'Bathroom Remodel',
            description: 'Remodel your bathroom',
          ),
          Suggestion(
            name: 'Kitchen Remodel',
            description: 'Remodel your kitchen',
          ),
          Suggestion(
            name: 'Interior Paint',
            description: 'Paint your interior',
          ),
          Suggestion(
            name: 'Roof Replacement',
            description: 'Replace your roof',
          ),
          Suggestion(name: 'Deck Addition', description: 'Add a deck'),
        ],
      ),
    );
  }
}
