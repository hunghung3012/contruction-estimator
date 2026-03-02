part of 'invoice_cubit.dart';

@freezed
abstract class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial(
    List<Invoice> invoices,
    bool isLoading,
    String? error,
  ) = _Initial;
}
