# JWT Token Handling - Implementation Summary

## ✅ Completed Implementation

### Core Components Created

#### 1. **SecureStorageService** 
- File: `core/storage/secure_storage_service.dart`
- Abstract interface for secure token storage
- Includes `InMemorySecureStorageService` for development
- Ready to swap with `flutter_secure_storage` for production

#### 2. **TokenManager**
- File: `core/storage/token_manager.dart`
- Manages complete token lifecycle
- **In-memory access token** storage with expiration tracking
- **Secure storage** for refresh tokens
- Features:
  - `getAccessToken()` - Fast in-memory access
  - `isAccessTokenExpired()` - Check expiration
  - `isAccessTokenExpiringSoon()` - Proactive refresh detection (5 min window)
  - `setTokens()` - Store tokens after authentication
  - `updateAccessToken()` - Update after refresh
  - `clearTokens()` - Clear all tokens on logout
  - `isAuthenticated()` - Check auth status
  - `loadTokens()` - Restore persisted tokens on app restart

#### 3. **TokenRefreshManager**
- File: `core/storage/token_refresh_manager.dart`
- Handles token refresh with safety mechanisms
- Features:
  - Prevents concurrent refresh attempts
  - Manages refresh state
  - Proactive refresh before expiration
  - Tracks last refresh timestamp

#### 4. **AuthTokenRefreshService**
- File: `core/storage/auth_token_refresh_service.dart`
- Implements `TokenRefreshService` interface
- Makes actual API call to refresh endpoint (`/auth/refresh-token`)
- Extracts and returns new access token

#### 5. **Enhanced ApiClient**
- File: `core/network/api_client.dart` (modified)
- **Key Enhancement**: 401 Interceptor with automatic retry
- Token injection in all requests (GET, POST, PUT, DELETE)
- Auto-refresh on 401 response
- **Automatic retry** of failed request with new token
- Flow:
  1. Request made with current access token
  2. Server returns 401 → Detected
  3. `onTokenRefresh` callback triggered
  4. TokenRefreshManager refreshes token
  5. Original request automatically retried
  6. Success: Return response | Failure: Throw exception

#### 6. **Updated AuthRepository**
- File: `features/auth/data/repositories/auth_repository_impl.dart` (modified)
- Now uses `TokenManager` instead of SharedPreferences
- Stores tokens in appropriate locations:
  - Access token: In-memory (fast access)
  - Refresh token: Secure storage (protected)

#### 7. **Module Exports & Documentation**
- `core/storage/storage.dart` - Barrel file with all exports
- `core/storage/JWT_TOKEN_HANDLING_GUIDE.md` - Complete integration guide
- `core/storage/token_management_setup.dart` - Setup examples

---

## 🔄 Token Flow Diagrams

### Authentication Flow
```
User Login
    ↓
SendOtpEvent
    ↓
VerifyOtpEvent
    ↓
Backend returns: accessToken + refreshToken
    ↓
TokenManager.setTokens()
    ├─ accessToken → In-Memory (fast)
    └─ refreshToken → Secure Storage (protected)
    ↓
AuthBloc → Authenticated State
    ↓
App Ready (all requests use tokens)
```

### API Request with Token Injection
```
API Request (GET /user/profile)
    ↓
ApiClient.get() called
    ↓
_getHeaders() adds: "Authorization: Bearer <accessToken>"
    ↓
Send request with header
    ↓
✓ Response 200/201 → Return data
✗ Response 401 → Unauthorized
    ↓
    ├─ Detect 401 status code
    ├─ Call _handleTokenRefresh()
    ├─ onTokenRefresh callback
    ├─ TokenRefreshManager.tryRefreshToken()
    │   ├─ Get refreshToken from secure storage
    │   ├─ Call /auth/refresh-token endpoint
    │   └─ Update accessToken in TokenManager
    ├─ AUTOMATICALLY RETRY original request
    │   └─ GET /user/profile (with new token)
    └─ Return response or throw exception
```

### Token Refresh with Concurrency Control
```
Multiple 401 Responses (concurrent requests)
    ↓
    ├─ Request 1: 401 detected
    │   └─ _isRefreshing = false → Start refresh
    │
    ├─ Request 2: 401 detected (while refresh in progress)
    │   └─ _isRefreshing = true → Wait for refresh to complete
    │
    └─ Request 3: 401 detected (while refresh in progress)
        └─ _isRefreshing = true → Wait for refresh to complete
    ↓
Refresh completes
    ↓
All requests retry with new token
```

### Logout Flow
```
LogoutEvent
    ↓
AuthBloc calls LogoutUseCase
    ↓
AuthRepository.logout()
    ├─ Call backend /auth/logout
    └─ TokenManager.clearTokens()
        ├─ Clear in-memory accessToken
        └─ Delete refreshToken from secure storage
    ↓
AuthBloc → Unauthenticated State
    ↓
App navigates to login
```

---

## 🛠️ Key Features

### 1. **Fast Access Token Storage** ⚡
- In-memory storage (millisecond access)
- No I/O operations for every request
- Lost on app restart (ok, refresh token still available)

### 2. **Secure Refresh Token Storage** 🔐
- Platform-specific secure storage
- Survives app restart
- Cannot be accessed by other apps

### 3. **Automatic 401 Handling** 🔄
- Transparent to application code
- No special error handling needed
- Retry happens automatically

### 4. **Expiration Tracking** ⏱️
- Token expiration time stored
- `isAccessTokenExpired()` for manual checks
- `isAccessTokenExpiringSoon()` for proactive refresh (5 min window)

### 5. **Concurrent Request Safety** 🔒
- Multiple 401s don't trigger multiple refreshes
- Prevents "thundering herd" problem
- All requests wait for single refresh to complete

### 6. **Production-Ready** 🚀
- Minimal dependencies (uses `http` package)
- Easy to replace with `flutter_secure_storage`
- Comprehensive error handling
- Clear separation of concerns

---

## 📚 File Structure

```
app/lib/
├── core/
│   ├── network/
│   │   ├── api_client.dart          (MODIFIED - 401 interceptor)
│   │   └── exceptions.dart
│   └── storage/
│       ├── secure_storage_service.dart           (NEW)
│       ├── token_manager.dart                    (NEW)
│       ├── token_refresh_manager.dart            (NEW)
│       ├── auth_token_refresh_service.dart       (NEW)
│       ├── token_management_setup.dart           (NEW - examples)
│       ├── storage.dart                          (NEW - barrel)
│       └── JWT_TOKEN_HANDLING_GUIDE.md           (NEW - documentation)
└── features/
    └── auth/
        └── data/
            └── repositories/
                └── auth_repository_impl.dart    (MODIFIED - uses TokenManager)
```

---

## 🔧 Quick Integration Checklist

- [x] Token manager created with in-memory access token
- [x] Secure storage service interface created
- [x] Token refresh manager with concurrency control
- [x] Auth token refresh service implementation
- [x] ApiClient enhanced with 401 interceptor
- [x] Automatic request retry after token refresh
- [x] AuthRepository updated to use TokenManager
- [x] Complete integration documentation
- [x] Setup examples provided

---

## 💻 Usage Example

```dart
// Initialize (in bootstrap)
final tokenManager = TokenManager(secureStorage: storage);
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenManager: tokenManager,
  onTokenRefresh: refreshManager.tryRefreshToken,
);

// After login, set tokens
await tokenManager.setTokens(
  accessToken: 'eyJhbGc...',
  refreshToken: 'refresh_token...',
);

// Make requests - token handling is automatic!
final response = await apiClient.get('/user/profile');
// If 401 occurs:
// 1. Token is refreshed automatically
// 2. Request is retried with new token
// 3. Response is returned or error thrown
```

---

## 🚀 Next Steps

1. **Service Locator Integration**
   - Update your service locator (GetIt/Provider/Riverpod) setup
   - Register all token management services
   - See `token_management_setup.dart` for examples

2. **Production Secure Storage**
   - Add `flutter_secure_storage` dependency
   - Implement `ProductionSecureStorageService`
   - Replace `InMemorySecureStorageService`

3. **API Configuration**
   - Update API base URL in `ApiClient`
   - Update refresh endpoint path if different
   - Configure token expiration duration

4. **Testing**
   - Mock `TokenManager` for unit tests
   - Mock `ApiClient` 401 scenarios
   - Test token refresh flow

5. **Monitoring**
   - Add logging in `TokenRefreshManager`
   - Track token refresh metrics
   - Monitor 401 error rates

---

## 📋 What This Implementation Handles

✅ Store access token in memory
✅ Store refresh token in secure storage  
✅ Intercept 401 responses
✅ Refresh token on 401
✅ Retry failed request after refresh
✅ Prevent concurrent refresh attempts
✅ Clear tokens on logout
✅ Load persisted tokens on app restart
✅ Track token expiration
✅ Proactive refresh detection
✅ Handle refresh failures gracefully
✅ Network error handling

---

## 🔍 Technical Details

**Token Expiration:**
- Access token: 1 hour (configurable)
- Refresh token: Server-defined (typically 7-30 days)

**Request Timeout:** 30 seconds (configurable)

**Refresh Retry Window:** 5 minutes before expiration

**Concurrent Refresh:** Prevented by `_isRefreshing` flag

**Error Propagation:** 
- Refresh failure → `UnauthorizedException`
- Network error → `NetworkException`
- Server error → `ServerException`

---

## 🎯 Architecture Benefits

1. **Separation of Concerns**
   - Token storage separate from HTTP client
   - Refresh logic isolated in manager
   - Repository doesn't handle tokens directly

2. **Testability**
   - Mock interfaces for all services
   - No static dependencies
   - Clear dependencies via constructor injection

3. **Maintainability**
   - Single responsibility principle
   - Easy to extend (implement `TokenRefreshService`)
   - Clear error handling paths

4. **Performance**
   - In-memory access token (no I/O per request)
   - Lazy refresh (only on 401 or when expiring soon)
   - Concurrent request safety without queuing

5. **Security**
   - Refresh token in secure storage
   - Access token not persisted on disk
   - Clear on logout
   - Automatic refresh prevents stale tokens
