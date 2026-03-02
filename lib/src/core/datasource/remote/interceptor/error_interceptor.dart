import 'package:dio/dio.dart';

import '../base/api_error.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.data is Map<String, dynamic>) {
      if ((err.response?.statusCode == 401)) {
        // await getIt<AuthCubit>().refreshToken();
      } else {
        final error = err.response?.data['message'];
        if (error != null) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ApiError.server(
                code: err.response?.statusCode,
                message: error,
              ),
              response: err.response,
            ),
          );
          return;
        }

        final errors = err.response?.data['errors'];
        if (errors is List && errors.isNotEmpty) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ApiError.server(
                code: err.response?.statusCode,
                message: errors.first?.toString() ?? "Unknown error",
              ),
              response: err.response,
            ),
          );
          return;
        }
      }
    } else {
      handler.next(err);
    }
  }
}
