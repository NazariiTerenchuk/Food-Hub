import 'package:dio/dio.dart';

/// Typed exceptions for all network failures in FoodHub.
sealed class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  /// Maps a [DioException] to the appropriate [NetworkException] subtype.
  factory NetworkException.fromDioException(DioException e) =>
      switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const TimeoutException(),
        DioExceptionType.connectionError => const NoInternetException(),
        DioExceptionType.badResponse => ServerException(
            statusCode: e.response?.statusCode ?? 0,
            message: e.response?.statusMessage ?? 'Server error',
          ),
        _ => const UnknownException(),
      };

  @override
  String toString() => message;
}

final class ServerException extends NetworkException {
  final int statusCode;
  const ServerException({required this.statusCode, required String message})
      : super(message);
}

final class NoInternetException extends NetworkException {
  const NoInternetException()
      : super('No internet connection. Check your network.');
}

final class TimeoutException extends NetworkException {
  const TimeoutException()
      : super('Connection timed out. Please try again.');
}

final class UnknownException extends NetworkException {
  const UnknownException() : super('An unexpected error occurred.');
}
