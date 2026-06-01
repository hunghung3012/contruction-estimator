import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/event/reload_change_orders_list_event.dart';
import '../../../common/event/reload_estimates_list_event.dart';
import '../../../common/utils/logger.dart';
import '../../change_order/data/request/change_order_status_request.dart';
import '../../change_order/domain/model/change_order_status.dart';
import '../../estimate/domain/model/estimate.dart';
import '../../estimate/domain/model/estimate_status.dart';
import '../../estimate/domain/request/estimate_status_request.dart';
import '../../invoice/domain/model/invoice.dart';
import '../../proposal/domain/model/proposal.dart';
import '../../proposal/domain/model/proposal_status.dart';
import '../../proposal/domain/request/proposal_status_request.dart';
import '../../change_order/domain/model/change_order.dart';
import '../domain/model/project.dart';
import '../domain/repository/project_detail_repository.dart';

part 'project_detail_state.dart';
part 'project_detail_cubit.freezed.dart';

@injectable
class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  final ProjectDetailRepository _repository;

  final EventBus _eventBus;
  late final StreamSubscription _reloadListEstimatesSubscription;
  late final StreamSubscription _reloadListChangeOrdersSubscription;

  ProjectDetailCubit(this._repository, this._eventBus)
    : super(const ProjectDetailState()) {
    _reloadListEstimatesSubscription = _eventBus
        .on<ReloadEstimatesListEvent>()
        .listen((_) {
          final projectId = state.project?.id;
          if (projectId != null) {
            loadEstimates(projectId);
          }
        });
    _reloadListChangeOrdersSubscription = _eventBus
        .on<ReloadChangeOrdersListEvent>()
        .listen((_) {
          final projectId = state.project?.id;
          if (projectId != null) {
            loadChangeOrders(projectId);
          }
        });
  }

  @override
  Future<void> close() {
    _reloadListEstimatesSubscription.cancel();
    _reloadListChangeOrdersSubscription.cancel();
    return super.close();
  }

  Future<void> init(Project project) async {
    emit(state.copyWith(project: project, isLoading: true));

    await Future.wait([
      loadEstimates(project.id),
      loadProposals(project.id),
      loadChangeOrders(project.id),
      loadInvoices(project.id),
    ]);

    emit(state.copyWith(isLoading: false));
  }

  Future<void> refresh() async {
    final projectId = state.project?.id;
    if (projectId == null || projectId.isEmpty) return;

    await Future.wait([
      loadEstimates(projectId),
      loadProposals(projectId),
      loadChangeOrders(projectId),
      loadInvoices(projectId),
    ]);
  }

  Future<void> loadEstimates(String? projectId) async {
    if (projectId == null || projectId.isEmpty) return;

    emit(state.copyWith(isEstimatesLoading: true));
    final result = await _repository.estimates(projectId);
    result.fold(
      (data) => emit(
        state.copyWith(estimates: data.items, isEstimatesLoading: false),
      ),
      (error) {
        logger.e('Error loading project estimates: ${error.message}');
        emit(
          state.copyWith(
            isEstimatesLoading: false,
            estimatesError: error.message,
          ),
        );
      },
    );
  }

  Future<void> loadProposals(String? projectId) async {
    if (projectId == null || projectId.isEmpty) return;

    emit(state.copyWith(isProposalsLoading: true));
    final result = await _repository.proposals(projectId);
    result.fold(
      (data) => emit(
        state.copyWith(proposals: data.items, isProposalsLoading: false),
      ),
      (error) {
        logger.e('Error loading project proposals: ${error.message}');
        emit(
          state.copyWith(
            isProposalsLoading: false,
            proposalsError: error.message,
          ),
        );
      },
    );
  }

  Future<bool> createProposalFromEstimate(String estimateId) async {
    final result = await _repository.createProposalFromEstimate(estimateId);

    return result.fold(
      (response) {
        final newProposal = response.data;
        final updatedProposals = [...state.proposals, newProposal];

        final estimateIndex = state.estimates.indexWhere(
          (e) => e.id == estimateId,
        );
        var updatedEstimates = state.estimates;
        if (estimateIndex != -1) {
          updatedEstimates = List<Estimate>.from(state.estimates);
          updatedEstimates[estimateIndex] = state.estimates[estimateIndex]
              .copyWith(status: EstimateStatus.converted);
        }

        emit(
          state.copyWith(
            proposals: updatedProposals,
            estimates: updatedEstimates,
          ),
        );
        return true;
      },
      (error) {
        logger.e('Error converting estimate to proposal: ${error.message}');
        return false;
      },
    );
  }

  Future<bool> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {
    // When approving a proposal, supersede any other currently-approved proposals first.
    final toSupersede = status == ProposalStatus.approved
        ? state.proposals
              .where(
                (p) =>
                    p.id != null &&
                    p.id != proposalId &&
                    p.status == ProposalStatus.approved,
              )
              .toList()
        : <Proposal>[];

    for (final p in toSupersede) {
      final supersedeResult = await _repository.updateProposalStatus(
        p.id!,
        ProposalStatusRequest(status: ProposalStatus.superseded),
      );
      final ok = supersedeResult.fold((_) => true, (error) {
        logger.e('Error superseding proposal ${p.id}: ${error.message}');
        return false;
      });
      if (!ok) return false;
    }

    final request = ProposalStatusRequest(status: status);
    final result = await _repository.updateProposalStatus(proposalId, request);

    return result.fold(
      (_) {
        final supersededIds = toSupersede.map((p) => p.id).toSet();
        final updated = state.proposals.map((p) {
          if (p.id == proposalId) {
            return p.copyWith(status: status);
          }
          if (supersededIds.contains(p.id)) {
            return p.copyWith(status: ProposalStatus.superseded);
          }
          return p;
        }).toList();
        emit(state.copyWith(proposals: updated));
        return true;
      },
      (error) {
        logger.e('Error updating proposal: ${error.message}');
        return false;
      },
    );
  }

  Future<bool> updateChangeOrderStatus(
    String changeOrderId,
    ChangeOrderStatus newStatus,
  ) async {
    final index = state.changeOrders.indexWhere((c) => c.id == changeOrderId);
    if (index == -1) return false;

    final request = ChangeOrderStatusRequest(status: newStatus);
    final result = await _repository.updateChangeOrderStatus(
      changeOrderId,
      request,
    );

    return result.fold(
      (updated) {
        final list = List<ChangeOrder>.from(state.changeOrders);
        list[index] = updated;
        emit(state.copyWith(changeOrders: list));
        return true;
      },
      (error) {
        logger.e('Error updating change order status: ${error.message}');
        return false;
      },
    );
  }

  Future<void> loadChangeOrders(String? projectId) async {
    if (projectId == null || projectId.isEmpty) return;

    emit(state.copyWith(isChangeOrdersLoading: true));
    final result = await _repository.changeOrders(projectId);
    result.fold(
      (data) => emit(
        state.copyWith(changeOrders: data.items, isChangeOrdersLoading: false),
      ),
      (error) {
        logger.e('Error loading project change orders: ${error.message}');
        emit(state.copyWith(isChangeOrdersLoading: false));
      },
    );
  }

  Future<bool> updateEstimateStatus(
    String estimateId,
    EstimateStatus newStatus,
  ) async {
    final index = state.estimates.indexWhere((e) => e.id == estimateId);
    if (index == -1) return false;

    final request = EstimateStatusRequest(status: newStatus);
    final result = await _repository.updateEstimateStatus(estimateId, request);

    return result.fold(
      (updatedEstimate) {
        final updated = List<Estimate>.from(state.estimates);
        updated[index] = updatedEstimate;
        emit(state.copyWith(estimates: updated));
        return true;
      },
      (error) {
        logger.e('Error updating estimate status: ${error.message}');
        return false;
      },
    );
  }

  Future<bool> deleteProposal(String proposalId) async {
    final result = await _repository.deleteProposal(proposalId);

    return result.fold(
      (_) {
        final updated = state.proposals
            .where((p) => p.id != proposalId)
            .toList();
        emit(state.copyWith(proposals: updated));
        return true;
      },
      (error) {
        logger.e('Error deleting proposal: ${error.message}');
        return false;
      },
    );
  }

  Future<bool> deleteEstimate(String estimateId) async {
    final result = await _repository.deleteEstimate(estimateId);

    return result.fold(
      (_) {
        final updated = state.estimates
            .where((e) => e.id != estimateId)
            .toList();
        emit(state.copyWith(estimates: updated));
        return true;
      },
      (error) {
        logger.e('Error deleting estimate: ${error.message}');
        return false;
      },
    );
  }

  Future<void> loadInvoices(String? projectId) async {
    if (projectId == null || projectId.isEmpty) return;

    emit(state.copyWith(isInvoicesLoading: true));
    final result = await _repository.invoices(projectId);
    result.fold(
      (data) =>
          emit(state.copyWith(invoices: data.items, isInvoicesLoading: false)),
      (error) {
        logger.e('Error loading project invoices: ${error.message}');
        emit(
          state.copyWith(
            isInvoicesLoading: false,
            invoicesError: error.message,
          ),
        );
      },
    );
  }
}
