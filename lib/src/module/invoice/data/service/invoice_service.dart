import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../domain/model/invoice.dart';

part 'invoice_service.g.dart';

@RestApi()
@injectable
abstract class InvoiceApi {
  @factoryMethod
  factory InvoiceApi(@Named('appDio') Dio dio) = _InvoiceApi;

  @POST(ApiEndpoint.createInvoice)
  Future<StatusApiResponse> createInvoice(
    @Path('userId') String userId,
    @Body() Invoice? body,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.invoices)
  Future<PagingApiResponse<Invoice>> getInvoices(
    @Path('userId') String userId,
    @Query('projectId') String? projectId,
    @Query('cursor') int? nextCursor,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteInvoice)
  Future<StatusApiResponse> deleteInvoice(
    @Path('invoiceId') String invoiceId,
    @Query('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @DELETE(ApiEndpoint.deleteAllInvoices)
  Future<StatusApiResponse> deleteAllInvoices(
    @Path('userId') String userId,
    @CancelRequest() CancelToken? cancelToken,
  );

  @PATCH(ApiEndpoint.updateInvoice)
  Future<StatusApiResponse> updateInvoice(
    @Path('invoiceId') String invoiceId,
    @Query('userId') String userId,
    @Body() Invoice? invoice,
    @CancelRequest() CancelToken? cancelToken,
  );
}
