import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import '../../data/service/estimate_service.dart';
import '../model/estimate.dart';

@injectable
class EstimateRepository {
  final EstimateService _api;

  EstimateRepository(this._api);

  Future<Result<Estimate, ApiError>> update(
    String id,
    Estimate request, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.update(id, userId ?? '', request, token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<Invoice, ApiError>> convertToInvoice(
    String id, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.convertToInvoice(id, userId ?? '', token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<Proposal, ApiError>> convertToProposal(
    String id, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.convertToProposal(id, userId ?? '', token);
    return result.tryGet((response) => response.data);
  }
}
