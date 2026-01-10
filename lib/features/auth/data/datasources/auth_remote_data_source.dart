import '../../../../core/network/api_client.dart';
import '../../../../core/network/exceptions.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<SendOtpResponse> sendOtp({required String phoneNumber}) async {
    try {
      final response = await _apiClient.post(
        '/auth/send-otp',
        body: {'phoneNumber': phoneNumber},
        requiresAuth: false,
      );

      return SendOtpResponse.fromJson(response);
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Failed to send OTP: $e',
        originalError: e,
      );
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-otp',
        body: {
          'phoneNumber': phoneNumber,
          'otp': otp,
        },
        requiresAuth: false,
      );

      final result = VerifyOtpResponse.fromJson(response);
      
      // Note: Token storage is handled by tokenManager via interceptors
      // _apiClient.setTokens(
      //   accessToken: result.accessToken,
      //   refreshToken: result.refreshToken,
      // );

      return result;
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Failed to verify OTP: $e',
        originalError: e,
      );
    }
  }

  Future<RefreshTokenResponse> refreshToken({required String refreshToken}) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh-token',
        body: {'refreshToken': refreshToken},
        requiresAuth: false,
      );

      final result = RefreshTokenResponse.fromJson(response);
      
      // Note: Token storage is handled by tokenManager via interceptors
      // _apiClient.setTokens(
      //   accessToken: result.accessToken,
      //   refreshToken: result.refreshToken,
      // );

      return result;
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Failed to refresh token: $e',
        originalError: e,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(
        '/auth/logout',
        body: {},
        requiresAuth: true,
      );
      
      // Note: Token clearing is handled by tokenManager
      // _apiClient.clearTokens();
    } on UnauthorizedException {
      // Clear tokens on unauthorized error  
      // _apiClient.clearTokens();
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Failed to logout: $e',
        originalError: e,
      );
    }
  }
}

// Response Models
class SendOtpResponse {
  final bool success;
  final String message;
  final int expiresIn;

  SendOtpResponse({
    required this.success,
    required this.message,
    required this.expiresIn,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'OTP sent successfully',
      expiresIn: json['expiresIn'] ?? 600,
    );
  }
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserData user;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'OTP verified successfully',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserData.fromJson(json['user'] ?? {}),
    );
  }
}

class RefreshTokenResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Token refreshed successfully',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}

class UserData {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final bool? isOnboardingComplete;

  UserData({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.isOnboardingComplete,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      isOnboardingComplete: json['isOnboardingComplete'],
    );
  }
}
