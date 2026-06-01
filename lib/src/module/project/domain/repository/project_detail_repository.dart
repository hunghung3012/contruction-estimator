import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../../change_order/data/service/change_order_api.dart';
import '../../../change_order/data/request/change_order_status_request.dart';
import '../../../estimate/data/service/estimate_service.dart';
import '../../../estimate/domain/request/estimate_status_request.dart';
import '../../../proposal/data/service/proposal_service.dart';
import '../../../proposal/domain/request/proposal_status_request.dart';
import '../../data/service/project_detail_service.dart';
import '../../../estimate/domain/model/estimate.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import '../../../change_order/domain/model/change_order.dart';

@injectable
class ProjectDetailRepository {
  final ProjectDetailApi _api;
  final EstimateService _estimateApi;
  final ProposalApi _proposalApi;
  final ChangeOrderService _changeOrderApi;

  ProjectDetailRepository(
    this._api,
    this._estimateApi,
    this._proposalApi,
    this._changeOrderApi,
  );

  //-------------------Estimates---------------

  Future<Result<PagingApiResponse<Estimate>, ApiError>> estimates(
    String projectId, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.estimates(
      projectId,
      AppStorage.userId,
      nextCursor,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<Estimate, ApiError>> updateEstimateStatus(
    String id,
    EstimateStatusRequest statusRequest, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _estimateApi.updateStatus(
      id,
      userId ?? '',
      statusRequest,
      token,
    );
    return result.tryGet((response) => response.data);
  }

  Future<Result<StatusApiResponse, ApiError>> deleteEstimate(
    String id, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _estimateApi.delete(id, userId ?? '', token);
    return result.tryGet((response) => response);
  }

  //-------------------Proposals---------------

  Future<Result<PagingApiResponse<Proposal>, ApiError>> proposals(
    String projectId, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.proposals(
      AppStorage.userId ?? '',
      projectId,
      nextCursor,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<SingleApiResponse<Proposal>, ApiError>>
  createProposalFromEstimate(
    String estimateId, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _estimateApi.convertToProposal(
      AppStorage.userId ?? '',
      estimateId,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> updateProposalStatus(
    String proposalId,
    ProposalStatusRequest statusRequest, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _proposalApi.updateProposalStatus(
      proposalId,
      AppStorage.userId ?? '',
      statusRequest,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> deleteProposal(
    String proposalId, {
    CancelToken? token,
  }) async {
    final result = _proposalApi.deleteProposal(
      proposalId,
      AppStorage.userId ?? '',
      token,
    );
    return result.tryGet((response) => response);
  }

  //-------------------Change Orders---------------

  Future<Result<PagingApiResponse<ChangeOrder>, ApiError>> changeOrders(
    String projectId, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.changeOrders(
      AppStorage.userId ?? '',
      null,
      projectId,
      nextCursor,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<ChangeOrder, ApiError>> updateChangeOrderStatus(
    String id,
    ChangeOrderStatusRequest statusRequest, {
    CancelToken? token,
  }) async {
    final result = _changeOrderApi.updateStatus(
      id,
      AppStorage.userId ?? '',
      statusRequest,
      token,
    );
    return result.tryGet((response) => response.data);
  }

  //-------------------Invoices---------------

  Future<Result<PagingApiResponse<Invoice>, ApiError>> invoices(
    String projectId, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.invoices(
      AppStorage.userId ?? '',
      projectId,
      nextCursor,
      token,
    );
    return result.tryGet((response) => response);
  }
}
