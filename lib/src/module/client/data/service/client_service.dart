import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../domain/model/client.dart';

part 'client_service.g.dart';

@RestApi()
@injectable
abstract class ClientService {
  @factoryMethod
  factory ClientService(@Named('appDio') Dio dio) = _ClientService;

  @GET(ApiEndpoint.client)
  Future<SingleApiResponse<Client>> client(
    @Path('userId') String userId,
    @Path('clientId') String clientId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.clients)
  Future<PagingApiResponse<Client>> clients(
    @Path('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @POST(ApiEndpoint.createClient)
  Future<StatusApiResponse> create(
    @Path('userId') String userId,
    @Body() Client request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateClient)
  Future<StatusApiResponse> update(
    @Path('userId') String userId,
    @Path('clientId') String clientId,
    @Body() Client request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteClient)
  Future<StatusApiResponse> delete(
    @Path('userId') String userId,
    @Path('clientId') String clientId,
    @CancelRequest() CancelToken? cancelToken,
  );
}
