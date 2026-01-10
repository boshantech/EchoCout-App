# JWT Token Handling - Architecture & Flow Diagrams

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                  Presentation Layer                  │  │
│  │         (BLoC, Pages, Screens - No token logic)     │  │
│  └────────────────────┬─────────────────────────────────┘  │
│                       │                                     │
│  ┌────────────────────▼─────────────────────────────────┐  │
│  │              Data & Domain Layer                      │  │
│  │  (Repositories, Usecases, Services - Business Logic)│  │
│  └────────────────────┬─────────────────────────────────┘  │
│                       │                                     │
│  ┌────────────────────▼─────────────────────────────────┐  │
│  │         Core - Token Management Layer                │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐   │  │
│  │  │          TokenManager                       │   │  │
│  │  │  • In-memory access token (fast)           │   │  │
│  │  │  • Token expiration tracking               │   │  │
│  │  │  • Secure storage for refresh token        │   │  │
│  │  │  • Authentication status check             │   │  │
│  │  └──────────────┬────────────────────────────┘   │  │
│  │               │                                    │  │
│  │  ┌────────────▼──────────────────────────────┐   │  │
│  │  │    SecureStorageService                   │   │  │
│  │  │  • Abstract interface                     │   │  │
│  │  │  • InMemorySecureStorageService (dev)    │   │  │
│  │  │  • FlutterSecureStorage (production)     │   │  │
│  │  └───────────────────────────────────────────┘   │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐   │  │
│  │  │    TokenRefreshManager                      │   │  │
│  │  │  • Token refresh orchestration             │   │  │
│  │  │  • Concurrency control                     │   │  │
│  │  │  • Proactive refresh detection             │   │  │
│  │  └──────────────┬───────────────────────────┘   │  │
│  │               │                                    │  │
│  │  ┌────────────▼──────────────────────────────┐   │  │
│  │  │  AuthTokenRefreshService                   │   │  │
│  │  │  • API calls to /auth/refresh-token        │   │  │
│  │  │  • Response parsing & validation           │   │  │
│  │  └───────────────────────────────────────────┘   │  │
│  │                                                       │  │
│  └───────────────────┬────────────────────────────────┘  │
│                      │                                    │
│  ┌───────────────────▼────────────────────────────────┐  │
│  │      Network Layer (ApiClient)                     │  │
│  │                                                     │  │
│  │  ┌───────────────────────────────────────────┐   │  │
│  │  │  ApiClient (Enhanced)                     │   │  │
│  │  │  • Token injection in headers             │   │  │
│  │  │  • 401 response detection                 │   │  │
│  │  │  • Automatic token refresh trigger        │   │  │
│  │  │  • Automatic request retry                │   │  │
│  │  │  • GET/POST/PUT/DELETE methods           │   │  │
│  │  └──────────┬──────────────────────────────┘   │  │
│  │            │                                    │  │
│  │  ┌─────────▼────────────────────────────────┐  │  │
│  │  │  HTTP Layer (http package)                │  │  │
│  │  │  • Network requests                       │  │  │
│  │  │  • Response handling                      │  │  │
│  │  └───────────────────────────────────────────┘  │  │
│  └──────────────────┬────────────────────────────┘  │
│                     │                                │
│  ┌──────────────────▼────────────────────────────┐  │
│  │           Backend API Server                   │  │
│  │  • /auth/send-otp                             │  │
│  │  • /auth/verify-otp                           │  │
│  │  • /auth/refresh-token    ◄─ Token Refresh   │  │
│  │  • /user/profile           ◄─ Protected      │  │
│  │  • /auth/logout            ◄─ Protected      │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Request Flow with 401 Handling

```
User Makes API Request
    ↓
    │ GET /user/profile
    │
▼───────────────────────────────────────────────────┐
│        1. ApiClient.get() Called                  │
│           └─ endpoint: "/user/profile"            │
└──────────────────┬────────────────────────────────┘
                   │
▼───────────────────────────────────────────────────┐
│   2. _getHeaders() Retrieves AccessToken         │
│       tokenManager.getAccessToken()              │
│       └─ Returns: "eyJhbGc..."  (from memory)   │
└──────────────────┬────────────────────────────────┘
                   │
▼───────────────────────────────────────────────────┐
│   3. Build Request Headers                        │
│       Authorization: Bearer eyJhbGc...           │
│       Content-Type: application/json             │
└──────────────────┬────────────────────────────────┘
                   │
▼───────────────────────────────────────────────────┐
│   4. Send HTTP Request                            │
│       http.get(url, headers: headers)            │
└──────────────────┬────────────────────────────────┘
                   │
                   ├─────────────────────┬──────────────────┐
                   ▼                     ▼                  ▼
        ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
        │   Response 200   │  │   Response 401   │  │   Response 5xx   │
        │   Success!       │  │   Unauthorized   │  │   Server Error   │
        │                  │  │                  │  │                  │
        │ ┌──────────────┐ │  │ ┌──────────────┐ │  │ ┌──────────────┐ │
        │ │ Parse JSON   │ │  │ │ Detect 401   │ │  │ │ Throw        │ │
        │ │ Return data  │ │  │ │              │ │  │ │ ServerExc.   │ │
        │ └──────────────┘ │  │ └──────┬───────┘ │  │ └──────────────┘ │
        └────────┬─────────┘  │        │         │  └────────┬─────────┘
                 │            │        │         │           │
                 │            │        │         │           │
                 │            ▼        │         │           │
                 │      ┌─────────────────────────────┐       │
                 │      │  5. Token Refresh Needed    │       │
                 │      │  a. Call onTokenRefresh()   │       │
                 │      │  b. TokenRefreshManager     │       │
                 │      │  c. Check _isRefreshing     │       │
                 │      │     ├─ false: Start refresh │       │
                 │      │     └─ true: Wait for other │       │
                 │      └──────────┬──────────────────┘       │
                 │                 │                          │
                 │                 ▼                          │
                 │         ┌────────────────────┐             │
                 │         │ 6. Try Refresh     │             │
                 │         │ Get refreshToken   │             │
                 │         │ from secure storage│             │
                 │         └──────────┬─────────┘             │
                 │                    │                       │
                 │                    ▼                       │
                 │         ┌────────────────────┐             │
                 │         │ 7. Call /auth/     │             │
                 │         │    refresh-token   │             │
                 │         │ endpoint           │             │
                 │         └──────────┬─────────┘             │
                 │                    │                       │
                 │            ┌───────┴───────┐               │
                 │            ▼               ▼               │
                 │     ┌────────────┐  ┌────────────┐         │
                 │     │ Success    │  │ Failed     │         │
                 │     │ New Token  │  │ Clear all  │         │
                 │     │ Received   │  │ tokens &   │         │
                 │     │            │  │ throw      │         │
                 │     │ 8. Update  │  │ error      │         │
                 │     │TokenMgr    │  │            │         │
                 │     └──────┬─────┘  └────────┬───┘         │
                 │            │                 │              │
                 │            ▼                 ▼              │
                 │    ┌──────────────┐  ┌──────────────┐      │
                 │    │ 9. Retry     │  │ Propagate    │      │
                 │    │ Original Req │  │ Error to UI  │      │
                 │    │ with new     │  │ (show login) │      │
                 │    │ access token │  │              │      │
                 │    └──────┬───────┘  └──────────────┘      │
                 │           │                                │
                 │           ▼                                │
                 │  ┌──────────────────────┐                  │
                 │  │ GET /user/profile    │                  │
                 │  │ Authorization: Bearer│                  │
                 │  │ <NEW_TOKEN>          │                  │
                 │  └──────────┬───────────┘                  │
                 │             │                              │
                 └─────────────┼──────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Return API Response │
                    │  or Final Error      │
                    └──────────────────────┘
```

## Token Lifecycle

```
APPLICATION START
    ↓
┌─────────────────────────────────┐
│ Load Persisted Tokens           │
│ tokenManager.loadTokens()       │
│ ├─ Load accessToken from storage│
│ └─ Load refreshToken from secure│
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Check Authentication Status     │
│ if (accessToken == null):       │
│   → Navigate to Login Screen    │
│ else:                           │
│   → Use cached accessToken      │
└────────┬────────────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
LOGIN    ALREADY LOGGED IN
    │         │
    │         ▼
    │    ┌──────────────────────────┐
    │    │ Access Token in Memory   │
    │    │ • Fast access (no I/O)   │
    │    │ • Valid for ~1 hour      │
    │    │ • Used for all requests  │
    │    └────────────┬─────────────┘
    │                 │
    │                 │ (Every 5 min check)
    │                 │
    │                 ▼
    │        ┌──────────────────────┐
    │        │ Expiring Soon? (<5m) │
    │        │ Proactively Refresh? │
    │        └──────────┬───────────┘
    │                   │
    │    ┌──────────────┴──────────────┐
    │    ▼                             ▼
    │  YES                             NO
    │    │                             │
    │    ▼                             │
    │ Refresh Token                    │
    │ └── refreshToken────────┐       │
    │                        │        │
    │    ┌───────────────────┴────┐   │
    │    ▼                         ▼  │
    │ From Secure Storage          │  │
    │ └─ /auth/refresh-token ──────┤  │
    │    └─ Get new accessToken    │  │
    │                              │  │
    └──────────────┬───────────────┴──┘
                   │
                   ▼
         ┌─────────────────────┐
         │ Updated in Memory   │
         │ • New accessToken   │
         │ • New expiration    │
         │ • Continue requests │
         └──────────┬──────────┘
                    │
         ┌──────────┴──────────┐
         ▼                     ▼
      LOGOUT              SESSION EXPIRES
         │                     │
         ▼                     │
   ┌────────────────┐         │
   │ Call /auth/    │         │
   │ logout endpoint│         │
   └────────┬───────┘         │
            │                 │
            ▼                 │
    ┌──────────────────┐      │
    │ Clear Tokens:    │      │
    │ • accessToken    │      │
    │   (memory)       │◄─────┘
    │ • refreshToken   │
    │   (secure store) │
    │ • expiry time    │
    └────────┬─────────┘
             │
             ▼
    ┌─────────────────────┐
    │ Navigate to Login   │
    │ User must login     │
    │ again              │
    └─────────────────────┘
```

## Storage Strategy

```
┌────────────────────────────────────────────────────────────┐
│           Token Storage Strategy Comparison                │
├──────────────────────────────────┬──────────────────────────┤
│     IN-MEMORY ACCESS TOKEN       │  SECURE REFRESH TOKEN    │
├──────────────────────────────────┼──────────────────────────┤
│                                  │                          │
│  Storage: RAM                    │  Storage: Secure Storage │
│  Speed: Milliseconds             │  Speed: Milliseconds     │
│  Persistence: No (app restart)   │  Persistence: Yes       │
│  Security: Medium (in RAM)       │  Security: High         │
│  Usage: Every request            │  Usage: On expiration    │
│  Size: Small (jwt token)         │  Size: Small            │
│                                  │                          │
│  ✓ Fast access                   │  ✓ Protected by OS      │
│  ✓ No disk I/O per request       │  ✓ Survives restart     │
│  ✗ Lost on app restart           │  ✗ Less frequent access │
│  ✓ Lost on logout                │  ✓ Cleared on logout    │
│                                  │                          │
└──────────────────────────────────┴──────────────────────────┘

Why this strategy?
  • Access token: Used for EVERY request → needs to be fast
  • Refresh token: Used only when accessToken expires → can use slow storage
  • Different lifetimes: accessToken (1hr) vs refreshToken (7-30 days)
  • Security vs Performance tradeoff: balanced
```

## Concurrency Control

```
Scenario: Multiple 401 Responses (Concurrent Requests)

T=0ms:   Request A makes API call
T=10ms:  Request B makes API call
T=20ms:  Request C makes API call
T=30ms:  
    │         Both A, B, C get 401 responses
    │
    ├─► Request A:
    │    ├─ Detects 401
    │    ├─ Checks _isRefreshing = false
    │    ├─ Sets _isRefreshing = true
    │    ├─ Calls TokenRefreshManager.tryRefreshToken()
    │    └─ Waits for refresh...
    │
    ├─► Request B:
    │    ├─ Detects 401
    │    ├─ Checks _isRefreshing = true ◄─ ALREADY REFRESHING
    │    ├─ Waits for refresh to complete
    │    └─ Uses refreshed token for retry
    │
    └─► Request C:
         ├─ Detects 401
         ├─ Checks _isRefreshing = true ◄─ ALREADY REFRESHING
         ├─ Waits for refresh to complete
         └─ Uses refreshed token for retry

T=150ms: Refresh completes with new token
    │
    ├─► Request A: Retries with new token → Success
    ├─► Request B: Retries with new token → Success
    └─► Request C: Retries with new token → Success

Result:
  ✓ Only ONE refresh operation executed (not 3)
  ✓ All 3 requests use the same new token
  ✓ Efficient and safe
  ✓ Prevents "thundering herd" problem
```

## Error Recovery

```
┌─────────────────────────────────────────────┐
│        Token Refresh Failure Handling        │
└──────────────────┬──────────────────────────┘
                   │
         ┌─────────┴─────────┐
         ▼                   ▼
    Network Error      Server Error (400/401/5xx)
         │                   │
         ▼                   ▼
    No Internet        Invalid Refresh Token
         │                   │
         ├─ Retry on       ├─ Clear all tokens
         │   reconnect     │
         │                 ├─ Return null
         ├─ Return         │
         │   null          └─ Force re-login
         │
         └─ Keep tokens    Result:
            for offline    • Must login again
            use           • Secure (invalid token removed)
                          • User understands (shows login)

User Impact:
  • First scenario: Seamless retry on reconnect
  • Second scenario: Brief error → Login screen
```

This demonstrates why token management is critical for robust apps!
