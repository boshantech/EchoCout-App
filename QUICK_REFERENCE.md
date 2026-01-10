# EchoCout - Quick Reference Guide

## File Navigation

### Core Network
- `lib/core/network/dio_client.dart` - HTTP client with token refresh
- `lib/core/network/api_endpoints.dart` - All API endpoints
- `lib/core/network/token_manager.dart` - Token storage management

### Storage & Security
- `lib/core/storage/secure_storage_service.dart` - Secure token storage
- `lib/core/errors/app_exceptions.dart` - Custom exceptions

### Features Structure
```
lib/features/[feature]/
├── data/
│   ├── datasources/     ← API calls
│   ├── models/          ← JSON models
│   └── repositories/    ← Data layer logic
├── domain/
│   ├── entities/        ← Core objects
│   ├── repositories/    ← Interfaces
│   └── usecases/        ← Business logic
└── presentation/
    ├── bloc/            ← State management
    ├── pages/           ← Screens
    └── widgets/         ← UI components
```

---

## Quick Commands

```bash
# Run app
flutter run

# Get dependencies
flutter pub get

# Format code
dart format lib/

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Check dependencies
flutter pub outdated
```

---

## BLoC Quick Reference

### Auth Feature
| Event | Purpose |
|-------|---------|
| `SendOtpEvent(phoneNumber)` | Send OTP to phone |
| `VerifyOtpEvent(phone, code)` | Verify OTP |
| `LogoutEvent()` | Logout user |

### Home Feature
| Event | Purpose |
|-------|---------|
| `GetWasteCategoriesEvent()` | Load categories |
| `GetWasteListEvent(categoryId)` | Load waste items |
| `FilterByCategoryEvent(id)` | Filter by category |

### Echo Feature
| Event | Purpose |
|-------|---------|
| `GetEchoSummaryEvent()` | Load summary |
| `GetPendingPickupsEvent()` | Load pickups |
| `RefreshEchoEvent()` | Refresh data |

### Scanner Feature
| Event | Purpose |
|-------|---------|
| `EstimateWasteEvent(imagePath)` | Estimate from image |
| `UploadWastePhotoEvent(...)` | Upload waste |

### Rank Feature
| Event | Purpose |
|-------|---------|
| `GetLeaderboardEvent(page)` | Load leaderboard |
| `GetUserRankEvent()` | Get user rank |
| `RefreshLeaderboardEvent()` | Refresh |

### Profile Feature
| Event | Purpose |
|-------|---------|
| `GetUserProfileEvent()` | Load profile |
| `UpdateUserProfileEvent(...)` | Update profile |
| `LogoutProfileEvent()` | Logout |

---

## API Endpoints Reference

### Authentication
```
POST /auth/send-otp
POST /auth/verify-otp
POST /auth/refresh-token
POST /auth/logout
```

### Waste Management
```
GET  /waste/list
GET  /waste/categories
POST /waste/estimate-price
```

### Echo (Summary)
```
GET /echo/summary
GET /echo/pending-pickups
POST /echo/sell
```

### Scanner
```
POST /scan/estimate
POST /scan/upload
```

### Leaderboard
```
GET /rank/leaderboard
GET /rank/user-rank
```

### Profile
```
GET  /profile/me
PUT  /profile/update
GET  /profile/stats
```

---

## Common Code Snippets

### Access BLoC in Widget
```dart
context.read<AuthBloc>().add(SendOtpEvent(phone));
```

### Listen to BLoC State
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is OtpSent) {
      Navigator.push(...);
    }
  },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      // Build UI based on state
    },
  ),
)
```

### Show Loading
```dart
if (state is OtpSending) {
  return const Center(child: CircularProgressIndicator());
}
```

### Show Error
```dart
if (state is AuthFailure) {
  return Center(child: Text(state.message));
}
```

### Call API with DioClient
```dart
final dioClient = getIt<DioClient>();

// GET
final response = await dioClient.get('/endpoint');

// POST
final response = await dioClient.post(
  '/endpoint',
  data: {'key': 'value'},
);

// With headers
final response = await dioClient.get(
  '/endpoint',
  options: Options(headers: {'X-Custom': 'value'}),
);
```

### Handle Token
```dart
final tokenManager = TokenManager();

// Save
await tokenManager.saveTokens(
  accessToken: 'token',
  refreshToken: 'refresh',
);

// Get
final token = await tokenManager.getAccessToken();

// Clear
await tokenManager.clearTokens();
```

### Custom Exception
```dart
throw ValidationException('Invalid input');
throw ServerException('Server error', statusCode: 500);
throw NetworkException('No internet');
```

---

## Theme & Colors

Access colors via `AppColors`:
```dart
AppColors.primary           // Blue
AppColors.success           // Green
AppColors.error             // Red
AppColors.warning           // Orange
AppColors.textPrimary       // Black
AppColors.textSecondary     // Gray
AppColors.surface           // Light gray
```

---

## Route Navigation

```dart
// Named route
Navigator.pushNamed(context, RoutePaths.home);

// Replace
Navigator.pushReplacementNamed(context, RoutePaths.main);

// Clear and push
Navigator.pushNamedAndRemoveUntil(
  context,
  RoutePaths.main,
  (route) => false,
);

// Go back
Navigator.pop(context);
```

---

## Debugging Tips

### Check Token
```dart
final token = await TokenManager().getAccessToken();
debugPrint('Token: $token');
```

### Print BLoC State
```dart
on<Event>((event, emit) {
  debugPrint('Event: $event');
  // ...
  debugPrint('State: $newState');
  emit(newState);
});
```

### Check API Response
```dart
print('Status: ${response.statusCode}');
print('Data: ${response.data}');
print('Headers: ${response.headers}');
```

### Enable Dio Logging
```dart
_dio.interceptors.add(LoggingInterceptor());
```

---

## Important Constants

```dart
// Token keys
const String accessTokenKey = 'echo_access_token';
const String refreshTokenKey = 'echo_refresh_token';

// Waste categories
const List<String> wasteCategories = [
  'All', 'Plastic', 'Glass', 'Electronics', 'Metal', 'Paper', 'Paul'
];

// Timeouts
const int connectionTimeout = 30000;  // 30 seconds
const int receiveTimeout = 30000;     // 30 seconds

// OTP
const int otpLength = 6;
const int otpExpirySeconds = 600;     // 10 minutes
```

---

## Dependency Injection (GetIt)

### Register Service
```dart
getIt.registerSingleton<MyService>(MyService());
```

### Get Service
```dart
final service = getIt<MyService>();
```

### All registrations in
```
lib/config/injector/service_locator.dart
```

---

## Testing Quick Commands

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/auth_bloc_test.dart

# Run with coverage
flutter test --coverage

# View coverage
open coverage/index.html
```

---

## Common Issues & Quick Fixes

| Issue | Fix |
|-------|-----|
| `null` access token | Call `TokenManager().initializeTokens()` on app start |
| BLoC state not updating | Emit new state instances, not modified ones |
| 401 loop | Check if refresh token is valid |
| Camera not working | Check AndroidManifest.xml & Info.plist permissions |
| Network timeout | Increase timeout in DioClient |
| State lost on navigation | Move BLoC outside of widget that navigates |

---

## Important Files to Update

1. **Backend URL** → `lib/core/network/api_endpoints.dart`
2. **App Icon** → `assets/icon/icon.png`
3. **Splash Image** → `assets/images/splash.png`
4. **App Name** → `pubspec.yaml` and Android/iOS configs
5. **Package Name** → `android/app/build.gradle`, `ios/Runner.xcodeproj`

---

## Production Checklist

- [ ] Backend URL updated
- [ ] All TODO comments removed
- [ ] Error messages user-friendly
- [ ] Loading indicators present
- [ ] No debug prints left
- [ ] All tests passing
- [ ] Performance optimized
- [ ] Permissions configured
- [ ] App signed
- [ ] Version bumped

---

## Key Concepts

### Clean Architecture
Separates code into independent layers for testability and maintainability.

### BLoC Pattern
Business Logic Component - Separates business logic from UI.

### Repository Pattern
Abstracts data sources, allows easy switching between implementations.

### Use Cases
Encapsulate business logic, can be tested independently.

### Dependency Injection
Loose coupling, easier testing with mocks.

---

## Contact & Support

- **Documentation**: See README_IMPLEMENTATION.md
- **Architecture**: See ARCHITECTURE_SPEC.md  
- **Setup**: See SETUP_GUIDE.md
- **API**: See API_INTEGRATION_GUIDE.md

---

**Version:** 1.0.0
**Last Updated:** January 2026
**Status:** Production Ready
