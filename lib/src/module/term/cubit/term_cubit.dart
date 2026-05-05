import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/datasource/local/hive/term_hive_repository.dart';

part 'term_state.dart';
part 'term_cubit.freezed.dart';

@injectable
class TermCubit extends Cubit<TermState> {
  final TermHiveRepository _repository;

  TermCubit(this._repository) : super(const TermState());

  /// Gọi khi mở ở chế độ Edit: điền sẵn dữ liệu từ [term] vào state.
  void loadTerm(TermModel term) {
    emit(
      state.copyWith(
        term: term,
        title: term.title,
        markdownContent: term.markdownContent,
      ),
    );
  }

  void onChangeTitle(String value) {
    emit(state.copyWith(title: value));
  }

  void onChangeMarkdown(String value) {
    emit(state.copyWith(markdownContent: value));
  }

  /// Lưu term mới hoặc cập nhật term đang chỉnh sửa.
  Future<void> save() async {
    emit(state.copyWith(isLoading: true));

    final existing = state.term;
    final model = TermModel(
      id: existing?.id ?? const Uuid().v4(),
      title: state.title,
      markdownContent: state.markdownContent,
    );

    await _repository.save(model);
    emit(state.copyWith(isLoading: false, term: model, isSaved: true));
  }
}
