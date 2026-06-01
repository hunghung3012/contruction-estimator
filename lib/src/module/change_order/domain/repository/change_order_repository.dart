import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/base/api_response.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../data/request/change_order_request.dart';
import '../../data/service/change_order_api.dart';
import '../model/change_order.dart';

@injectable
class ChangeOrderRepository {
  final ChangeOrderService _api;

  ChangeOrderRepository(this._api);

  Future<Result<ChangeOrder, ApiError>> create(
    ChangeOrderRequest request, {
    CancelToken? token,
  }) async {
    var result = _api.create(AppStorage.userId ?? '', request, token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<ChangeOrder, ApiError>> update(
    String id,
    ChangeOrder request, {
    CancelToken? token,
  }) async {
    final userId = AppStorage.userId;
    var result = _api.update(id, userId ?? '', request, token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<StatusApiResponse, ApiError>> delete(
    String id, {
    CancelToken? token,
  }) async {
    var result = _api.delete(id, AppStorage.userId ?? '', token);
    return result.tryGet((data) => data);
  }
}
