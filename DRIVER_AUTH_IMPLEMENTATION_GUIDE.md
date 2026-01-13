# 🚗 Driver Login Flow - Complete Implementation Guide

## Overview
A production-ready driver login system with 2-step phone + OTP verification for the waste-collection app. No backend required - uses static mock data.

---

## 📋 Architecture

### Folder Structure
```
lib/features/driver_auth/
├── domain/
│   ├── entities/
│   │   └── driver_auth_entity.dart          # Auth data model
│   └── repositories/
│       └── driver_auth_repository.dart      # Abstract repository
├── data/
│   ├── datasources/
│   │   └── driver_auth_local_datasource.dart # Mock data & logic
│   └── repositories/
│       └── driver_auth_repository_impl.dart  # Repository implementation
└── presentation/
    ├── bloc/
    │   ├── driver_auth_bloc.dart            # Business logic
    │   ├── driver_auth_event.dart           # User actions
    │   └── driver_auth_state.dart           # UI states
    └── pages/
        ├── driver_phone_login_screen.dart   # Phone input
        └── otp_verification_screen.dart     # OTP input
```

### State Management: Bloc Pattern
```
User Input
    ↓
Event (RequestOtpEvent, VerifyOtpEvent)
    ↓
DriverAuthBloc (Business Logic)
    ↓
State (PhoneNumberWaitingState, OtpWaitingState, DriverAuthenticatedState)
    ↓
UI Update
```

---

## 🔑 Key Features

### Phone Number Screen
- **Input**: 10-digit Indian phone number
- **Validation**:
  - Exactly 10 digits
  - Numeric only
  - Real-time validation feedback
  - Continue button enabled only when valid
- **Allowed Driver**: `8123456790`
- **Error Handling**: Shows "Unauthorized Driver" for non-matching numbers

### OTP Screen
- **Input**: 4-digit static OTP
- **Static OTP**: `1234`
- **Features**:
  - Auto-focus OTP field
  - Masked phone display (8123****90)
  - Real-time validation
  - Verify button enabled only when complete
  - Back navigation to phone screen
- **Error Handling**: Shows "Invalid OTP" for incorrect code

---

## 🚀 Usage

### Starting the Login Flow
```dart
// Navigate to driver login
Navigator.of(context).pushNamed('/driver-login');
```

### Login Flow States
1. **DriverAuthInitial** → App starts
2. **PhoneNumberWaitingState** → Waiting for phone input
3. **PhoneNumberValidatingState** → Validating phone
4. **PhoneNumberErrorState** → Invalid/unauthorized phone
5. **OtpWaitingState** → Ready for OTP input
6. **OtpVerifyingState** → Verifying OTP
7. **OtpErrorState** → Invalid OTP
8. **DriverAuthenticatedState** → Success! Navigate to home
9. **DriverUnauthenticatedState** → Logout

### Bloc Events
```dart
// Request OTP with phone number
context.read<DriverAuthBloc>().add(RequestOtpEvent('8123456790'));

// Verify OTP
context.read<DriverAuthBloc>().add(VerifyOtpEvent(
  phoneNumber: '8123456790',
  otp: '1234',
));

// Reset to initial state
context.read<DriverAuthBloc>().add(const ResetAuthEvent());

// Logout
context.read<DriverAuthBloc>().add(const LogoutEvent());

// Clear error message
context.read<DriverAuthBloc>().add(const ClearErrorEvent());
```

---

## 🛠️ Implementation Details

### Clean Architecture Principles

#### 1. **Domain Layer** (Business Rules)
```dart
// driver_auth_repository.dart - Defines what auth service should do
abstract class DriverAuthRepository {
  Future<bool> validatePhoneNumber(String phoneNumber);
  Future<bool> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String otp);
  Future<String?> completeLogin(String phoneNumber);
}
```

#### 2. **Data Layer** (Implementation)
```dart
// driver_auth_local_datasource.dart - Mock data & logic
class DriverAuthLocalDataSource {
  static const String allowedDriverPhone = '8123456790';
  static const String staticOtp = '1234';
  
  Future<bool> validatePhoneNumber(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return phoneNumber == allowedDriverPhone;
  }
}

// driver_auth_repository_impl.dart - Concrete implementation
class DriverAuthRepositoryImpl implements DriverAuthRepository {
  // Uses datasource to fulfill contracts
}
```

#### 3. **Presentation Layer** (UI & State)
```dart
// driver_auth_bloc.dart - Orchestrates business logic
class DriverAuthBloc extends Bloc<DriverAuthEvent, DriverAuthState> {
  Future<void> _onRequestOtp(RequestOtpEvent event, Emitter emit) async {
    // 1. Validate format
    // 2. Call repository
    // 3. Emit appropriate state
  }
}

// driver_phone_login_screen.dart - UI that reacts to states
BlocConsumer<DriverAuthBloc, DriverAuthState>(
  listener: (context, state) {
    if (state is OtpWaitingState) {
      Navigator.push(...); // Navigate to OTP screen
    }
  },
  builder: (context, state) {
    // Build UI based on state
  },
)
```

### Validation Flow
```
User Input → Format Validation → Authorization Check → Network Simulation → State Update
```

#### Phone Validation:
```dart
// 1. Check length
if (phoneNumber.length != 10) {
  emit(PhoneNumberErrorState(...));
  return;
}

// 2. Check numeric
if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
  emit(PhoneNumberErrorState(...));
  return;
}

// 3. Check authorization
final isAuthorized = await repository.validatePhoneNumber(phoneNumber);
if (!isAuthorized) {
  emit(PhoneNumberErrorState(...));
  return;
}

// 4. All valid - proceed to OTP
emit(OtpWaitingState(...));
```

#### OTP Validation:
```dart
// 1. Check length
if (otp.length != 4) {
  emit(OtpErrorState(...));
  return;
}

// 2. Check numeric
if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
  emit(OtpErrorState(...));
  return;
}

// 3. Verify OTP
final isValid = await repository.verifyOtp(phoneNumber, otp);
if (!isValid) {
  emit(OtpErrorState(...));
  return;
}

// 4. Complete login
emit(DriverAuthenticatedState(...));
```

---

## 📱 UI Components

### Phone Login Screen Features
- ✅ +91 prefix (fixed, non-editable)
- ✅ 10-digit input field
- ✅ Real-time validation counter (0/10, 1/10, etc.)
- ✅ Numeric keyboard only
- ✅ Continue button (disabled when invalid)
- ✅ Error message display with icon
- ✅ Success validation (checkmark when 10 digits)
- ✅ Info card with test credentials
- ✅ Loading state during phone validation

### OTP Screen Features
- ✅ Back button to return to phone screen
- ✅ Masked phone number display
- ✅ Large 4-digit OTP input (centered, monospace)
- ✅ Numeric keyboard only
- ✅ Auto-focus on screen load
- ✅ Verify button (disabled when incomplete)
- ✅ Error message display
- ✅ Success validation (checkmark when 4 digits)
- ✅ Info card with test OTP
- ✅ Loading state during OTP verification

---

## 🔐 Security Considerations (Simulated)

1. **No Backend**: All data is mock/static - for development only
2. **OTP Verification**: Must complete before navigation
3. **State Reset**: Logout clears all auth data
4. **App Restart**: Resets auth state (no persistence)
5. **Phone Masking**: OTP screen shows masked number (8123****90)

---

## 🧪 Testing Guide

### Test Case 1: Valid Login
```
1. Enter: 8123456790
2. Verify: Phone valid, continues to OTP
3. Enter OTP: 1234
4. Result: ✅ Authenticated → Navigate to home
```

### Test Case 2: Invalid Phone
```
1. Enter: 9876543210
2. Result: ❌ "Unauthorized Driver" error
```

### Test Case 3: Wrong OTP
```
1. Phone: 8123456790 ✅
2. Enter OTP: 9999
3. Result: ❌ "Invalid OTP" error
```

### Test Case 4: Incomplete Phone
```
1. Enter: 812345679 (9 digits)
2. Result: Continue button disabled
```

### Test Case 5: Incomplete OTP
```
1. Phone: 8123456790 ✅
2. Enter OTP: 123 (3 digits)
3. Result: Verify button disabled
```

### Test Case 6: Back Navigation
```
1. Phone: 8123456790 ✅
2. On OTP screen, click back
3. Result: Back to phone screen, state reset
```

---

## 🔄 State Flow Diagram

```
DriverAuthInitial
    ↓
PhoneNumberWaitingState ← User opens phone screen
    ↓
    ├→ [User enters 8123456790]
    │   ↓
    │   PhoneNumberValidatingState
    │   ↓
    │   ├→ [Valid & Authorized] → OtpWaitingState
    │   │   ↓
    │   │   ├→ [User enters 1234]
    │   │   │   ↓
    │   │   │   OtpVerifyingState
    │   │   │   ↓
    │   │   │   ├→ [OTP Correct] → DriverAuthenticatedState ✅
    │   │   │   └→ [OTP Wrong] → OtpErrorState
    │   │   │       ↓
    │   │   │       [User can retry]
    │   │   │       ↓
    │   │   │       OtpWaitingState
    │   │   │
    │   │   └→ [User clicks back] → PhoneNumberWaitingState
    │   │
    │   └→ [Invalid/Unauthorized] → PhoneNumberErrorState
    │       ↓
    │       [User can retry]
    │       ↓
    │       PhoneNumberWaitingState
    │
    └→ [User logs out] → DriverUnauthenticatedState
```

---

## 📝 Integration Checklist

- ✅ Created all Bloc files (events, states, bloc)
- ✅ Created domain entities and repository contracts
- ✅ Implemented data source with mock data
- ✅ Created phone login screen with validation
- ✅ Created OTP verification screen
- ✅ Updated service locator with dependency injection
- ✅ Updated app routes for new screens
- ✅ Added DriverAuthBloc to app's MultiBlocProvider
- ✅ Implemented state-driven navigation
- ✅ Added error handling and validation
- ✅ Clean architecture separation of concerns
- ✅ Production-ready UI with loading states
- ✅ Comprehensive error messages

---

## 🎯 Next Steps (If Backend Integration Needed)

When connecting to a real backend, only modify:

### 1. Update Repository Contract
```dart
// Add backend implementation
class DriverAuthRemoteDataSource {
  final DioClient dioClient;
  
  Future<bool> validatePhoneNumber(String phoneNumber) async {
    final response = await dioClient.post(
      '/api/driver/validate-phone',
      data: {'phone': phoneNumber},
    );
    return response.data['authorized'] == true;
  }
}
```

### 2. Update Service Locator
```dart
void _setupDriverAuth() {
  // Replace local with remote datasource
  getIt.registerSingleton<DriverAuthDataSource>(
    DriverAuthRemoteDataSource(
      dioClient: getIt<DioClient>(),
    ),
  );
}
```

**Rest of the code remains unchanged!** This is the power of clean architecture.

---

## 📚 File Reference

| File | Purpose |
|------|---------|
| `driver_auth_entity.dart` | Data model with phone masking utility |
| `driver_auth_repository.dart` | Abstract repository interface |
| `driver_auth_local_datasource.dart` | Mock data & static credentials |
| `driver_auth_repository_impl.dart` | Repository implementation |
| `driver_auth_bloc.dart` | Business logic & state management |
| `driver_auth_event.dart` | User action events |
| `driver_auth_state.dart` | UI state classes |
| `driver_phone_login_screen.dart` | Phone number input UI |
| `otp_verification_screen.dart` | OTP input UI |

---

## 🚨 Important Notes

1. **Test Credentials**:
   - Phone: `8123456790`
   - OTP: `1234`

2. **Static-Only**: No real SMS/OTP service. For production, implement real SMS gateway.

3. **No Persistence**: Auth resets on app restart. Implement `flutter_secure_storage` for persistence.

4. **Bloc Pattern**: All business logic in Bloc, UI only listens to states.

5. **No Navigation Logic in UI**: Navigation happens in listeners, not in builders.

6. **Clean Architecture**: Domain → Data → Presentation separation is strict.

---

**Status**: ✅ Production-Ready (Mock Mode)  
**Version**: 1.0.0  
**Last Updated**: January 2026
