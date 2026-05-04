part of 'proposal_detail_cubit.dart';

@freezed
abstract class ProposalDetailState with _$ProposalDetailState {
  const factory ProposalDetailState({
    @Default(null) Proposal? proposal,
    @Default(null) Proposal? initialProposal,
    @Default(false) bool isLoading,
    @Default(ProposalTab.proposal) ProposalTab tab,
    @Default(null) File? logoFile,
  }) = _ProposalDetailState;

  const ProposalDetailState._();

  bool get isEditing => proposal != initialProposal;
}
