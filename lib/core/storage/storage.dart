/// Token management module
/// 
/// Provides complete JWT token lifecycle management:
/// - In-memory access token storage with expiration tracking
/// - Secure storage for refresh tokens (using SecureStorageService)
/// - Automatic token refresh on 401 responses
/// - Retry failed requests after token refresh
/// - Proactive token refresh before expiration
/// 
/// Usage:
/// ```dart
/// // Initialize
/// final secureStorage = InMemorySecureStorageService();
/// final tokenManager = TokenManager(secureStorage: secureStorage);
/// final refreshService = AuthTokenRefreshService(apiClient: apiClient);
/// final refreshManager = TokenRefreshManager(
///   refreshService: refreshService,
///   tokenManager: tokenManager,
/// );
/// 
/// // Set tokens after authentication
/// await tokenManager.setTokens(
///   accessToken: 'access_token_value',
///   refreshToken: 'refresh_token_value',
/// );
/// 
/// // ApiClient will handle 401s automatically and retry
/// ```

export 'secure_storage_service.dart';
export 'token_manager.dart';
export 'token_refresh_manager.dart';
export 'auth_token_refresh_service.dart';
