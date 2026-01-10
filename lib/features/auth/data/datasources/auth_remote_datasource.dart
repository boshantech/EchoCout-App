import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/exceptions.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponse> sendOtp(SendOtpRequest request);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request);
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);
  Future<LogoutResponse> logout(LogoutRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<SendOtpResponse> sendOtp(SendOtpRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.sendOtp,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to send OTP',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ClientException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerifyOtpResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to verify OTP',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ClientException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  @override
  Future<RefreshTokenResponse> refreshToken(
      RefreshTokenRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RefreshTokenResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to refresh token',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ClientException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  @override
  Future<LogoutResponse> logout(LogoutRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.logout,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LogoutResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to logout',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ClientException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Request timeout');
      
      case DioExceptionType.badResponse:
        return ServerException(
          message: error.response?.data['message'] ?? 'Server error',
          statusCode: error.response?.statusCode ?? 500,
          originalError: error,
        );
      
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection error',
          originalError: error,
        );
      
      case DioExceptionType.cancel:
        return ClientException(
          message: 'Request cancelled',
          originalError: error,
        );
      
      case DioExceptionType.unknown:
        return ClientException(
          message: error.message ?? 'Unknown error occurred',
          originalError: error,
        );
      
      default:
        return ClientException(
          message: 'An error occurred',
          originalError: error,
        );
    }
  }
}
