import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import '../../domain/model/estimate.dart';
import '../../domain/request/estimate_status_request.dart';

part 'estimate_service.g.dart';

@RestApi()
@injectable
abstract class EstimateService {
  @factoryMethod
  factory EstimateService(@Named('appDio') Dio dio) = _EstimateService;

  @POST(ApiEndpoint.createEstimate)
  Future<SingleApiResponse<Estimate>> create(
    @Path('projectId') String projectId,
    @Query('userId') String userId,
    @Body() Estimate request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateEstimate)
  Future<SingleApiResponse<Estimate>> update(
    @Path('id') String id,
    @Query('userId') String userId,
    @Body() Estimate request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateEstimate)
  Future<SingleApiResponse<Estimate>> updateStatus(
    @Path('id') String id,
    @Query('userId') String userId,
    @Body() EstimateStatusRequest statusRequest,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteEstimate)
  Future<StatusApiResponse> delete(
    @Path('estimateId') String estimateId,
    @Query('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @POST(ApiEndpoint.convertEstimateToInvoice)
  Future<SingleApiResponse<Invoice>> convertToInvoice(
    @Path('userId') String userId,
    @Path('estimateId') String estimateId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @POST(ApiEndpoint.createProposalFromEstimate)
  Future<SingleApiResponse<Proposal>> convertToProposal(
    @Path('userId') String userId,
    @Path('estimateId') String estimateId,
    @CancelRequest() CancelToken? cancelToken,
  );
}
