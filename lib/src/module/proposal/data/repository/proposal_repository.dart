import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../service/proposal_service.dart';
import '../../domain/model/proposal.dart';

@injectable
class ProposalRepository {
  final ProposalApi _api;

  ProposalRepository(this._api);

  Future<Result<StatusApiResponse, ApiError>> createProposal({
    required Proposal? proposal,
    CancelToken? token,
  }) async {
    final result = _api.createProposal(
      AppStorage.userId ?? '',
      proposal,
      token,
    );

    return result.tryGet((response) => response);
  }

  Future<Result<Proposal, ApiError>> getProposal({
    required String proposalId,
    CancelToken? token,
  }) async {
    final result = _api.getProposal(proposalId, AppStorage.userId ?? '', token);

    return result.tryGet((response) => response.data);
  }

  Future<Result<PagingApiResponse<Proposal>, ApiError>> getProposals({
    String? projectId,
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.getProposals(
      AppStorage.userId ?? '',
      projectId,
      nextCursor,
      token,
    );

    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> deleteProposal({
    required String proposalId,
    CancelToken? token,
  }) async {
    final result = _api.deleteProposal(
      proposalId,
      AppStorage.userId ?? '',
      token,
    );

    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> deleteAllProposals({
    CancelToken? token,
  }) async {
    final result = _api.deleteAllProposals(AppStorage.userId ?? '', token);

    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> updateProposal({
    required String proposalId,
    required Proposal? proposal,
    CancelToken? token,
  }) async {
    final result = _api.updateProposal(
      proposalId,
      AppStorage.userId ?? '',
      proposal,
      token,
    );

    return result.tryGet((response) => response);
  }
}
