import '../../../../core/network/exceptions.dart';
import '../../../../core/storage/token_manager.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final TokenManager _tokenManager;

  AuthRepositoryImpl({
    required AuthApiService authApiService,
    required TokenManager tokenManager,
  })  : _authApiService = authApiService,
        _tokenManager = tokenManager;

  @override
  Future<void> sendOtp({required String phoneNumber}) async {
    try {
      final response = await _authApiService.sendOtp(phoneNumber: phoneNumber);
      
      if (!response.success) {
        throw ApiException(message: response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _authApiService.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otpCode,
      );

      if (response.success) {
        // Store tokens in TokenManager
        await _tokenManager.setTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        return {
          'success': true,
          'accessToken': response.accessToken,
          'refreshToken': response.refreshToken,
          'user': {
            'id': response.user.id,
            'phoneNumber': response.user.phoneNumber,
            'name': response.user.name,
            'email': response.user.email,
            'isOnboardingComplete': response.user.isOnboardingComplete,
          },
        };
      } else {
        throw ApiException(message: response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> refreshAccessToken({required String refreshToken}) async {
    try {
      final response = await _authApiService.refreshToken(
        refreshToken: refreshToken,
      );

      if (response.success) {
        // Update tokens in TokenManager
        await _tokenManager.updateAccessToken(accessToken: response.accessToken);
      } else {
        throw ApiException(message: 'Failed to refresh token');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authApiService.logout();
    } finally {
      await _tokenManager.clearTokens();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _tokenManager.isAuthenticated();
  }

  @override
  Future<String?> getAccessToken() async {
    return _tokenManager.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _tokenManager.getRefreshToken();
  }
}
