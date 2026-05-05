part of 'invoice_detail_cubit.dart';

@freezed
abstract class InvoiceDetailState with _$InvoiceDetailState {
  const factory InvoiceDetailState({
    @Default(null) Invoice? invoice,
    @Default(null) Invoice? initialInvoice,
    @Default(false) bool isLoading,
    @Default(InvoiceTab.invoice) InvoiceTab tab,
    @Default(null) File? logoFile,
    @Default(null) TermModel? currentTerm,
    @Default('') String currencyUnit,
    @Default(null) Client? selectedClient,
  }) = _InvoiceDetailState;

  const InvoiceDetailState._();

  bool get isEditting =>
      invoice != initialInvoice ||
      (currentTerm?.markdownContent ?? '') !=
          (initialInvoice?.termsAndConditions ?? '') ||
      (currencyUnit) != (initialInvoice?.unit ?? '');
}
