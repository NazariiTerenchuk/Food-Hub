import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'network_exceptions.dart';

/// Configured Dio HTTP client for TheMealDB API.
///
/// All requests share the same [BaseOptions] (timeout, base URL).
/// In debug mode a [LogInterceptor] is added automatically.
final class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor());
    }
  }

  /// Performs a GET request to [path] with optional [queryParameters].
  /// Returns the decoded JSON body as [Map<String, dynamic>].
  /// Throws [NetworkException] on any network or server error.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
