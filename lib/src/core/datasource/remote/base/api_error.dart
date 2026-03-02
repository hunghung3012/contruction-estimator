import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart'; 

@freezed
sealed class ApiError with _$ApiError implements Exception {
  const ApiError._();

  factory ApiError.base(int? code, String message) = _ApiErrorBase;
  factory ApiError.server({int? code, required String message}) = _Server;
  factory ApiError.network({int? code, required String message}) = _Network;
  factory ApiError.internal(String message) = _Internal;
  factory ApiError.cancelled() = _Cancelled;
  factory ApiError.unexpected() = _Unexpected;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  

  String get message {
    return maybeWhen(
      orElse: () => "Error unexpected",
      base: (code, message) => message,
      server: (code, message) => message,
      internal: (message) => message,
      network: (_, message) => message,
    );
  }

  String get title => maybeWhen(
        base: (code, message) => 'Error',
        network: (code, __) => code == HttpStatus.internalServerError
            ? "Error internal server"
            : "Error",
        orElse: () => "Error",
      );
}
