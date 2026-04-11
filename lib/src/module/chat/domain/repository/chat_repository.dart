import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../data/request/chat_request.dart';
import '../../data/response/chat_response.dart';
import '../../data/service/chat_service.dart';

@injectable
class ChatRepository {
  final ChatApi _api;

  ChatRepository(this._api);

  Future<Result<ChatResponse, ApiError>> sendMessage(
    ChatRequest data, {
    CancelToken? token,
  }) async {
    final request = data.copyWith(userId: AppStorage.userId);
    var result = _api.chat(request, token);
    return result.tryGet((response) => response.data);
  }
}
