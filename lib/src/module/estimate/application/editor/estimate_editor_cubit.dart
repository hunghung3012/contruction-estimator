import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'estimate_editor_state.dart';

@injectable
class EstimateEditorCubit extends Cubit<EstimateEditorState> {
  EstimateEditorCubit() : super(const EstimateEditorState());

  void updateAddingToCategory(String categoryId) {
    emit(
      state.copyWith(
        addingToCategoryId: categoryId,
        editingItemId: null,
        itemName: '',
        itemQuantity: '',
        itemPrice: '',
      ),
    );
  }

  void updateEditingItem({
    required String categoryId,
    required String itemId,
    required String name,
    required String quantity,
    required String price,
  }) {
    emit(
      state.copyWith(
        addingToCategoryId: categoryId,
        editingItemId: itemId,
        itemName: name,
        itemQuantity: quantity,
        itemPrice: price,
      ),
    );
  }

  void updateItemName(String name) => emit(state.copyWith(itemName: name));
  void updateItemQuantity(String qty) =>
      emit(state.copyWith(itemQuantity: qty));
  void updateItemPrice(String price) => emit(state.copyWith(itemPrice: price));
  void updateCategoryNameInput(String name) =>
      emit(state.copyWith(categoryName: name));

  void startEditingCategoryName(String id, String currentName) {
    emit(
      state.copyWith(
        editingCategoryNameId: id,
        categoryName: currentName,
        addingToCategoryId: null,
        editingItemId: null,
        isAddingCategory: false,
      ),
    );
  }

  void startAddingCategory() {
    emit(
      state.copyWith(
        editingCategoryNameId: null,
        categoryName: '',
        isAddingCategory: true,
        addingToCategoryId: null,
        editingItemId: null,
      ),
    );
  }

  void clear() {
    emit(state.copyWith(clear: true));
  }
}
