import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/utils/logger.dart';
import '../../domain/model/estimate.dart';
import '../../domain/repository/estimate_repository.dart';
import 'estimate_core_state.dart';

@injectable
class EstimateCoreCubit extends Cubit<EstimateCoreState> {
  final EstimateRepository _repository;

  EstimateCoreCubit(this._repository) : super(const EstimateCoreState());

  void init(Estimate estimator, {bool isCreating = false}) {
    // Sanitize estimator by ensuring all categories and items have IDs
    final sanitizedCategories = estimator.categories?.asMap().entries.map((
      entry,
    ) {
      final index = entry.key;
      final cat = entry.value;

      final sanitizedItems = cat.items?.map((item) {
        return item.id == null ? item.copyWith(id: const Uuid().v4()) : item;
      }).toList();

      return cat.copyWith(id: cat.id ?? '$index', items: sanitizedItems);
    }).toList();

    final sanitizedEstimator = estimator.copyWith(
      categories: sanitizedCategories,
    );

    emit(
      state.copyWith(
        estimator: sanitizedEstimator,
        initialEstimator: sanitizedEstimator,
        isCreating: isCreating,
      ),
    );
  }

  void save() async {
    if (state.estimator == null) return;
    emit(state.copyWith(isSaving: true));
    final result = await _repository.update(
      state.initialEstimator?.id ?? '',
      state.estimator!,
    );
    result.fold(
      (estimate) {
        emit(
          state.copyWith(
            initialEstimator: estimate,
            estimator: estimate,
            isSaving: false,
            saveOutcome: EstimateSaveOutcome(success: true, isCreate: false),
          ),
        );
      },
      (error) {
        logger.e("Error updating estimate: $error");
        emit(
          state.copyWith(
            isSaving: false,
            saveOutcome: EstimateSaveOutcome(
              success: false,
              isCreate: false,
              errorMessage: error.message,
            ),
          ),
        );
      },
    );
  }

  void create(String? projectId) async {
    if (state.estimator == null) return;
    emit(state.copyWith(isSaving: true));
    final result = await _repository.create(projectId ?? '', state.estimator!);
    result.fold(
      (estimate) {
        emit(
          state.copyWith(
            initialEstimator: estimate,
            estimator: estimate,
            isSaving: false,
            isCreating: false,
            saveOutcome: EstimateSaveOutcome(success: true, isCreate: true),
          ),
        );
      },
      (error) {
        logger.e("Error creating estimate: $error");
        emit(
          state.copyWith(
            isSaving: false,
            saveOutcome: EstimateSaveOutcome(
              success: false,
              isCreate: true,
              errorMessage: error.message,
            ),
          ),
        );
      },
    );
  }

  void clearOutcome() {
    emit(state.copyWith(clearSaveOutcome: true));
  }

  void deleteItem(String categoryId, String itemId) {
    final List<EstimateCategory>? updatedCategories = state
        .estimator
        ?.categories
        ?.mapIndexed((index, cat) {
          final id = cat.id ?? '$index';
          if (id == categoryId) {
            final List<EstimateItem> updatedItems = (cat.items ?? [])
                .where((i) => i.id != itemId)
                .toList();
            final newTotal = updatedItems.fold<double>(
              0,
              (sum, item) => sum + ((item.quantity ?? 0) * (item.price ?? 0)),
            );
            return cat.copyWith(items: updatedItems, totalPrice: newTotal);
          }
          return cat;
        })
        .toList();

    _updateEstimatorWithCategories(updatedCategories);
  }

  void upsertItem({
    required String categoryId,
    String? itemId,
    required String name,
    required int quantity,
    required double price,
  }) {
    final List<EstimateCategory>? updatedCategories = state
        .estimator
        ?.categories
        ?.mapIndexed((index, cat) {
          final id = cat.id ?? '$index';

          if (id == categoryId) {
            List<EstimateItem> updatedItems;
            if (itemId != null) {
              // Edit case
              updatedItems = (cat.items ?? []).map((item) {
                if (item.id == itemId) {
                  return item.copyWith(
                    name: name,
                    quantity: quantity,
                    price: price,
                  );
                }
                return item;
              }).toList();
            } else {
              // Add case
              final newItem = EstimateItem(
                id: const Uuid().v4(),
                name: name,
                quantity: quantity,
                price: price,
                unit: state.estimator?.currencyUnit,
              );
              updatedItems = [...(cat.items ?? []), newItem];
            }

            final newTotal = updatedItems.fold<double>(
              0,
              (sum, item) => sum + ((item.quantity ?? 0) * (item.price ?? 0)),
            );
            return cat.copyWith(items: updatedItems, totalPrice: newTotal);
          }
          return cat;
        })
        .toList();

    _updateEstimatorWithCategories(updatedCategories);
  }

  void deleteCategory(String categoryId) {
    final List<EstimateCategory>? updatedCategories = state
        .estimator
        ?.categories
        ?.whereIndexed((index, cat) {
          final id = cat.id ?? '$index';
          return id != categoryId;
        })
        .toList();

    _updateEstimatorWithCategories(updatedCategories);
  }

  void updateCategoryName(String categoryId, String newName) {
    final List<EstimateCategory>? updatedCategories = state
        .estimator
        ?.categories
        ?.mapIndexed((index, cat) {
          final id = cat.id ?? '$index';
          if (id == categoryId) {
            return cat.copyWith(name: newName);
          }
          return cat;
        })
        .toList();

    _updateEstimatorWithCategories(updatedCategories);
  }

  void addCategory(String name) {
    final newCategory = EstimateCategory(
      id: const Uuid().v4(),
      name: name,
      currencyUnit: state.estimator?.currencyUnit,
      totalPrice: 0,
      items: [],
    );
    final List<EstimateCategory> updatedCategories = [
      ...(state.estimator?.categories ?? []),
      newCategory,
    ];
    _updateEstimatorWithCategories(updatedCategories);
  }

  void _updateEstimatorWithCategories(
    List<EstimateCategory>? updatedCategories,
  ) {
    final newSubtotal =
        updatedCategories?.fold<double>(
          0,
          (sum, cat) => sum + (cat.totalPrice ?? 0),
        ) ??
        0;

    final updatedEstimator = state.estimator?.copyWith(
      categories: updatedCategories,
      totalPrice: newSubtotal,
    );

    emit(state.copyWith(estimator: updatedEstimator));
  }

  void updateMarkupPercent(int markup) {
    final updatedEstimator = state.estimator?.copyWith(markupPercent: markup);
    emit(state.copyWith(estimator: updatedEstimator));
  }

  void updateTaxPercent(int tax) {
    final updatedEstimator = state.estimator?.copyWith(taxPercent: tax);
    emit(state.copyWith(estimator: updatedEstimator));
  }
}
