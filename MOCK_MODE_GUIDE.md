# EchoCout - Mock Mode Quick Start Guide

## Overview

The EchoCout app is now **fully functional in MOCK MODE** with:
- ✅ Zero backend dependencies
- ✅ Complete UI for all 5 features
- ✅ Mock authentication flow  
- ✅ Static waste data & pricing
- ✅ Mock leaderboard & user profiles
- ✅ Image picker integration
- ✅ Production-ready architecture

## What's Included

### ✨ Features Implemented

1. **Auth Flow (Mock)**
   - Phone input screen
   - OTP verification (use `1234` for testing)
   - Session persistence with SharedPreferences
   - Logout functionality

2. **Home Screen**
   - Stats card (Points, Nature saved %)
   - Category-based filtering (All, Plastic, Glass, Electronics, Metal, Paper, Organic)
   - Waste items list with pricing
   - Item details modal
   - Add to cart simulation

3. **Echo Screen (Waste Summary)**
   - Total waste sold stats
   - Total earnings display
   - Pending pickups list
   - Collector information cards
   - Pull-to-refresh gesture

4. **Scanner Screen**
   - Camera integration (using image_picker)
   - Gallery selection
   - AI-style waste detection mock
   - Estimated price calculation
   - Upload confirmation

5. **Rank Screen (Leaderboard)**
   - Top 10 users with rankings
   - Points and earnings display
   - Current user highlighting
   - Medal badges (Gold/Silver/Bronze)

6. **Profile Screen**
   - User information display
   - Stats overview
   - Logout button

### 🏗️ Architecture

```
lib/
├── core/
│   ├── mock/
│   │   ├── mock_data.dart          # All static data
│   │   └── mock_delays.dart        # Network simulation delays
│   ├── constants/
│   ├── theme/
│   └── utils/
├── config/
│   ├── routes/
│   │   ├── app_routes.dart         # Navigation routing
│   │   └── route_paths.dart        # Route constants
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart (FAKE)
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │           ├── phone_input_page.dart
│   │           └── otp_verification_page.dart
│   ├── home/
│   │   ├── data/repositories/home_repository.dart (FAKE)
│   │   └── presentation/pages/ (in main_page_mock.dart)
│   ├── echo/
│   │   ├── data/repositories/echo_repository.dart (FAKE)
│   │   └── presentation/pages/
│   ├── scanner/
│   │   ├── data/repositories/scanner_repository.dart (FAKE)
│   │   └── presentation/pages/
│   ├── rank/
│   │   ├── data/repositories/rank_repository.dart (FAKE)
│   │   └── presentation/pages/
│   ├── profile/
│   │   ├── data/repositories/profile_repository.dart (FAKE)
│   │   └── presentation/pages/
│   ├── main/
│   │   └── presentation/pages/
│   │       ├── main_page.dart          (Production routing)
│   │       └── main_page_mock.dart     (All 5 screens + bottom nav)
│   ├── splash/
│   │   └── presentation/pages/splash_page.dart
│   └── onboarding/
│       └── presentation/pages/onboarding_page.dart
└── main.dart
```

## Running the App

### Prerequisites

```bash
# Ensure Flutter & Dart are installed
flutter --version
dart --version

# Get dependencies
flutter pub get
```

### Run on Device/Emulator

```bash
# Clear build cache
flutter clean

# Run the app
flutter run

# Or with specific device
flutter run -d <device_id>
```

### User Flow (Testing)

1. **Splash Screen** (2 sec)
   → Auto-navigates to Onboarding

2. **Onboarding Screen**
   → Tap "Get Started" button

3. **Phone Input Screen**
   → Enter any phone number (e.g., `+91 98765 43210`)
   → Tap "Send OTP"

4. **OTP Verification Screen**
   → Enter OTP: **`1234`** (mock value for testing)
   → Tap "Verify"

5. **Main App (5-Tab Bottom Navigation)**
   - **Home Tab**: Browse waste items, filter by category, view pricing
   - **Echo Tab**: See waste summary, pending pickups (pull to refresh)
   - **Scanner Tab**: Pick image from camera/gallery, get AI mock price estimate
   - **Rank Tab**: View leaderboard with top 10 users
   - **Profile Tab**: View user stats, logout button

### Testing Scenarios

#### Home Screen Testing
```
✓ Tap categories to filter waste items
✓ Tap "Select" on any item to see details
✓ Add items to cart
✓ Items show price per unit or per kg
```

#### Echo Screen Testing
```
✓ View summary cards (Total Sold, Earnings, Pending)
✓ See pending pickup cards with collector info
✓ Pull down to refresh (simulated)
✓ All data updates with animation
```

#### Scanner Screen Testing
```
✓ Tap "Open Camera" or "Choose from Gallery"
✓ Select/take an image
✓ App shows mock AI detection results
✓ Displays estimated price based on category
✓ Tap "Confirm & Upload" to complete
```

#### Rank Screen Testing
```
✓ View top 10 users ranked by points
✓ Current user highlighted (rank 4)
✓ Medal badges show for top 3
✓ Earnings displayed per user
```

#### Profile Screen Testing
```
✓ View user profile with photo
✓ Stats show (Points, Earnings, Items Sold)
✓ Tap "Logout" → returns to phone input
```

## Mock Data Details

### Test User Profile
```
Name: Raj Kumar
Phone: +91 98765 43210
Points: 4,850
Earnings: ₹9,750.50
Items Sold: 245
```

### Waste Categories & Pricing
- Plastic: ₹2.50/unit
- Glass: ₹5.00/unit
- Electronics: ₹45.00/unit  
- Metal: ₹15.00/kg
- Paper: ₹1.50/kg
- Organic: ₹2.00/kg

### Mock Delays (Network Simulation)
- Authentication: 2 seconds
- Data fetch: 800ms
- Image processing: 1 second
- Upload: 3 seconds

## File Structure Quick Reference

### Core Mock Layer
- `lib/core/mock/mock_data.dart` - All static test data
- `lib/core/mock/mock_delays.dart` - Network simulation

### Repositories (Fake Implementation)
- All feature repos implement mock data fetching
- Located in: `features/{feature}/data/repositories/`
- Can be swapped with real API repos later

### UI Screens
- Main composite UI: `lib/features/main/presentation/pages/main_page_mock.dart`
- Auth pages: `lib/features/auth/presentation/pages/`
- Splash: `lib/features/splash/presentation/pages/splash_page.dart`
- Onboarding: `lib/features/onboarding/presentation/pages/onboarding_page.dart`

### Routing
- Route paths: `lib/config/routes/route_paths.dart`
- Route generation: `lib/config/routes/app_routes.dart`

## Future Backend Integration

The app is built with production-ready architecture:

### To Connect Real Backend:

1. **Replace Fake Repositories**
   - Update repositories to make real API calls
   - No UI changes needed
   - Keep same function signatures

2. **Update API Endpoints**
   - Edit `lib/core/network/api_endpoints.dart`
   - Add real backend URL

3. **Implement Data Sources**
   - Create `RemoteDataSourceImpl` for each feature
   - Use `DioClient` for HTTP requests

4. **Keep BLoC Pattern**
   - Existing BLoCs work with real repos
   - No state management changes needed

### Example: Auth Integration
```dart
// Current: Fake Repository
class FakeAuthRepository implements AuthRepository { ... }

// Future: Real Repository
class AuthRepository implements IAuthRepository {
  final DioClient dioClient;
  
  @override
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await dioClient.post(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'otp': otp}
    );
    return response.data;
  }
}
```

## Development Notes

### Key Files Modified
- ✅ `lib/config/routes/app_routes.dart` - Now uses `MainPageMock`
- ✅ `lib/features/main/presentation/pages/main_page_mock.dart` - Complete 5-tab UI
- ✅ Mock repositories - All return static data
- ✅ Mock delays - Simulate network latency

### Build Status
- ✅ Zero compilation errors
- ✅ All imports resolved
- ✅ All UI screens functional
- ✅ Ready to test on device

## Common Issues & Solutions

### Image Picker Not Working
- Ensure `image_picker` is in pubspec.yaml
- Grant camera/gallery permissions in Android/iOS settings
- Test on real device (emulator may have limitations)

### Mock Data Not Appearing
- Check `mock_data.dart` is in `lib/core/mock/`
- Verify imports use correct relative paths
- Clear build cache: `flutter clean`

### Navigation Issues
- Ensure route paths match in `route_paths.dart`
- Check `app_routes.dart` has all routes defined
- Clear app state when testing logout

### Performance
- Remove mock delays for faster UI testing: edit `mock_delays.dart`
- App is lightweight - should run smoothly on any device

## Testing Checklist

```
Authentication
☐ Phone input accepts numbers
☐ OTP 1234 accepted
☐ Session saved after login
☐ Can logout and login again

Home
☐ Categories filter correctly
☐ Item cards display properly
☐ Item details modal works
☐ Pricing calculations correct

Echo
☐ Summary cards show data
☐ Pickups list displays
☐ Pull-to-refresh works
☐ Animations smooth

Scanner
☐ Camera opens/gallery opens
☐ Image selected correctly
☐ Detection results display
☐ Upload confirmation works

Rank
☐ Leaderboard loads
☐ Current user highlighted
☐ Medal badges visible
☐ Scores sorted correctly

Profile
☐ User info displays
☐ Stats show correctly
☐ Logout button works
```

## Next Steps

1. **Run the app** with `flutter run`
2. **Test all flows** using checklist above
3. **Validate UX/UI** - animations, colors, layouts
4. **Prepare for backend integration** when API is ready
5. **Deploy test build** when satisfied with mock version

---

**Status**: ✅ COMPLETE - App is fully functional in mock mode
**Last Updated**: January 9, 2026
**Ready For**: UI testing, UX validation, demo builds, backend integration planning
