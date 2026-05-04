import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/utils/logger.dart';
import '../domain/model/proposal.dart';
import '../data/repository/proposal_repository.dart';

part 'proposal_state.dart';
part 'proposal_cubit.freezed.dart';

@lazySingleton
class ProposalCubit extends Cubit<ProposalState> {
  final ProposalRepository _repository;

  ProposalCubit(this._repository)
    : super(const ProposalState.initial([], false, null)) {
    loadProposals();
  }

  Future<void> loadProposals({String? projectId, int? cursor}) async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.getProposals(
      projectId: projectId,
      nextCursor: cursor,
    );

    result.fold(
      (data) {
        emit(state.copyWith(isLoading: false, proposals: data.items));
      },
      (error) {
        emit(state.copyWith(isLoading: false, error: error.message));
      },
    );
  }

  Future<void> deleteProposal(String proposalId) async {
    final result = await _repository.deleteProposal(proposalId: proposalId);
    result.fold(
      (data) {},
      (error) {
        logger.e('Error deleting proposal: ${error.message}');
      },
    );
    await loadProposals();
  }

  Future<void> deleteAllProposals() async {
    final result = await _repository.deleteAllProposals();
    result.fold(
      (data) {},
      (error) {
        logger.e('Error deleting all proposals: ${error.message}');
      },
    );
    await loadProposals();
  }
}
