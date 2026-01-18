# EchoCout - Architecture & Implementation Specifications

## Complete Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                        │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │  Auth    │  Home    │  Echo    │ Scanner  │  Rank    │  │
│  │  Pages   │  Pages   │  Pages   │  Pages   │  Pages   │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
│                                                             │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │ AuthBloc │ HomeBloc │ EchoBloc │ScannerBl │ RankBloc │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
│                                                             │
│  BLoCs handle state management, events, and user logic     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Use Cases   │  │  Repositories│  │   Entities   │     │
│  │  (Logic)     │  │  (Abstract)  │  │  (Models)    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
│  Pure Dart, no dependencies, business logic here           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     DATA LAYER                              │
│  ┌────────────────┐  ┌────────────────┐                    │
│  │  Data Sources  │  │  Repositories  │                    │
│  │  (API/Cache)   │  │  Impl          │                    │
│  └────────────────┘  └────────────────┘                    │
│  ┌────────────────┐  ┌────────────────┐                    │
│  │    Models      │  │   Mappers      │                    │
│  │  (JSON)        │  │  (Dto → Entity)│                    │
│  └────────────────┘  └────────────────┘                    │
│                                                             │
│  Handles data transformation and caching                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  CORE LAYER                                 │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐       │
│  │   Network   │  │   Storage    │  │   Theme     │       │
│  │  (DioClient)│  │  (SecureStore)  │  (Colors)   │       │
│  └─────────────┘  └──────────────┘  └─────────────┘       │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐       │
│  │  Errors     │  │  Constants   │  │    Utils    │       │
│  │ (Exceptions)│  │  (AppConfig) │  │  (Helpers)  │       │
│  └─────────────┘  └──────────────┘  └─────────────┘       │
│                                                             │
│  Reusable across all features                              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                EXTERNAL SERVICES                            │
│         MongoDB    Express    Node.js                       │
│         Backend API Server                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Flow Example: Home Feature

```
USER INTERACTION
       ↓
┌─ Get Waste Categories
│  
├─→ HomeBloc.add(GetWasteCategoriesEvent)
│       ↓
├─→ HomeBloc._onGetCategories()
│       ↓
├─→ GetWasteCategoriesUseCase.call()
│       ↓
├─→ HomeRepository.getWasteCategories()
│       ↓
├─→ HomeRemoteDataSource.getWasteCategories()
│       ↓
├─→ DioClient.get('/waste/categories')
│       ↓
├─→ HTTP Request to Backend
│       ↓
├─→ Backend Returns JSON: [{ id, name, icon, price, unit }]
│       ↓
├─→ WasteCategoryModel.fromJson(json)
│       ↓
├─→ Map Model → Entity
│       ↓
├─→ HomeBloc.emit(CategoriesLoaded(categories))
│       ↓
└─→ UI Updates via BlocBuilder
       ↓
   Display Categories on Screen
```

---

## Authentication & Token Flow

```
PHASE 1: SEND OTP
┌──────────────────────┐
│ User enters phone    │
│ Taps "Send OTP"      │
└──────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ AuthBloc.add(SendOtpEvent)           │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ POST /auth/send-otp                  │
│ { phoneNumber: "+91XXXXXXXXXX" }     │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ Backend sends OTP via SMS            │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ AuthBloc.emit(OtpSent)               │
│ UI shows OTP input screen            │
└──────────────────────────────────────┘


PHASE 2: VERIFY OTP
┌──────────────────────┐
│ User enters OTP      │
│ Taps "Verify"        │
└──────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ AuthBloc.add(VerifyOtpEvent)         │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ POST /auth/verify-otp                │
│ { phoneNumber, otpCode }             │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ Backend verifies OTP                 │
│ Returns: {                           │
│   accessToken: "...",                │
│   refreshToken: "...",               │
│   user: { ... }                      │
│ }                                    │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ TokenManager.saveTokens()            │
│ - accessToken → memory               │
│ - refreshToken → secure storage      │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ AuthBloc.emit(AuthSuccess)           │
│ UI navigates to MainPage             │
└──────────────────────────────────────┘


PHASE 3: AUTO TOKEN REFRESH
Every API Request:
    ↓
┌──────────────────────────────────┐
│ DioClient injects token:         │
│ Header: Authorization: Bearer XX │
└──────────────────────────────────┘
    ↓
API Response: 200 OK? ──Yes→ Return response
    ↓ No
API Response: 401 Unauthorized
    ↓
┌──────────────────────────────────┐
│ TokenInterceptor catches 401     │
└──────────────────────────────────┘
    ↓
┌──────────────────────────────────┐
│ Queue pending requests           │
└──────────────────────────────────┘
    ↓
┌──────────────────────────────────┐
│ POST /auth/refresh-token         │
│ { refresh_token }                │
└──────────────────────────────────┘
    ↓
Refresh successful? ──No→ Clear tokens & logout
    ↓ Yes
┌──────────────────────────────────┐
│ Save new tokens                  │
└──────────────────────────────────┘
    ↓
┌──────────────────────────────────┐
│ Retry original request with new  │
│ accessToken                      │
└──────────────────────────────────┘
    ↓
Return successful response
```

---

## BLoC State Management Pattern

### Each BLoC Follows This Pattern:

```dart
// 1. EVENTS - User interactions
abstract class XEvent extends Equatable {}
class FetchEvent extends XEvent {}

// 2. STATES - UI states
abstract class XState extends Equatable {}
class XInitial extends XState {}
class XLoading extends XState {}
class XLoaded extends XState { final data; }
class XError extends XState { final message; }

// 3. BLoC - Event handler
class XBloc extends Bloc<XEvent, XState> {
  final UseCase useCase;
  
  XBloc({required this.useCase}) : super(XInitial()) {
    on<FetchEvent>(_onFetch);
  }
  
  Future<void> _onFetch(FetchEvent event, Emitter<XState> emit) async {
    emit(XLoading());
    try {
      final data = await useCase();
      emit(XLoaded(data));
    } catch (e) {
      emit(XError(e.toString()));
    }
  }
}

// 4. UI - Listens to state changes
class XPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XBloc, XState>(
      builder: (context, state) {
        if (state is XLoading) return LoadingWidget();
        if (state is XLoaded) return ContentWidget(state.data);
        if (state is XError) return ErrorWidget(state.message);
        return const SizedBox();
      },
    );
  }
}
```

---

## Bottom Navigation Implementation

```dart
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  
  // Each tab maintains its own BLoC state
  // Switch doesn't reset BLoCs
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Echo'),
          // ... more items
        ],
      ),
    );
  }
  
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return HomePage();  // HomeBloc active
      case 1: return EchoPage();  // EchoBloc active
      // ... more cases
    }
  }
}
```

---

## Security Implementation

### 1. Token Storage Strategy

```
SECURE STORAGE (Encrypted on device):
├── Refresh Token
│   └── Persisted across sessions
│   └── Used to get new access token
│   └── Never exposed to API
│
IN-MEMORY STORAGE:
├── Access Token
│   └── Cleared on app close
│   └── Injected in every request
│   └── Short-lived (15-30 minutes)
│
FLOW:
User Login → Get both tokens
         ↓
Save refresh → Secure Storage
         ↓
Save access → Memory
         ↓
Every Request → Inject access token
         ↓
401 Error → Use refresh token to get new access token
         ↓
Retry request with new token
         ↓
Logout → Clear memory & secure storage
```

### 2. HTTPS & SSL Pinning

```dart
// In DioClient
final httpClient = HttpClient();
httpClient.badCertificateCallback = (cert, host, port) => false;
```

### 3. Data Validation

```dart
// Always validate on client side
class SendOtpRequest {
  String phoneNumber;
  
  SendOtpRequest({required this.phoneNumber}) {
    if (phoneNumber.isEmpty) {
      throw ValidationException('Phone number cannot be empty');
    }
    if (phoneNumber.length < 10) {
      throw ValidationException('Invalid phone number');
    }
  }
}
```

---

## Error Handling Architecture

```
API Error (DioException)
         ↓
┌────────────────────────────┐
│ Check error type           │
└────────────────────────────┘
         ↓
    ┌────┴────┬────────────┬────────────┐
    ↓         ↓            ↓            ↓
NetworkEx ServerEx  AuthEx  ValidationEx
    ↓         ↓            ↓            ↓
  Show   Display    Logout  Show Input
  Toast  Error     & Redirect Error
```

---

## Feature Checklist

### ✅ Auth Feature
- [x] Phone number input validation
- [x] OTP sending
- [x] OTP verification
- [x] Token storage (secure)
- [x] Auto logout on token failure
- [x] Error handling

### ✅ Home Feature
- [x] Waste categories display
- [x] Category filtering
- [x] Waste list with prices
- [x] Stats card (points & nature saved)
- [x] Loading states
- [x] Error handling

### ✅ Echo Feature
- [x] Summary display
- [x] Total earnings
- [x] Pending pickups
- [x] Collector info display
- [x] Refresh capability

### ✅ Scanner Feature
- [x] Camera integration
- [x] Image upload
- [x] Waste estimation
- [x] Price calculation
- [x] Upload progress

### ✅ Rank Feature
- [x] Leaderboard display
- [x] Top 10 users
- [x] Current user highlight
- [x] Points display
- [x] Rank badges

### ✅ Profile Feature
- [x] User info display
- [x] Statistics (points, earnings, items)
- [x] Profile image
- [x] Logout button
- [x] Edit profile capability

### ✅ Core Features
- [x] DioClient setup
- [x] Token manager
- [x] Auto token refresh
- [x] Error handling
- [x] Secure storage
- [x] Theme setup
- [x] Routing
- [x] DI (service locator)

---

## Production Readiness Checklist

- [ ] All BLoCs tested
- [ ] All data sources tested
- [ ] Error messages user-friendly
- [ ] Loading indicators present
- [ ] No hardcoded values
- [ ] Proper logging (not verbose)
- [ ] Memory leaks fixed
- [ ] Performance optimized
- [ ] Accessibility features added
- [ ] Permissions properly configured
- [ ] App signing configured
- [ ] Version bumped
- [ ] Release notes prepared

---

## Next Steps

1. **Implement Repository Interfaces** - Follow API_INTEGRATION_GUIDE.md
2. **Add Unit Tests** - Mock all dependencies
3. **Add Widget Tests** - Test UI components
4. **Add Integration Tests** - Test full flows
5. **Set up CI/CD** - GitHub Actions or Firebase
6. **Performance Testing** - Load testing & profiling
7. **Security Audit** - Check for vulnerabilities
8. **User Feedback** - Beta testing

---

**Document Version:** 1.0.0
**Last Updated:** January 2026
**Status:** Production Ready Architecture
