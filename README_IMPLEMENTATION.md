# EchoCout - Waste Management & Selling Platform

## Overview

A production-grade Flutter mobile application for waste management and selling platform, integrated with a Node.js + Express + MongoDB backend.

### Key Features

- **Phone Number + OTP Authentication**
- **Home Screen** with category-based waste listing
- **Echo Summary** showing earnings and pickups
- **Scanner** with camera integration for waste estimation
- **Leaderboard** showing top users by points
- **User Profile** with statistics and earnings
- **Bottom Navigation** with 5 tabs
- **Token Auto-Refresh** mechanism
- **Secure Storage** for tokens
- **Clean Architecture** with BLoC state management

---

## Tech Stack

### Frontend
- **Flutter** (Latest Stable)
- **Dart** 3.10+
- **BLoC** for state management
- **Dio** for HTTP networking
- **Flutter Secure Storage** for secure token storage
- **GetIt** for dependency injection

### Backend
- **Node.js + Express**
- **MongoDB**
- **JWT Authentication**

---

## Project Structure

```
lib/
├── core/
│   ├── network/
│   │   ├── dio_client.dart          # HTTP client with interceptors
│   │   ├── api_endpoints.dart       # API endpoints
│   │   ├── api_interceptors.dart    # Token injection & refresh
│   │   └── token_manager.dart       # Token storage & management
│   ├── storage/
│   │   └── secure_storage_service.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_typography.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── echo/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── scanner/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── rank/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── config/
│   ├── routes/
│   │   ├── app_routes.dart
│   │   ├── route_paths.dart
│   │   └── route_names.dart
│   ├── injector/
│   │   └── service_locator.dart
│   └── theme/
│
├── main.dart
├── bootstrap.dart
└── app.dart
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.10+)
- Android Studio / Xcode
- Git

### Step 1: Clone Repository
```bash
git clone <repo-url>
cd echo_app
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Environment Configuration
Update `lib/core/network/api_endpoints.dart`:
```dart
static const String baseUrl = 'YOUR_BACKEND_URL';
```

### Step 4: Run App
```bash
flutter run
```

---

## API Integration

### Authentication Flow

#### 1. Send OTP
```
POST /auth/send-otp
{
  "phoneNumber": "+91XXXXXXXXXX"
}

Response:
{
  "success": true,
  "message": "OTP sent successfully",
  "expiresIn": 600
}
```

#### 2. Verify OTP
```
POST /auth/verify-otp
{
  "phoneNumber": "+91XXXXXXXXXX",
  "otpCode": "123456"
}

Response:
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG...",
  "user": {
    "id": "userId",
    "phoneNumber": "+91XXXXXXXXXX",
    "totalPoints": 0,
    "totalEarnings": 0
  }
}
```

#### 3. Token Refresh (Auto-handled by interceptor)
```
POST /auth/refresh-token
{
  "refresh_token": "eyJhbG..."
}

Response:
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG..."
}
```

### Home Endpoints
- `GET /waste/list` - Get waste items
- `GET /waste/categories` - Get waste categories
- `POST /waste/estimate-price` - Estimate price for waste

### Echo Endpoints
- `GET /echo/summary` - Get user summary
- `GET /echo/pending-pickups` - Get pending pickups

### Scanner Endpoints
- `POST /scan/estimate` - Estimate waste from image
- `POST /scan/upload` - Upload waste photo

### Rank Endpoints
- `GET /rank/leaderboard` - Get top 10 users
- `GET /rank/user-rank` - Get user's current rank

### Profile Endpoints
- `GET /profile/me` - Get user profile
- `PUT /profile/update` - Update user profile

---

## State Management (BLoC)

### Auth BLoC Events
- `SendOtpEvent` - Send OTP to phone
- `VerifyOtpEvent` - Verify OTP code
- `LogoutEvent` - Logout user

### Auth BLoC States
- `AuthInitial` - Initial state
- `OtpSending` - OTP sending in progress
- `OtpSent` - OTP sent successfully
- `OtpVerifying` - OTP verification in progress
- `AuthSuccess` - Authentication successful
- `AuthFailure` - Authentication failed

### Similar BLoCs exist for:
- **HomeBloc** - Waste list & categories
- **EchoBloc** - Summary & pickups
- **ScannerBloc** - Scanning & upload
- **RankBloc** - Leaderboard data
- **ProfileBloc** - User profile

---

## Token Management

### Token Storage Strategy

**Access Token:** 
- Stored in memory for fast access
- Cleared on logout or expiration
- Sent with every API request

**Refresh Token:**
- Stored in secure storage (encrypted)
- Persisted across app launches
- Used to get new access token on 401 response

### Auto-Token Refresh Flow

1. API request returns 401 (Unauthorized)
2. Interceptor catches the error
3. Refresh endpoint called with refresh_token
4. If successful: New tokens stored, original request retried
5. If failed: User logged out, redirect to login screen

---

## Bottom Navigation Structure

```
┌─────────────────────────────┐
│         Main Screen         │
├─────────────────────────────┤
│   [HomeBloc State Display]  │
│   [EchoBloc State Display]  │
│   [ScannerBloc State]       │
│   [RankBloc State]          │
│   [ProfileBloc State]       │
├─────────────────────────────┤
│ 🏠 🔄 📱 🏆 👤              │
│ Home | Echo | Scanner | Rank│  
└─────────────────────────────┘
```

Each tab maintains its own BLoC state independently.

---

## Error Handling

Custom Exception Classes:
- `NetworkException` - Network connectivity issues
- `ServerException` - Server-side errors
- `AuthenticationException` - Auth-related errors
- `UnauthorizedException` - 401 Unauthorized
- `ValidationException` - Input validation errors
- `CacheException` - Local storage errors

---

## Security Best Practices

✅ Tokens stored in secure storage (encrypted)
✅ Access token never persisted to disk
✅ Auto token refresh on 401
✅ HTTPS-only communication
✅ Token expiration validation
✅ Automatic logout on token failure

---

## Testing

### Unit Tests
```bash
flutter test test/unit/
```

### Widget Tests
```bash
flutter test test/widget/
```

### Integration Tests
```bash
flutter test integration_test/
```

---

## Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## Troubleshooting

### Token Refresh Issues
- Ensure refresh_token is valid in secure storage
- Check backend refresh endpoint
- Verify token expiration times

### Camera/Scanner Not Working
- Grant camera permissions in Android/iOS
- Check device camera availability
- Test with mock data first

### State Not Updating
- Ensure BLoC events are being emitted
- Check BLoC listener setup
- Verify emitted states are new instances

---

## Dependencies

See `pubspec.yaml` for complete list. Key packages:

```yaml
flutter_bloc: ^8.1.3      # State management
dio: ^5.4.0               # HTTP client
flutter_secure_storage: ^9.0.0  # Token storage
image_picker: ^1.0.4      # Camera/Gallery
camera: ^0.10.5           # Camera access
get_it: ^7.6.0            # Dependency injection
```

---

## Performance Optimization

- **Lazy loading** of features with BLoC
- **Pagination** for list endpoints
- **Caching** of frequently accessed data
- **Image optimization** for camera uploads
- **Connection pooling** via Dio

---

## Future Enhancements

- [ ] Push notifications for pickups
- [ ] Payment integration (Razorpay/Stripe)
- [ ] Analytics tracking
- [ ] Offline support with local DB
- [ ] Multi-language support
- [ ] Dark mode optimizations

---

## License

Proprietary - EchoCout Platform

---

## Support

For issues or questions:
- GitHub Issues
- support@ecocout.com

---

## Team

Built by Senior Flutter Engineers with 8+ years experience in production-grade applications.
