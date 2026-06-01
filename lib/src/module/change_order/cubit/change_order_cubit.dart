import 'package:bloc/bloc.dart';
import 'package:construction_estimator/src/module/change_order/domain/model/change_order_status.dart';
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../common/event/reload_change_orders_list_event.dart';
import '../../../common/utils/logger.dart';
import '../../estimate/domain/model/estimate.dart';
import '../../proposal/domain/model/proposal.dart';
import '../data/request/change_order_request.dart';
import '../domain/model/change_order.dart';
import '../domain/model/change_order_item.dart';
import '../domain/repository/change_order_repository.dart';

part 'change_order_state.dart';
part 'change_order_cubit.freezed.dart';

@injectable
class ChangeOrderCubit extends Cubit<ChangeOrderState> {
  final ChangeOrderRepository _repository;
  final EventBus _eventBus;

  ChangeOrderCubit(this._repository, this._eventBus)
    : super(const ChangeOrderState());

  void init({
    String? projectId,
    Proposal? proposal,
    bool isCreating = true,
    ChangeOrder? changeOrder,
  }) {
    if (isCreating || changeOrder == null) {
      emit(
        state.copyWith(
          projectId: projectId,
          proposal: proposal,
          proposalId: proposal?.id,
          isCreating: true,
          changeOrderId: null,
          name: '',
          items: const [],
          initialName: '',
          initialItems: const [],
          status: null,
        ),
      );
    } else {
      final loadedName = changeOrder.name ?? '';
      final loadedItems = changeOrder.items ?? const <ChangeOrderItem>[];
      emit(
        state.copyWith(
          projectId: projectId ?? changeOrder.projectId,
          proposal: proposal,
          proposalId: proposal?.id ?? changeOrder.proposalId,
          isCreating: false,
          changeOrderId: changeOrder.id,
          name: loadedName,
          items: loadedItems,
          initialName: loadedName,
          initialItems: loadedItems,
          status: changeOrder.status,
        ),
      );
    }
  }

  void onChangeName(String name) {
    emit(state.copyWith(name: name));
  }

  void addItem({
    required String name,
    required int quantity,
    required double price,
    required String measurementUnit,
    required ChangeOrderType type,
    String? unit,
  }) {
    final newItem = ChangeOrderItem(
      id: const Uuid().v4(),
      name: name,
      quantity: quantity,
      price: price,
      measurementUnit: measurementUnit,
      unit: unit,
      changeType: type,
    );
    emit(state.copyWith(items: [...state.items, newItem]));
  }

  void removeItem(String itemId) {
    final updated = state.items.where((i) => i.id != itemId).toList();
    emit(state.copyWith(items: updated));
  }

  void addItemFromEstimateItem(EstimateItem estimateItem) {
    final newItem = ChangeOrderItem(
      id: const Uuid().v4(),
      name: estimateItem.name,
      unit: estimateItem.unit,
      quantity: estimateItem.quantity,
      price: estimateItem.price,
      measurementUnit: estimateItem.measurementUnit,
      changeType: ChangeOrderType.remove,
    );
    emit(state.copyWith(items: [...state.items, newItem]));
  }

  Future<void> create() async {
    final projectId = state.projectId;
    if (projectId == null || projectId.isEmpty) return;
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true));
    final request = ChangeOrderRequest(
      projectId: projectId,
      proposalId: state.proposal?.id ?? state.proposalId,
      name: state.name.trim().isEmpty
          ? 'Change Order - ${DateTime.now().toLocal()}'
          : state.name.trim(),
      items: state.items,
      status: ChangeOrderStatus.draft,
    );
    final result = await _repository.create(request);
    result.fold(
      (changeOrder) {
        emit(
          state.copyWith(
            isSaving: false,
            isCreating: false,
            changeOrderId: changeOrder.id,
            initialName: state.name,
            initialItems: state.items,
            saveOutcome: ChangeOrderSaveOutcome(success: true, isCreate: true),
          ),
        );
        _eventBus.fire(ReloadChangeOrdersListEvent());
      },
      (error) {
        logger.e('Error creating change order: ${error.message}');
        emit(
          state.copyWith(
            isSaving: false,
            saveOutcome: ChangeOrderSaveOutcome(
              success: false,
              isCreate: true,
              errorMessage: error.message,
            ),
          ),
        );
      },
    );
  }

  Future<void> update() async {
    final id = state.changeOrderId;
    if (id == null || id.isEmpty) return;
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true));
    final request = ChangeOrder(
      id: id,
      projectId: state.projectId,
      proposalId: state.proposal?.id ?? state.proposalId,
      name: state.name,
      items: state.items,
    );
    final result = await _repository.update(id, request);
    result.fold(
      (_) {
        emit(
          state.copyWith(
            isSaving: false,
            initialName: state.name,
            initialItems: state.items,
            saveOutcome: ChangeOrderSaveOutcome(success: true, isCreate: false),
          ),
        );
        _eventBus.fire(ReloadChangeOrdersListEvent());
      },
      (error) {
        logger.e('Error updating change order: ${error.message}');
        emit(
          state.copyWith(
            isSaving: false,
            saveOutcome: ChangeOrderSaveOutcome(
              success: false,
              isCreate: false,
              errorMessage: error.message,
            ),
          ),
        );
      },
    );
  }

  void clearOutcome() {
    emit(state.copyWith(saveOutcome: null));
  }
}
