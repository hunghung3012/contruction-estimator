import 'package:construction_estimator/src/core/datasource/remote/base/api_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../../core/datasource/remote/base/api_error.dart';
import '../../../../core/datasource/remote/module/api_module.dart';
import '../../data/request/status_request.dart';
import '../../data/service/project_service.dart';
import '../model/project.dart';
import '../model/project_status.dart';

@injectable
class ProjectRepository {
  final ProjectApi _api;

  ProjectRepository(this._api);

  Future<Result<PagingApiResponse<Project>, ApiError>> projects(
    String? status, {
    int? nextCursor,
    CancelToken? token,
  }) async {
    final result = _api.projects(
      AppStorage.userId ?? '',
      status,
      nextCursor,
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<List<ProjectStatus>, ApiError>> projectStatuses({
    CancelToken? token,
  }) async {
    final result = _api.projectStatuses(AppStorage.userId ?? '', token);
    return result.tryGet((response) => response.data);
  }

  Future<Result<StatusApiResponse, ApiError>> updateProjectStatus({
    required String projectId,
    required ProjectStatus status,
    CancelToken? token,
  }) async {
    final result = _api.updateProjectStatus(
      projectId,
      AppStorage.userId ?? '',
      status.toRequest(),
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<ProjectStatus, ApiError>> createStatus({
    required String name,
    CancelToken? token,
  }) async {
    final result = _api.createStatus(
      AppStorage.userId ?? '',
      StatusRequest(name: name),
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<ProjectStatus, ApiError>> updateStatus({
    required String statusId,
    required String name,
    CancelToken? token,
  }) async {
    final result = _api.updateStatus(
      AppStorage.userId ?? '',
      statusId,
      StatusRequest(name: name),
      token,
    );
    return result.tryGet((response) => response);
  }

  Future<Result<ProjectStatus, ApiError>> deleteStatus({
    required String statusId,
    CancelToken? token,
  }) async {
    final result = _api.deleteStatus(AppStorage.userId ?? '', statusId, token);
    return result.tryGet((response) => response);
  }
}
