# 📂 Complete File Structure - Mock Implementation

## Root Level
```
EchoCout-App/
├── lib/                          # Source code
├── android/                       # Android native code
├── ios/                           # iOS native code
├── web/                           # Web support
├── test/                          # Tests
├── pubspec.yaml                   # Dependencies
├── pubspec.lock                   # Locked versions
├── analysis_options.yaml          # Linter config
├── MOCK_MODE_GUIDE.md            # 📖 Detailed testing guide
├── MOCK_IMPLEMENTATION_SUMMARY.md # 📖 Architecture overview
├── RUN_NOW.md                     # 📖 Quick start (START HERE!)
└── README.md                      # Project info
```

---

## lib/ Structure

### Core Layer (Mock Data & Theme)

```
lib/core/
├── mock/                          # 🎯 ALL MOCK DATA HERE
│   ├── mock_data.dart            # (255 lines) - Static test data
│   │   └── MockData class with:
│   │       - mockUser: Raj Kumar's profile
│   │       - wasteItems[8]: Pricing & descriptions
│   │       - wasteCategories[7]: Available categories
│   │       - echoSummary: Stats
│   │       - pickups[3]: Pending deliveries
│   │       - leaderboard[10]: Top users
│   │       - estimatedPrices: Category pricing
│   │
│   └── mock_delays.dart          # (11 lines) - Network simulation
│       └── MockDelays class with:
│           - authDelay: 2 seconds
│           - dataFetchDelay: 800ms
│           - uploadDelay: 3 seconds
│           - shouldFail(): 10% random failure
│
├── constants/
│   ├── api_endpoints.dart         # API routes (for future backend)
│   ├── app_constants.dart         # App config
│   └── strings.dart               # String constants
│
├── theme/
│   ├── app_colors.dart            # Color palette
│   ├── app_theme.dart             # Material theme
│   └── app_typography.dart        # Text styles
│
├── utils/
│   ├── logger.dart                # Logging utility
│   ├── input_converter.dart       # Input validation
│   └── extensions/                # Dart extensions
│       ├── context_extensions.dart
│       └── string_extensions.dart
│
├── network/
│   ├── dio_client.dart            # HTTP client (for future backend)
│   ├── token_manager.dart         # Token storage
│   ├── auth_interceptor.dart      # Auth interceptor
│   └── logging_interceptor.dart   # Request logging
│
├── storage/
│   └── secure_storage_service.dart # Encrypted storage
│
└── errors/
    ├── app_exceptions.dart         # Custom exceptions
    ├── failures.dart               # Failure classes
    └── exceptions.dart             # Generic exceptions
```

### Config Layer (Routes & Theme)

```
lib/config/
├── routes/
│   ├── route_paths.dart           # Route constants
│   │   - RoutePaths.splash: '/splash'
│   │   - RoutePaths.onboarding: '/onboarding'
│   │   - RoutePaths.phoneAuth: '/auth/phone'
│   │   - RoutePaths.otpVerification: '/auth/otp'
│   │   - RoutePaths.main: '/main'
│   │
│   ├── app_routes.dart            # 🔄 Route generation (UPDATED FOR MOCK)
│   │   └── onGenerateRoute() - routes all navigation
│   │       Uses MainPageMock for /main route
│   │
│   └── app_router.dart            # Legacy router (not used)
│
├── injector/
│   └── service_locator.dart       # Dependency injection (scaffold)
│
└── theme/
    └── (symlink to core/theme/)
```

### Features Layer (All 6 Features)

```
lib/features/

1. AUTH (Phone + OTP)
├── auth/
│   ├── data/
│   │   ├── datasources/           # Data source interfaces
│   │   ├── models/                # Data models
│   │   └── repositories/
│   │       └── auth_repository.dart ⭐ FAKE REPO
│   │           - sendOtp(): waits 2s, returns success
│   │           - verifyOtp(): accepts "1234", saves session
│   │           - logout(): clears session
│   │           - getStoredSession(): returns saved data
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   ├── auth_bloc.dart     # BLoC definition
│       │   ├── auth_event.dart    # AuthEvent classes
│       │   └── auth_state.dart    # AuthState classes
│       │
│       ├── pages/
│       │   ├── phone_input_page.dart        ✅ Working
│       │   ├── otp_verification_page.dart   ✅ Working
│       │   ├── login_page.dart              (unused)
│       │   └── register_page.dart           (unused)
│       │
│       └── widgets/

2. HOME (Waste Browsing)
├── home/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   │   ├── waste_model.dart
│   │   │   └── category_model.dart
│   │   └── repositories/
│   │       └── home_repository.dart ⭐ FAKE REPO
│   │           - getWasteCategories(): returns 7 categories
│   │           - getWasteItems(): returns 8 items (filtered by category)
│   │           - calculatePrice(): computes total price
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── waste_entity.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   └── home_bloc.dart
│       ├── pages/
│       │   └── (see HomeScreenMock in main_page_mock.dart)
│       └── widgets/

3. ECHO (Waste Summary)
├── echo/
│   ├── data/
│   │   ├── models/
│   │   │   └── echo_model.dart
│   │   └── repositories/
│   │       └── echo_repository.dart ⭐ FAKE REPO
│   │           - getEchoSummary(): returns stats
│   │           - getPendingPickups(): returns 3 pickups
│   │           - schedulePickup(): simulates booking
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── echo_entity.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   └── echo_bloc.dart
│       └── (see EchoScreenMock in main_page_mock.dart)

4. SCANNER (Image + Price Estimation)
├── scanner/
│   ├── data/
│   │   ├── models/
│   │   └── repositories/
│   │       └── scanner_repository.dart ⭐ FAKE REPO
│   │           - estimateWastePrice(): returns ±20% variance
│   │           - uploadWastePhoto(): confirms upload
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── scanner_entity.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   └── scanner_bloc.dart
│       └── (see ScannerScreenMock in main_page_mock.dart)

5. RANK (Leaderboard)
├── rank/
│   ├── data/
│   │   └── repositories/
│   │       └── rank_repository.dart ⭐ FAKE REPO
│   │           - getLeaderboard(): returns top 10
│   │           - getUserRank(): returns user's position
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── rank_entity.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   └── rank_bloc.dart
│       └── (see RankScreenMock in main_page_mock.dart)

6. PROFILE (User Info)
├── profile/
│   ├── data/
│   │   └── repositories/
│   │       └── profile_repository.dart ⭐ FAKE REPO
│   │           - getUserProfile(): returns mock user
│   │           - updateUserProfile(): simulates save
│   │           - logout(): clears session
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── profile_entity.dart
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   └── presentation/
│       ├── bloc/
│       │   └── profile_bloc.dart
│       └── (see ProfileScreenMock in main_page_mock.dart)

LAYOUT SCREENS
├── main/ ⭐ MAIN ENTRY POINT
│   └── presentation/pages/
│       ├── main_page.dart          # Original (production routing)
│       └── main_page_mock.dart     # ✨ CURRENT (all 5 screens here!)
│           - Contains MainPageMock widget with:
│           - _currentIndex state (0-4 for tabs)
│           - _buildBody() switch for 5 screens
│           - _buildBottomNavBar() with 5 items
│           - HomeScreenMock: Items browsing
│           - EchoScreenMock: Summary & pickups
│           - ScannerScreenMock: Image & detection
│           - RankScreenMock: Top 10 users
│           - ProfileScreenMock: User info & logout
│
├── splash/
│   └── presentation/pages/
│       └── splash_page.dart        # (2 sec loading screen)
│
└── onboarding/
    └── presentation/pages/
        └── onboarding_page.dart    # (Welcome screen)
```

---

## Key Files Reference

### 🎯 Start Here
```
RUN_NOW.md                          # Quick start
└── flutter run
```

### 📖 Understanding
```
MOCK_MODE_GUIDE.md                  # Detailed guide
MOCK_IMPLEMENTATION_SUMMARY.md      # Architecture overview
```

### 🔧 Core Mock Data
```
lib/core/mock/mock_data.dart        # All static test data
lib/core/mock/mock_delays.dart      # Delay simulation
```

### 🎨 Main UI
```
lib/features/main/presentation/pages/main_page_mock.dart
    └── Contains all 5 screens in one file!
        - HomeScreenMock
        - EchoScreenMock
        - ScannerScreenMock
        - RankScreenMock
        - ProfileScreenMock
```

### 🔄 Routing
```
lib/config/routes/app_routes.dart   # Route generation
lib/config/routes/route_paths.dart  # Route constants
```

### 🎭 Auth Pages
```
lib/features/auth/presentation/pages/phone_input_page.dart
lib/features/auth/presentation/pages/otp_verification_page.dart
```

### 📦 Fake Repositories
```
lib/features/auth/data/repositories/auth_repository.dart
lib/features/home/data/repositories/home_repository.dart
lib/features/echo/data/repositories/echo_repository.dart
lib/features/scanner/data/repositories/scanner_repository.dart
lib/features/rank/data/repositories/rank_repository.dart
lib/features/profile/data/repositories/profile_repository.dart
```

---

## File Statistics

| Category | Count | Lines |
|----------|-------|-------|
| Mock Files | 2 | 266 |
| Repository (Fake) | 6 | 220 |
| UI Screens | 1 major + 5 pages | 800+ |
| Auth Pages | 2 | 400 |
| Route Files | 2 | 100 |
| Theme/Config | 5+ | 300 |
| **TOTAL** | **20+** | **3000+** |

---

## Quick Navigation

### To View Mock Data
```
lib/core/mock/mock_data.dart (255 lines)
- Lines 1-50: User profile & auth tokens
- Lines 51-100: Waste items & categories
- Lines 101-150: Echo summary & pickups
- Lines 151-200: Leaderboard users
- Lines 201-255: Price estimation mapping
```

### To View Main UI
```
lib/features/main/presentation/pages/main_page_mock.dart
- Lines 1-60: MainPageMock container
- Lines 65-250: HomeScreenMock
- Lines 252-350: EchoScreenMock
- Lines 352-450: ScannerScreenMock
- Lines 452-520: RankScreenMock
- Lines 522-600: ProfileScreenMock
```

### To View Routing
```
lib/config/routes/app_routes.dart
- onGenerateRoute() method handles all navigation
- Routes to MainPageMock for /main path
```

### To Add Real Backend
```
Replace all files in:
lib/features/{feature}/data/repositories/
Keep same method signatures!
```

---

## Build Status

✅ **Zero compilation errors**
✅ **All imports resolved**
✅ **All files created**
✅ **Ready to run**

---

**Last Updated**: January 9, 2026  
**Status**: ✅ Complete & Ready to Test
