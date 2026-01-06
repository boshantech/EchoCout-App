import '../network/api_client.dart';
import 'token_refresh_manager.dart';

/// Implements token refresh by calling the backend API
class AuthTokenRefreshService implements TokenRefreshService {
  final ApiClient _apiClient;
  static const String _refreshEndpoint = '/auth/refresh-token';

  AuthTokenRefreshService({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<String> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        _refreshEndpoint,
        body: {'refreshToken': refreshToken},
        requiresAuth: false, // Don't include bearer token for refresh endpoint
      );

      // Extract access token from response
      // Adjust based on your actual API response structure
      if (response is Map<String, dynamic> && response.containsKey('accessToken')) {
        return response['accessToken'] as String;
      }

      throw Exception('Invalid refresh token response');
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }
}
