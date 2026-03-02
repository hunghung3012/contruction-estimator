import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/invoice_repository.dart';
import '../domain/model/invoice.dart';
import '../domain/model/invoice_detail.dart';

part 'invoice_detail_state.dart';
part 'invoice_detail_cubit.freezed.dart';

@injectable
class InvoiceDetailCubit extends Cubit<InvoiceDetailState> {
  final InvoiceRepository _repository;
  InvoiceDetailCubit(this._repository)
    : super(InvoiceDetailState.initial(null, null, false, false, null));

  Future<void> selectInvoice(String invoiceId) async {
    emit(state.copyWith(isLoading: true));

    final detail = await _repository.loadFullDetail(invoiceId);

    emit(
      state.copyWith(
        selectedInvoice: detail?.invoice,
        detail: detail,
        isLoading: false,
      ),
    );
  }

  void toggleEdit() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  Future<void> updateInvoice({
    required String title,
    required double tax,
    required double discount,
  }) async {
    final invoice = state.selectedInvoice;
    if (invoice == null) return;

    emit(state.copyWith(isLoading: true));

    final updated = Invoice(
      invoice.id,
      invoice.projectId,
      invoice.estimateId,
      title,
      invoice.clientId,
      invoice.invoiceNumber,
      tax,
      discount,
      invoice.createdAt,
      DateTime.now(),
    );

    await _repository.updateInvoice(updated);

    final detail = await _repository.loadFullDetail(invoice.id);

    emit(
      state.copyWith(
        selectedInvoice: detail?.invoice,
        detail: detail,
        isLoading: false,
      ),
    );
  }

  Future<void> deleteInvoice() async {
    final id = state.selectedInvoice?.id;
    if (id == null) return;
    await _repository.deleteInvoice(id);
  }
}
