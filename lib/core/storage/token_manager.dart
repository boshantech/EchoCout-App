import 'secure_storage_service.dart';

/// Manages JWT token lifecycle
/// - Stores access token in memory for quick access
/// - Stores refresh token in secure storage
/// - Handles token expiration and refresh
class TokenManager {
  final SecureStorageService _secureStorage;
  final Duration _accessTokenExpiration;

  // In-memory access token storage
  String? _accessToken;
  DateTime? _accessTokenExpiresAt;

  // Storage keys
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenKey = 'access_token';
  static const String _expiresAtKey = 'token_expires_at';

  TokenManager({
    required SecureStorageService secureStorage,
    Duration accessTokenExpiration = const Duration(hours: 1),
  })  : _secureStorage = secureStorage,
        _accessTokenExpiration = accessTokenExpiration;

  /// Get current access token
  String? getAccessToken() => _accessToken;

  /// Check if access token is expired
  bool isAccessTokenExpired() {
    if (_accessTokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_accessTokenExpiresAt!);
  }

  /// Check if access token will expire soon (within 5 minutes)
  bool isAccessTokenExpiringSoon() {
    if (_accessTokenExpiresAt == null) return true;
    final soon = DateTime.now().add(const Duration(minutes: 5));
    return soon.isAfter(_accessTokenExpiresAt!);
  }

  /// Set tokens from authentication response
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    _accessToken = accessToken;
    _accessTokenExpiresAt = expiresAt ?? DateTime.now().add(_accessTokenExpiration);

    if (refreshToken != null) {
      await _secureStorage.write(_refreshTokenKey, refreshToken);
    }
  }

  /// Load tokens from storage (on app restart)
  Future<void> loadTokens() async {
    _accessToken = await _secureStorage.read(_accessTokenKey);
    final expiresAtStr = await _secureStorage.read(_expiresAtKey);
    
    if (expiresAtStr != null) {
      try {
        _accessTokenExpiresAt = DateTime.parse(expiresAtStr);
      } catch (e) {
        _accessTokenExpiresAt = null;
      }
    }
  }

  /// Get refresh token from secure storage
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(_refreshTokenKey);
  }

  /// Update access token after refresh
  Future<void> updateAccessToken({
    required String accessToken,
    DateTime? expiresAt,
  }) async {
    _accessToken = accessToken;
    _accessTokenExpiresAt = expiresAt ?? DateTime.now().add(_accessTokenExpiration);
    
    // Persist access token and expiry
    await _secureStorage.write(_accessTokenKey, accessToken);
    await _secureStorage.write(_expiresAtKey, _accessTokenExpiresAt!.toIso8601String());
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    _accessToken = null;
    _accessTokenExpiresAt = null;
    await _secureStorage.delete(_refreshTokenKey);
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_expiresAtKey);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final hasAccessToken = _accessToken != null && !isAccessTokenExpired();
    if (hasAccessToken) return true;

    // Try to refresh using stored refresh token
    final refreshToken = await getRefreshToken();
    return refreshToken != null;
  }
}
