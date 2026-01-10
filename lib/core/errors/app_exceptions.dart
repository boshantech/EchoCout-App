abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  final int? statusCode;
  ServerException(String message, {this.statusCode}) : super(message);
}

class AuthenticationException extends AppException {
  AuthenticationException(String message) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
