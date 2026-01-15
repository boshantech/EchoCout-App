abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ServerException extends AppException {
  final int? statusCode;
  ServerException(super.message, {this.statusCode});
}

class AuthenticationException extends AppException {
  AuthenticationException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}
