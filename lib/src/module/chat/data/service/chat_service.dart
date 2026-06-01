import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../common/constants/api_endpoint.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../request/chat_request.dart';
import '../response/chat_response.dart';

part 'chat_service.g.dart';

@RestApi()
@injectable
abstract class ChatApi {
  @factoryMethod
  factory ChatApi(@Named('appDio') Dio dio) = _ChatApi;

  @POST(ApiEndpoint.chat)
  Future<SingleApiResponse<ChatResponse>> chat(
    @Body() ChatRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET(ApiEndpoint.chatHistory)
  Future<PagingApiResponse<ChatResponse>> chatHistory(
    @Path('projectId') String projectId,
    @Path('userId') String userId,
    @Query('cursor') String? cursor,
    @CancelRequest() CancelToken? cancelToken,
  );
}
