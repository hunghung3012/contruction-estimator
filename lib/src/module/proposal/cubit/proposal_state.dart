part of 'proposal_cubit.dart';

@freezed
abstract class ProposalState with _$ProposalState {
  const factory ProposalState.initial(
    List<Proposal> proposals,
    bool isLoading,
    String? error,
  ) = _Initial;
}
