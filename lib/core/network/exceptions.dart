class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ServerException extends ApiException {
  ServerException({
    required String message,
    required int statusCode,
    dynamic originalError,
  }) : super(
    message: message,
    statusCode: statusCode,
    originalError: originalError,
  );
}

class ClientException extends ApiException {
  ClientException({
    required String message,
    dynamic originalError,
  }) : super(
    message: message,
    originalError: originalError,
  );
}

class NetworkException extends ApiException {
  NetworkException({
    required String message,
    dynamic originalError,
  }) : super(
    message: message,
    originalError: originalError,
  );
}

class TimeoutException extends ApiException {
  TimeoutException({
    required String message,
  }) : super(message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    required String message,
    dynamic originalError,
  }) : super(
    message: message,
    originalError: originalError,
  );
}
