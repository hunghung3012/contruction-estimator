import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../domain/model/project.dart';
import '../../domain/model/project_status.dart';
import '../request/status_request.dart';

part 'project_service.g.dart';

@RestApi()
@injectable
abstract class ProjectApi {
  @factoryMethod
  factory ProjectApi(@Named('appDio') Dio dio) = _ProjectApi;

  @GET(ApiEndpoint.projects)
  Future<PagingApiResponse<Project>> projects(
    @Path('userId') String userId,
    @Query('projectStatus') String? status,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.projectStatuses)
  Future<ListApiResponse<ProjectStatus>> projectStatuses(
    @Path('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateProjectStatus)
  Future<StatusApiResponse> updateProjectStatus(
    @Path('projectId') String projectId,
    @Query('userId') String userId,
    @Body() ProjectStatusRequest status,
    @CancelRequest() CancelToken? cancelToken,
  );

  @POST(ApiEndpoint.createStatus)
  Future<ProjectStatus> createStatus(
    @Path('userId') String userId,
    @Body() StatusRequest status,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateStatus)
  Future<ProjectStatus> updateStatus(
    @Path('userId') String userId,
    @Path('statusId') String statusId,
    @Body() StatusRequest status,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteStatus)
  Future<ProjectStatus> deleteStatus(
    @Path('userId') String userId,
    @Path('statusId') String statusId,
    @CancelRequest() CancelToken? cancelToken,
  );
}
