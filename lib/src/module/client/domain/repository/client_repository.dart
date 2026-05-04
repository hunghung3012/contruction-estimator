import 'package:construction_estimator/src/core/datasource/remote/base/api_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../data/service/client_service.dart';
import '../model/client.dart';

@injectable
class ClientRepository {
  final ClientService _api;

  ClientRepository(this._api);

  Future<Result<Client, ApiError>> client(
    String clientId, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.client(userId ?? '', clientId, token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<PagingApiResponse<Client>, ApiError>> clients({
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.clients(userId ?? '', token);
    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> create(
    Client request, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.create(userId ?? '', request, token);
    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> update(
    Client request, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.update(userId ?? '', request.id ?? '', request, token);
    return result.tryGet((response) => response);
  }

  Future<Result<StatusApiResponse, ApiError>> delete(
    String clientId, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.delete(userId ?? '', clientId, token);
    return result.tryGet((response) => response);
  }
}
