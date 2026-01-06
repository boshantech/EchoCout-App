import 'package:dio/dio.dart';
import 'token_manager.dart';
import 'api_endpoints.dart';

class DioClient {
  late Dio _dio;
  final TokenManager _tokenManager = TokenManager();
  
  static const String baseUrl = 'https://api.wice.app/v1';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  DioClient() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: connectionTimeout),
        receiveTimeout: const Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => true,
      ),
    );

    // Add token injection & 401 handling interceptor
    _dio.interceptors.add(
      _TokenInterceptor(_tokenManager, _dio),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

class _TokenInterceptor extends InterceptorsWrapper {
  final TokenManager _tokenManager;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  _TokenInterceptor(this._tokenManager, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inject access token if available
    final accessToken = await _tokenManager.getAccessToken();
    
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized
    if (error.response?.statusCode == 401) {
      return _handle401(error, handler);
    }

    return handler.next(error);
  }

  Future<void> _handle401(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = error.requestOptions;

    // If already refreshing, queue this request
    if (_isRefreshing) {
      _pendingRequests.add(_PendingRequest(handler, requestOptions));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        _isRefreshing = false;
        return handler.next(error);
      }

      // Attempt token refresh
      final refreshResponse = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (refreshResponse.statusCode == 200 || refreshResponse.statusCode == 201) {
        final newAccessToken = refreshResponse.data['access_token'];
        final newRefreshToken = refreshResponse.data['refresh_token'];

        if (newAccessToken != null) {
          // Update tokens
          await _tokenManager.updateAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _tokenManager.saveRefreshToken(newRefreshToken);
          }

          // Retry original request with new token
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          
          final retryResponse = await _dio.request<dynamic>(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
              validateStatus: (status) => true,
            ),
          );

          _isRefreshing = false;
          _retryPendingRequests();

          return handler.resolve(retryResponse);
        }
      }

      // Token refresh failed - clear tokens and propagate error
      await _tokenManager.clearTokens();
      _isRefreshing = false;
      _failPendingRequests(error);

      return handler.next(error);
    } catch (e) {
      // Token refresh error - clear tokens and propagate
      await _tokenManager.clearTokens();
      _isRefreshing = false;
      _failPendingRequests(error);

      return handler.next(error);
    }
  }

  void _retryPendingRequests() {
    for (final request in _pendingRequests) {
      // Retry the pending request
      _dio.request<dynamic>(
        request.requestOptions.path,
        data: request.requestOptions.data,
        queryParameters: request.requestOptions.queryParameters,
        options: Options(
          method: request.requestOptions.method,
          headers: request.requestOptions.headers,
        ),
      ).then(
        (response) => request.handler.resolve(response),
        onError: (error) => request.handler.next(error as DioException),
      );
    }
    _pendingRequests.clear();
  }

  void _failPendingRequests(DioException error) {
    for (final request in _pendingRequests) {
      request.handler.next(error);
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  final ErrorInterceptorHandler handler;
  final RequestOptions requestOptions;

  _PendingRequest(this.handler, this.requestOptions);
}
