import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../domain/model/change_order.dart';
import '../request/change_order_request.dart';
import '../request/change_order_status_request.dart';

part 'change_order_api.g.dart';

@RestApi()
@injectable
abstract class ChangeOrderService {
  @factoryMethod
  factory ChangeOrderService(@Named('appDio') Dio dio) = _ChangeOrderService;

  @POST(ApiEndpoint.createChangeOrder)
  Future<SingleApiResponse<ChangeOrder>> create(
    @Path('userId') String userId,
    @Body() ChangeOrderRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateChangeOrder)
  Future<SingleApiResponse<ChangeOrder>> update(
    @Path('changeOrderId') String changeOrderId,
    @Query('userId') String userId,
    @Body() ChangeOrder request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateChangeOrder)
  Future<SingleApiResponse<ChangeOrder>> updateStatus(
    @Path('changeOrderId') String changeOrderId,
    @Query('userId') String userId,
    @Body() ChangeOrderStatusRequest statusRequest,
    @CancelRequest() CancelToken? cancelToken,
  );

 
  @DELETE(ApiEndpoint.deleteChangeOrder)
  Future<StatusApiResponse> delete(
    @Path('changeOrderId') String changeOrderId,
    @Query('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

}
