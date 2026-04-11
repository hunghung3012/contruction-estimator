import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../domain/model/invoice.dart';

part 'invoice_state.dart';
part 'invoice_cubit.freezed.dart';

@lazySingleton
class InvoiceCubit extends Cubit<InvoiceState> {
  StreamSubscription<List<Invoice>>? _sub;

  InvoiceCubit() : super(InvoiceState.initial([], false, null)) {
    loadInvoices();
    _listenInvoices();
  }

  void _listenInvoices() {
    // _sub = _repository.watchAllInvoices().listen((invoices) {
    //   emit(state.copyWith(invoices: invoices));
    // });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }

  Future<void> loadInvoices() async {
    emit(state.copyWith(isLoading: true));

    // final invoices = await _repository.getAll();

    // emit(state.copyWith(invoices: invoices, isLoading: false));
  }

  Future<void> createInvoice() async {
    // final invoice = Invoice(
    //   const Uuid().v4(),
    //   null,
    //   null,
    //   'New Invoice',
    //   null,
    //   'INV-${DateTime.now().millisecondsSinceEpoch}',
    //   0,
    //   0,
    //   DateTime.now(),
    //   DateTime.now(),
    // );

    // await _repository.createInvoice(invoice);
    await loadInvoices();
  }

  Future<void> updateInvoice(Invoice invoice) async {
    // await _repository.updateInvoice(invoice);
    await loadInvoices();
  }

  // ========================
  // Delete
  // ========================

  Future<void> deleteInvoice(String invoiceId) async {
    // await _repository.deleteInvoice(invoiceId);
    await loadInvoices();
  }
}
