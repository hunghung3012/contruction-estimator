import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../datasource/local/shared_prederences/storage.dart';
import '../service/language.dart';

part 'language_state.dart';
part 'language_cubit.freezed.dart';

@singleton
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState()) {
    _init();
  }

  List<Locale> get locales => state.languages.map((e) => e.locale).toList();

  void _init() {
    emit(
      state.copyWith(
        languages: Language.values,
        language: _resolveInitialLanguage(),
      ),
    );
  }

  Language _resolveInitialLanguage() {
    final savedLang = AppStorage.language;

    if (savedLang != null) {
      return savedLang.toLanguage();
    }

    return PlatformDispatcher.instance.locale.toLanguage();
  }

  Future<void> changeLanguage(Language language) async {
    await AppStorage.setLanguage(language.name);

    emit(state.copyWith(language: language));
  }
}
