part of 'change_order_cubit.dart';

class ChangeOrderSaveOutcome {
  final bool success;
  final bool isCreate;
  final String? errorMessage;

  ChangeOrderSaveOutcome({
    required this.success,
    required this.isCreate,
    this.errorMessage,
  });
}

@freezed
abstract class ChangeOrderState with _$ChangeOrderState {
  const factory ChangeOrderState({
    @Default(null) String? projectId,
    @Default(null) String? proposalId,
    @Default(null) String? changeOrderId,
    @Default('') String name,
    @Default([]) List<ChangeOrderItem> items,
    @Default('') String initialName,
    @Default([]) List<ChangeOrderItem> initialItems,
    @Default(null) Proposal? proposal,
    @Default(null) ChangeOrderStatus? status,
    @Default(false) bool isSaving,
    @Default(true) bool isCreating,
    @Default(null) ChangeOrderSaveOutcome? saveOutcome,
  }) = _ChangeOrderState;

  const ChangeOrderState._();

  bool get isEditting {
    if (name != initialName) return true;
    if (items.length != initialItems.length) return true;
    for (var i = 0; i < items.length; i++) {
      if (items[i] != initialItems[i]) return true;
    }
    return false;
  }

  bool get canEdit => isCreating || status == ChangeOrderStatus.draft;
}
