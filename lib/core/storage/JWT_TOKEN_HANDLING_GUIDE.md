# JWT Token Handling Implementation Guide

## Overview

Complete JWT token lifecycle management for Flutter with:
- **In-memory access token** storage for quick access
- **Secure storage** for refresh tokens using `SecureStorageService`
- **401 interceptor** that automatically refreshes tokens
- **Automatic retry** of failed requests after token refresh
- **Proactive refresh** to prevent 401 errors

## Architecture

### 1. **TokenManager** (`core/storage/token_manager.dart`)
Manages token lifecycle:
- Stores access token in memory with expiration tracking
- Stores refresh token in secure storage
- Provides methods to check token expiration
- Handles token updates and clearing

Key methods:
```dart
String? getAccessToken()              // Get current access token
bool isAccessTokenExpired()           // Check if expired
bool isAccessTokenExpiringSoon()      // Check if expiring within 5 min
Future<void> setTokens({...})         // Set tokens after auth
Future<String?> getRefreshToken()     // Get refresh token from secure storage
Future<void> updateAccessToken({...}) // Update after refresh
Future<void> clearTokens()            // Clear all tokens
Future<bool> isAuthenticated()        // Check authentication status
```

### 2. **SecureStorageService** (`core/storage/secure_storage_service.dart`)
Abstract interface for secure storage:
- `InMemorySecureStorageService` for development/testing
- Can be replaced with `flutter_secure_storage` for production

### 3. **TokenRefreshManager** (`core/storage/token_refresh_manager.dart`)
Handles token refresh requests:
- Prevents concurrent refresh attempts
- Manages refresh state
- Supports proactive token refresh
- Tracks last refresh time

Key methods:
```dart
Future<String?> tryRefreshToken()           // Refresh with conflict prevention
Future<bool> shouldProactivelyRefreshToken() // Check if refresh needed
Future<String?> proactiveRefresh()          // Proactive refresh
bool isRefreshing()                         // Get refresh status
```

### 4. **AuthTokenRefreshService** (`core/storage/auth_token_refresh_service.dart`)
Implements `TokenRefreshService` interface:
- Calls backend `/auth/refresh-token` endpoint
- Extracts new access token from response
- Handles refresh errors

### 5. **Enhanced ApiClient** (`core/network/api_client.dart`)
Implements token injection and 401 handling:
- Injects `Authorization: Bearer <token>` header
- Detects 401 responses
- Triggers token refresh on 401
- **Automatically retries** failed request with new token
- Works for GET, POST, PUT, DELETE requests

## Integration Steps

### Step 1: Initialize TokenManager

```dart
// In your dependency injection setup (e.g., service locator)
final secureStorage = InMemorySecureStorageService();
final tokenManager = TokenManager(secureStorage: secureStorage);

// Load persisted tokens on app startup
await tokenManager.loadTokens();

// Register in service locator
sl.registerSingleton<TokenManager>(tokenManager);
```

### Step 2: Initialize ApiClient with TokenManager

```dart
final apiClient = ApiClient(
  baseUrl: 'https://your-api.com/api',
  tokenManager: tokenManager,
  onTokenRefresh: (refreshToken) async {
    // This callback is called when 401 is detected
    final refreshManager = sl<TokenRefreshManager>();
    return await refreshManager.tryRefreshToken();
  },
);

sl.registerSingleton<ApiClient>(apiClient);
```

### Step 3: Setup TokenRefreshManager

```dart
final refreshService = AuthTokenRefreshService(apiClient: apiClient);
final refreshManager = TokenRefreshManager(
  refreshService: refreshService,
  tokenManager: tokenManager,
);

sl.registerSingleton<TokenRefreshManager>(refreshManager);
```

### Step 4: Update AuthRepository

The `AuthRepositoryImpl` is already updated to use `TokenManager`:

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final TokenManager _tokenManager;

  // After OTP verification:
  await _tokenManager.setTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );
}
```

## Token Flow

### Authentication Flow
```
1. User enters phone → SendOtpEvent
2. User enters OTP → VerifyOtpEvent
3. Backend returns accessToken + refreshToken
4. TokenManager.setTokens() stores them:
   - accessToken → in-memory
   - refreshToken → secure storage
5. AuthBloc emits Authenticated state
```

### Request with Token
```
1. API call initiated
2. ApiClient injects Authorization header with accessToken
3. Request sent to backend
4. If response is 200/201: Return response
5. If response is 401: Trigger token refresh
```

### 401 Token Refresh Flow
```
1. ApiClient detects 401 response
2. Calls onTokenRefresh callback
3. TokenRefreshManager.tryRefreshToken():
   - Prevents concurrent refresh attempts
   - Gets refreshToken from secure storage
   - Calls AuthTokenRefreshService.refreshAccessToken()
   - Sends refreshToken to backend
   - Backend returns new accessToken
   - TokenManager.updateAccessToken() stores it
4. Returns new accessToken
5. ApiClient automatically retries original request with new token
6. If retry succeeds: Return response
7. If refresh fails: Throw UnauthorizedException
```

### Logout Flow
```
1. User initiates logout
2. LogoutEvent dispatched to AuthBloc
3. AuthBloc calls logoutUseCase
4. AuthRepository.logout():
   - Calls backend logout endpoint
   - TokenManager.clearTokens() clears all tokens
5. AuthBloc emits Unauthenticated state
6. App navigates to login
```

## Key Features

### 1. Automatic 401 Handling
```dart
// No special code needed - ApiClient handles it automatically
final response = await apiClient.get('/user/profile');
// If 401: token refresh + automatic retry, then return response
```

### 2. Token Expiration Tracking
```dart
// Access token has built-in expiration tracking
final isExpired = tokenManager.isAccessTokenExpired();
final expiringSoon = tokenManager.isAccessTokenExpiringSoon();

// Proactive refresh before expiration
await refreshManager.proactiveRefresh();
```

### 3. Concurrent Refresh Prevention
```dart
// Multiple simultaneous 401 responses won't trigger multiple refreshes
TokenRefreshManager._isRefreshing flag prevents this
```

### 4. Secure Storage
```dart
// Refresh token stays in secure storage
// Access token stays in fast in-memory storage
// Different storage strategies for different needs
```

## Configuration

### Token Expiration Duration
```dart
// Default: 1 hour
// Customize:
final tokenManager = TokenManager(
  secureStorage: secureStorage,
  accessTokenExpiration: Duration(minutes: 30),
);
```

### Request Timeout
```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenManager: tokenManager,
  timeout: Duration(seconds: 60), // Default: 30
);
```

### Refresh Endpoint
```dart
// Customize in AuthTokenRefreshService
static const String _refreshEndpoint = '/auth/refresh-token';
```

## Upgrade to Production Storage

Replace `InMemorySecureStorageService` with `flutter_secure_storage`:

```dart
// Add to pubspec.yaml:
// flutter_secure_storage: ^9.0.0

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductionSecureStorageService implements SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
```

## Error Handling

### Token Refresh Failures
```dart
// If refresh fails, TokenRefreshManager:
// 1. Clears all tokens
// 2. Throws exception
// 3. ApiClient propagates error

// Catch in UI:
catch (e) {
  if (e is UnauthorizedException) {
    // Navigate to login
  }
}
```

### Network Errors During Refresh
```dart
// TokenRefreshManager catches network exceptions
// Clears tokens to force re-authentication
// User must login again
```

## Testing

### Mock TokenManager
```dart
class MockTokenManager extends Mock implements TokenManager {}

// In tests:
when(mockTokenManager.getAccessToken()).thenReturn('test_token');
when(mockTokenManager.isAccessTokenExpired()).thenReturn(false);
```

### Mock ApiClient 401 Scenario
```dart
// Test token refresh on 401
when(mockApiClient.post(any, body: anyNamed('body')))
    .thenAnswer((_) async => throw UnauthorizedException('Unauthorized'));
```

## Files Created

1. `core/storage/secure_storage_service.dart` - Secure storage interface
2. `core/storage/token_manager.dart` - Token lifecycle manager
3. `core/storage/token_refresh_manager.dart` - Token refresh handler
4. `core/storage/auth_token_refresh_service.dart` - Backend refresh service
5. `core/storage/storage.dart` - Module exports

## Files Modified

1. `core/network/api_client.dart` - Added 401 handling and token injection
2. `features/auth/data/repositories/auth_repository_impl.dart` - Uses TokenManager

## Next Steps

1. Update your service locator setup to initialize all components
2. Add `flutter_secure_storage` package for production
3. Implement custom `SecureStorageService` for production
4. Test token refresh scenarios
5. Add logging to track token operations
6. Add retry limits to prevent infinite refresh loops
