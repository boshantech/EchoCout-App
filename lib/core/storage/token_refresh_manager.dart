import 'token_manager.dart';

/// Handles token refresh requests to the backend
/// This service is responsible for communicating with the refresh endpoint
abstract class TokenRefreshService {
  /// Refresh the access token using refresh token
  /// Returns the new access token if successful
  Future<String> refreshAccessToken(String refreshToken);
}

/// Manages token refresh lifecycle and caching
class TokenRefreshManager {
  final TokenRefreshService _refreshService;
  final TokenManager _tokenManager;

  bool _isRefreshing = false;
  DateTime? _lastRefreshTime;

  TokenRefreshManager({
    required TokenRefreshService refreshService,
    required TokenManager tokenManager,
  })  : _refreshService = refreshService,
        _tokenManager = tokenManager;

  /// Attempt to refresh the access token
  /// Handles concurrent refresh requests to prevent multiple simultaneous calls
  Future<String?> tryRefreshToken() async {
    // Get the stored refresh token
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }

    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      // Wait a bit and retry
      await Future.delayed(const Duration(milliseconds: 100));
      return _tokenManager.getAccessToken();
    }

    _isRefreshing = true;
    try {
      // Call the refresh endpoint
      final newAccessToken = await _refreshService.refreshAccessToken(refreshToken);
      
      // Update the token manager with new token
      await _tokenManager.updateAccessToken(accessToken: newAccessToken);
      
      _lastRefreshTime = DateTime.now();
      return newAccessToken;
    } catch (e) {
      // Refresh failed - clear tokens and return null
      await _tokenManager.clearTokens();
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Check if token should be proactively refreshed
  /// This prevents 401 errors by refreshing before expiration
  Future<bool> shouldProactivelyRefreshToken() async {
    return _tokenManager.isAccessTokenExpiringSoon();
  }

  /// Proactively refresh token if it's expiring soon
  Future<String?> proactiveRefresh() async {
    if (await shouldProactivelyRefreshToken()) {
      return tryRefreshToken();
    }
    return null;
  }

  /// Get the time of last successful token refresh
  DateTime? getLastRefreshTime() => _lastRefreshTime;

  /// Get refresh attempt status
  bool isRefreshing() => _isRefreshing;
}
