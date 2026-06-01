import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../../estimate/domain/model/estimate.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import '../../../change_order/domain/model/change_order.dart';

part 'project_detail_service.g.dart';

@RestApi()
@injectable
abstract class ProjectDetailApi {
  @factoryMethod
  factory ProjectDetailApi(@Named('appDio') Dio dio) = _ProjectDetailApi;

  @GET(ApiEndpoint.estimatesFromProject)
  Future<PagingApiResponse<Estimate>> estimates(
    @Path('projectId') String projectId,
    @Query('userId') String? userId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  

  @GET(ApiEndpoint.proposals)
  Future<PagingApiResponse<Proposal>> proposals(
    @Path('userId') String userId,
    @Query('projectId') String projectId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.changeOrders)
  Future<PagingApiResponse<ChangeOrder>> changeOrders(
    @Path('userId') String userId,
    @Query('proposalId') String? proposalId,
    @Query('projectId') String projectId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.invoices)
  Future<PagingApiResponse<Invoice>> invoices(
    @Path('userId') String userId,
    @Query('projectId') String projectId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );


}
