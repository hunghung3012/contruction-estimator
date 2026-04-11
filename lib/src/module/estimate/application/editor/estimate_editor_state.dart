import 'package:equatable/equatable.dart';

class EstimateEditorState extends Equatable {
  final String? addingToCategoryId;
  final String? editingItemId;
  final String? editingCategoryNameId;

  // Form inputs
  final String itemName;
  final String itemQuantity;
  final String itemPrice;
  final String categoryName;
  final bool isAddingCategory;

  const EstimateEditorState({
    this.addingToCategoryId,
    this.editingItemId,
    this.editingCategoryNameId,
    this.itemName = '',
    this.itemQuantity = '',
    this.itemPrice = '',
    this.categoryName = '',
    this.isAddingCategory = false,
  });

  bool get isAdding =>
      addingToCategoryId != null ||
      editingItemId != null ||
      editingCategoryNameId != null ||
      isAddingCategory;

  bool get isEditingItem => editingItemId != null;
  bool get isEditingCategory =>
      editingCategoryNameId != null || isAddingCategory;

  @override
  List<Object?> get props => [
    addingToCategoryId,
    editingItemId,
    editingCategoryNameId,
    itemName,
    itemQuantity,
    itemPrice,
    categoryName,
    isAddingCategory,
  ];

  EstimateEditorState copyWith({
    String? addingToCategoryId,
    String? editingItemId,
    String? editingCategoryNameId,
    String? itemName,
    String? itemQuantity,
    String? itemPrice,
    String? categoryName,
    bool? isAddingCategory,
    bool clear = false,
  }) {
    if (clear) {
      return const EstimateEditorState();
    }
    return EstimateEditorState(
      addingToCategoryId: addingToCategoryId ?? this.addingToCategoryId,
      editingItemId: editingItemId ?? this.editingItemId,
      editingCategoryNameId:
          editingCategoryNameId ?? this.editingCategoryNameId,
      itemName: itemName ?? this.itemName,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemPrice: itemPrice ?? this.itemPrice,
      categoryName: categoryName ?? this.categoryName,
      isAddingCategory: isAddingCategory ?? this.isAddingCategory,
    );
  }
}
