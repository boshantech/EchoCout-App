import '../storage/token_manager.dart';

class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final TokenManager tokenManager;
  final Future<String?> Function()? onTokenRefresh;

  ApiClient({
    required this.baseUrl,
    required this.tokenManager,
    this.onTokenRefresh,
    this.timeout = const Duration(seconds: 30),
  });

  Future<dynamic> get(
    String endpoint, {
    bool requiresAuth = true,
    Map<String, dynamic>? queryParams,
  }) async {
    throw UnimplementedError('Use DioClient for HTTP requests');
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError('Use DioClient for HTTP requests');
  }

  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError('Use DioClient for HTTP requests');
  }

  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError('Use DioClient for HTTP requests');
  }
}
