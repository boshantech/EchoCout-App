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
    required super.message,
    required int super.statusCode,
    super.originalError,
  });
}

class ClientException extends ApiException {
  ClientException({
    required super.message,
    super.originalError,
  });
}

class NetworkException extends ApiException {
  NetworkException({
    required super.message,
    super.originalError,
  });
}

class TimeoutException extends ApiException {
  TimeoutException({
    required super.message,
  });
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    required super.message,
    super.originalError,
  });
}
