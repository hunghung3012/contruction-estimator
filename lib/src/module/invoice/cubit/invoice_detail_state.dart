part of 'invoice_detail_cubit.dart';

@freezed
abstract class InvoiceDetailState with _$InvoiceDetailState {
  const factory InvoiceDetailState.initial(
    Invoice? selectedInvoice,
    InvoiceDetail? detail,
    bool isLoading,
    bool isEditing,
    String? error,
  ) = _Initial;
}
