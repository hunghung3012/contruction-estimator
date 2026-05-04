import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/utils/logger.dart';
import '../domain/model/invoice.dart';
import '../domain/repository/invoice_repository.dart';

part 'invoice_state.dart';

part 'invoice_cubit.freezed.dart';

@lazySingleton
class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepository _repository;

  InvoiceCubit(this._repository)
    : super(InvoiceState.initial([], false, null)) {
    loadInvoices();
  }

  Future<void> loadInvoices({String? projectId, int? cursor}) async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.getInvoices(
      projectId: projectId,
      nextCursor: cursor,
    );

    result.fold(
      (data) {
        emit(state.copyWith(isLoading: false, invoices: data.items));
      },
      (error) {
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> createInvoice({required Invoice invoice}) async {
    final result = await _repository.createInvoice(invoice: invoice);

    result.fold((data) {}, (error) {
      logger.e('Error creating invoice: ${error.message}');
    });

    await loadInvoices();
  }

  Future<void> updateInvoice(Invoice invoice, String invoiceId) async {
    final result = await _repository.updateInvoice(
      invoiceId: invoiceId,
      invoice: invoice,
    );

    result.fold((data) {}, (error) {
      logger.e('Error creating invoice: ${error.message}');
    });

    await loadInvoices();
  }

  // ========================
  // Delete
  // ========================

  Future<void> deleteInvoice(String invoiceId) async {
    final result = await _repository.deleteInvoice(invoiceId: invoiceId);
    result.fold((data) {}, (error) {
      logger.e('Error deleting invoice: ${error.message}');
    });
    await loadInvoices();
  }

  Future<void> deleteAllInvoices() async {
    final result = await _repository.deleteAllInvoices();

    result.fold((data) {}, (error) {
      logger.e('Error deleting all invoices: ${error.message}');
    });
    await loadInvoices();
  }
}
