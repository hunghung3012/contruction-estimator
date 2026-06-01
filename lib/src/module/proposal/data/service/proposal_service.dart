import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../domain/model/proposal.dart';
import '../../domain/request/proposal_status_request.dart';

part 'proposal_service.g.dart';

@RestApi()
@injectable
abstract class ProposalApi {
  @factoryMethod
  factory ProposalApi(@Named('appDio') Dio dio) = _ProposalApi;

  @POST(ApiEndpoint.createProposal)
  Future<StatusApiResponse> createProposal(
    @Path('userId') String userId,
    @Body() Proposal? body,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.proposal)
  Future<SingleApiResponse<Proposal>> getProposal(
    @Path('proposalId') String proposalId,
    @Query('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.proposals)
  Future<PagingApiResponse<Proposal>> getProposals(
    @Path('userId') String userId,
    @Query('projectId') String? projectId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteProposal)
  Future<StatusApiResponse> deleteProposal(
    @Path('proposalId') String proposalId,
    @Query('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteAllProposals)
  Future<StatusApiResponse> deleteAllProposals(
    @Path('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateProposal)
  Future<StatusApiResponse> updateProposal(
    @Path('proposalId') String proposalId,
    @Query('userId') String userId,
    @Body() Proposal? proposal,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateProposal)
  Future<StatusApiResponse> updateProposalStatus(
    @Path('proposalId') String proposalId,
    @Query('userId') String userId,
    @Body() ProposalStatusRequest? statusRequest,
    @CancelRequest() CancelToken? cancelToken,
  );

}
