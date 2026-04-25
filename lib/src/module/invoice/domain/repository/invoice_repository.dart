import 'package:construction_estimator/src/core/datasource/local/shared_prederences/storage.dart';
import 'package:construction_estimator/src/core/datasource/remote/base/api_error.dart';
import 'package:construction_estimator/src/core/datasource/remote/base/api_response.dart';
import 'package:construction_estimator/src/core/datasource/remote/module/api_module.dart';
import 'package:construction_estimator/src/module/invoice/data/request/invoice_request.dart';
import 'package:construction_estimator/src/module/invoice/data/service/invoice_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../model/invoice.dart';

@injectable
class InvoiceRepository {
  final InvoiceApi _api;

  InvoiceRepository(this._api);

  Future<Result<Invoice, ApiError>> createInvoice({
    required CreateInvoiceRequest invoice,
    CancelToken? token,
  }) async {
    final result = _api.createInvoice(AppStorage.userId ?? '', invoice, token);

    return result.tryGet((response) => response);
  }

  Future<Result<PagingApiResponse<Invoice>, ApiError>> getInvoices({
    String? projectId,
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.getInvoices(
      AppStorage.userId ?? '',
      projectId ?? '',
      nextCursor,
      token,
    );

    return result.tryGet((response) => response);
  }

  Future<Result<Invoice, ApiError>> deleteInvoice({
    required String invoiceId,
    CancelToken? token,
  }) async {
    final result = _api.deleteInvoice(
      invoiceId,
      AppStorage.userId ?? '',
      token,
    );

    return result.tryGet((response) => response);
  }

  Future<Result<Invoice, ApiError>> deleteAllInvoices({
    CancelToken? token,
  }) async {
    final result = _api.deleteAllInvoices(AppStorage.userId ?? '', token);

    return result.tryGet((response) => response);
  }

  Future<Result<Invoice, ApiError>> updateInvoice({
    required String invoiceId,
    required CreateInvoiceRequest invoice,
    CancelToken? token,
  }) async {
    final result = _api.updateInvoice(
      invoiceId,
      AppStorage.userId ?? '',
      invoice,
      token,
    );

    return result.tryGet((response) => response);
  }
}
