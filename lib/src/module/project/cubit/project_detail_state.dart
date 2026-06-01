part of 'project_detail_cubit.dart';

@freezed
abstract class ProjectDetailState with _$ProjectDetailState {
  const factory ProjectDetailState({
    @Default(null) Project? project,
    @Default([]) List<Estimate> estimates,
    @Default([]) List<Proposal> proposals,
    @Default([]) List<Invoice> invoices,
    @Default([]) List<ChangeOrder> changeOrders,
    @Default(false) bool isLoading,
    @Default(false) bool isEstimatesLoading,
    @Default(false) bool isProposalsLoading,
    @Default(false) bool isInvoicesLoading,
    @Default(false) bool isChangeOrdersLoading,
    @Default(null) String? estimatesError,
    @Default(null) String? proposalsError,
    @Default(null) String? invoicesError,
  }) = _Initial;
}
