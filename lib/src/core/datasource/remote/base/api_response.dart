import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';

import 'api_error.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

abstract class GenericObject<T> {
  T Function(Map<String, dynamic>) fromJsonT;

  GenericObject(this.fromJsonT);

  T genericObject(dynamic data) {
    return fromJsonT(data);
  }
}

class ResponseWrapper<T> extends GenericObject<T> {
  late T response;

  ResponseWrapper(super.fromJsonT);

  factory ResponseWrapper.init({
    required T Function(Map<String, dynamic>) fromJsonT,
    required dynamic data,
  }) {
    final wrapper = ResponseWrapper<T>(fromJsonT);
    wrapper.response = wrapper.genericObject(data);
    return wrapper;
  }
}

@Freezed(genericArgumentFactories: true)
abstract class StatusApiResponse with _$StatusApiResponse {
  const factory StatusApiResponse(int statusCode, String message) = _StatusApiResponse;

  factory StatusApiResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusApiResponseFromJson(json);
}

@Freezed(genericArgumentFactories: true)
abstract class SingleApiResponse<T> with _$SingleApiResponse<T> {
  const factory SingleApiResponse(T data) = _SingleApiResponse;

  factory SingleApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$SingleApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
abstract class ListApiResponse<T> with _$ListApiResponse<T> {
  const factory ListApiResponse(List<T> data) = _ListApiResponse;

  factory ListApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ListApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponse with _$PaginationResponse {
  const factory PaginationResponse(bool hasNext, int? nextCursor) =
      _PaginationResponse;

  factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseFromJson(json);
}

@Freezed(genericArgumentFactories: true)
abstract class PagingApiResponse<T> with _$PagingApiResponse<T> {
  const factory PagingApiResponse({
    required List<T> items,
    required PaginationResponse pagination,
  }) = _PagingApiResponse;

  factory PagingApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final data = json['data'];

    return PagingApiResponse<T>(
      items: (data['items'] as List<dynamic>).map(fromJsonT).toList(),
      pagination: PaginationResponse.fromJson(data['pagination']),
    );
  }
}

extension FoldedSingleApiResponse<T extends Object>
    on Result<SingleApiResponse<T>, ApiError> {
  Result<T, ApiError> get folded =>
      fold((success) => Success(success.data), (failure) => Failure(failure));
}

extension FoldedListApiResponse<T extends Object>
    on Result<ListApiResponse<T>, ApiError> {
  Result<List<T>, ApiError> get folded =>
      fold((success) => Success(success.data), (failure) => Failure(failure));
}
