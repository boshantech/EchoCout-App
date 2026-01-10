# JWT Token Handling - Quick Reference

## Core Classes

### TokenManager
```dart
class TokenManager {
  // Get access token (in-memory, fast)
  String? getAccessToken()
  
  // Check expiration
  bool isAccessTokenExpired()
  bool isAccessTokenExpiringSoon() // 5 min window
  
  // Set tokens after login
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  })
  
  // Get refresh token (from secure storage)
  Future<String?> getRefreshToken()
  
  // Update after refresh
  Future<void> updateAccessToken({
    required String accessToken,
    DateTime? expiresAt,
  })
  
  // Clear all tokens on logout
  Future<void> clearTokens()
  
  // Check authentication status
  Future<bool> isAuthenticated()
  
  // Load persisted tokens on app restart
  Future<void> loadTokens()
}
```

### ApiClient (Enhanced)
```dart
class ApiClient {
  // Constructor
  ApiClient({
    required String baseUrl,
    required TokenManager tokenManager,
    Future<String?> Function()? onTokenRefresh,
    Duration timeout = const Duration(seconds: 30),
  })
  
  // HTTP methods - all handle 401 automatically
  Future<dynamic> get(String endpoint, {
    bool requiresAuth = true,
    Map<String, dynamic>? queryParams,
  })
  
  Future<dynamic> post(String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  })
  
  Future<dynamic> put(String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  })
  
  Future<dynamic> delete(String endpoint, {
    bool requiresAuth = true,
  })
}
```

### TokenRefreshManager
```dart
class TokenRefreshManager {
  // Refresh token with concurrency control
  Future<String?> tryRefreshToken()
  
  // Check if should refresh proactively
  Future<bool> shouldProactivelyRefreshToken()
  
  // Proactively refresh if expiring soon
  Future<String?> proactiveRefresh()
  
  // Get refresh status
  bool isRefreshing()
  
  // Get last refresh time
  DateTime? getLastRefreshTime()
}
```

---

## Typical Setup

```dart
// 1. Create secure storage
final secureStorage = InMemorySecureStorageService();

// 2. Create token manager
final tokenManager = TokenManager(secureStorage: secureStorage);
await tokenManager.loadTokens();

// 3. Create API client
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenManager: tokenManager,
);

// 4. Create refresh service
final refreshService = AuthTokenRefreshService(apiClient: apiClient);

// 5. Create refresh manager
final refreshManager = TokenRefreshManager(
  refreshService: refreshService,
  tokenManager: tokenManager,
);

// 6. Setup token refresh callback
apiClient.onTokenRefresh = refreshManager.tryRefreshToken;
```

---

## Login Flow

```dart
// 1. User provides phone + OTP
// 2. Backend returns:
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "refresh_token_value..."
}

// 3. Store tokens
await tokenManager.setTokens(
  accessToken: response['accessToken'],
  refreshToken: response['refreshToken'],
);

// Done! All future requests use these tokens automatically
```

---

## API Request (Automatic)

```dart
// Simple request - token handling is transparent
final response = await apiClient.get('/user/profile');

// What happens automatically:
// 1. Get access token from tokenManager
// 2. Add "Authorization: Bearer <token>" header
// 3. Send request
// 4. If 401:
//    a. Call onTokenRefresh callback
//    b. TokenRefreshManager.tryRefreshToken()
//    c. Get refreshToken from secure storage
//    d. Call /auth/refresh-token endpoint
//    e. Update access token
//    f. Retry original request
// 5. Return response
```

---

## Logout Flow

```dart
// 1. Trigger logout
await logoutUseCase.call(NoParams());

// 2. In AuthRepository.logout():
await _authApiService.logout(); // Call backend
await _tokenManager.clearTokens(); // Clear all tokens

// 3. Navigate to login
// Done! Access token is cleared, refresh token deleted
```

---

## Token Expiration Scenarios

### Scenario 1: Access Token Expires During Use
```
Time: 0s - User makes request with valid token ✓
Time: 3600s - Token expires (1 hour default)
Time: 3601s - User makes request → 401
→ Automatic refresh → Retry → Success
```

### Scenario 2: Proactive Refresh
```
Time: 3580s - Access token expiring in 20 seconds
→ App detects with isAccessTokenExpiringSoon()
→ Proactively call refreshManager.proactiveRefresh()
→ Token refreshed before user notices
```

### Scenario 3: Refresh Token Expires
```
Access token expired → Try to refresh
→ Send refreshToken to /auth/refresh-token
→ Server: "Refresh token expired"
→ TokenManager clears all tokens
→ User must login again
```

---

## Error Handling

```dart
try {
  final response = await apiClient.get('/data');
} on UnauthorizedException {
  // Token refresh failed - need to re-login
  // Navigate to login screen
} on NetworkException {
  // Network error - user offline
  // Show offline message
} on ServerException {
  // Server error (5xx)
  // Show error message
} on ApiException catch (e) {
  // Other API errors
  print(e.message);
}
```

---

## Configuration

### Access Token Duration
```dart
final tokenManager = TokenManager(
  secureStorage: storage,
  accessTokenExpiration: Duration(minutes: 30), // Default: 1 hour
);
```

### Request Timeout
```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenManager: tokenManager,
  timeout: Duration(seconds: 60), // Default: 30s
);
```

### Refresh Endpoint
```dart
// In AuthTokenRefreshService:
static const String _refreshEndpoint = '/auth/refresh-token';
```

---

## Testing

### Mock TokenManager
```dart
final mockTokenManager = MockTokenManager();
when(mockTokenManager.getAccessToken())
    .thenReturn('test_token');
when(mockTokenManager.isAccessTokenExpired())
    .thenReturn(false);
```

### Test 401 Handling
```dart
test('should refresh token on 401', () async {
  // Mock API to return 401
  when(mockHttpClient.get(any))
      .thenAnswer((_) async => http.Response('Unauthorized', 401));
  
  // Call API
  await apiClient.get('/test');
  
  // Verify refresh was called
  verify(mockRefreshManager.tryRefreshToken()).called(1);
  
  // Verify retry was called
  verify(mockHttpClient.get(any)).called(2); // Initial + retry
});
```

---

## Common Issues & Solutions

### Issue: 401 Loop
**Problem:** Token keeps failing to refresh
**Solution:** Check refresh endpoint URL and request format

### Issue: Tokens Lost on App Restart
**Problem:** Access token lost (expected), refresh token lost (problem)
**Solution:** Ensure `SecureStorageService` is persisting refresh token

### Issue: Multiple Concurrent Refreshes
**Problem:** Multiple 401 responses trigger multiple refreshes
**Solution:** `TokenRefreshManager._isRefreshing` prevents this - it's handled automatically

### Issue: Token Refresh Takes Too Long
**Problem:** User sees brief error before retry succeeds
**Solution:** Increase request timeout or implement request queueing

---

## Migration from SharedPreferences

### Before (Old Code)
```dart
final tokens = await SharedPreferences.getInstance();
tokens.setString('access_token', accessToken);
tokens.setString('refresh_token', refreshToken);
```

### After (New Code)
```dart
final tokenManager = TokenManager(secureStorage: storage);
await tokenManager.setTokens(
  accessToken: accessToken,
  refreshToken: refreshToken,
);
```

### Benefits
✅ Automatic expiration tracking
✅ Secure refresh token storage
✅ In-memory access token (faster)
✅ Automatic proactive refresh
✅ Concurrent request safety
✅ Clear token lifecycle management

---

## Production Checklist

- [ ] Replace `InMemorySecureStorageService` with `flutter_secure_storage`
- [ ] Update API base URL
- [ ] Update refresh endpoint path if different
- [ ] Configure token expiration duration (ask backend)
- [ ] Configure request timeout based on network conditions
- [ ] Add logging for token refresh operations
- [ ] Test token refresh scenarios
- [ ] Test concurrent request handling
- [ ] Test logout clears tokens properly
- [ ] Test app restart loads persisted tokens
- [ ] Monitor token refresh failures
- [ ] Set up error tracking/logging

---

## Files Modified/Created

**Created:**
- `core/storage/secure_storage_service.dart`
- `core/storage/token_manager.dart`
- `core/storage/token_refresh_manager.dart`
- `core/storage/auth_token_refresh_service.dart`
- `core/storage/token_management_setup.dart`
- `core/storage/storage.dart`
- `core/storage/JWT_TOKEN_HANDLING_GUIDE.md`
- `core/storage/IMPLEMENTATION_SUMMARY.md`
- `core/storage/QUICK_REFERENCE.md` (this file)

**Modified:**
- `core/network/api_client.dart` - Added 401 interceptor & token injection
- `features/auth/data/repositories/auth_repository_impl.dart` - Uses TokenManager

---

## Import Statements

```dart
// Get everything
import 'package:echo_app/core/storage/storage.dart';

// Or specific imports
import 'package:echo_app/core/storage/token_manager.dart';
import 'package:echo_app/core/storage/secure_storage_service.dart';
import 'package:echo_app/core/storage/token_refresh_manager.dart';
import 'package:echo_app/core/storage/auth_token_refresh_service.dart';
import 'package:echo_app/core/network/api_client.dart';
```

---

## Support & Troubleshooting

For complete integration guide, see: `JWT_TOKEN_HANDLING_GUIDE.md`
For implementation details, see: `IMPLEMENTATION_SUMMARY.md`
For setup examples, see: `token_management_setup.dart`
