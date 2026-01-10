import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _refreshTokenKey = 'wice_refresh_token';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // In-memory storage for access token (faster access)
  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  /// Save access token to memory (fast access)
  Future<void> saveAccessToken(String token) async {
    _cachedAccessToken = token;
  }

  /// Save refresh token to secure storage
  Future<void> saveRefreshToken(String token) async {
    _cachedRefreshToken = token;
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Save both tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Get access token from memory
  Future<String?> getAccessToken() async {
    return _cachedAccessToken;
  }

  /// Get refresh token from secure storage
  Future<String?> getRefreshToken() async {
    _cachedRefreshToken ??= await _secureStorage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  /// Get both tokens
  Future<Map<String, String?>> getTokens() async {
    return {
      'access': _cachedAccessToken,
      'refresh': await getRefreshToken(),
    };
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// Check if tokens exist
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return (accessToken != null && accessToken.isNotEmpty) &&
        (refreshToken != null && refreshToken.isNotEmpty);
  }

  /// Update access token (after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    _cachedAccessToken = newAccessToken;
  }

  /// Load refresh token from secure storage into cache
  Future<void> initializeTokens() async {
    _cachedRefreshToken = await _secureStorage.read(key: _refreshTokenKey);
  }
}
