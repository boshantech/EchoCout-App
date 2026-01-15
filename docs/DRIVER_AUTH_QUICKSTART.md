# ⚡ Driver Auth - Quick Start

## 🎯 Test the Login Flow

### Step 1: Navigate to Driver Login
```dart
Navigator.of(context).pushNamed('/driver-login');
```

### Step 2: Phone Screen
- Enter phone: **8123456790**
- Click **Continue**
- ✅ Should proceed to OTP screen

### Step 3: OTP Screen
- Enter OTP: **1234**
- Click **Verify OTP**
- ✅ Should navigate to driver home

---

## 🧪 Error Cases to Test

### ❌ Wrong Phone Number
Enter any phone other than `8123456790`
→ Shows: "Unauthorized Driver. Please contact support."

### ❌ Wrong OTP
Enter anything other than `1234`
→ Shows: "Invalid OTP. Please try again."

### ❌ Incomplete Phone
Enter less than 10 digits
→ Continue button disabled

### ❌ Incomplete OTP
Enter less than 4 digits
→ Verify button disabled

---

## 🏗️ Architecture at a Glance

```
┌─────────────────────────────────────┐
│      Presentation Layer (UI)        │
│  Phone Screen → OTP Screen → Home   │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│  Business Logic (DriverAuthBloc)    │
│  Validates phone & OTP              │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│   Data Layer (Mock Datasource)      │
│  Static: 8123456790 / 1234          │
└─────────────────────────────────────┘
```

---

## 📁 File Organization

```
lib/features/driver_auth/
├── domain/
│   ├── entities/driver_auth_entity.dart
│   └── repositories/driver_auth_repository.dart
├── data/
│   ├── datasources/driver_auth_local_datasource.dart
│   └── repositories/driver_auth_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── driver_auth_bloc.dart
    │   ├── driver_auth_event.dart
    │   └── driver_auth_state.dart
    └── pages/
        ├── driver_phone_login_screen.dart
        └── otp_verification_screen.dart
```

---

## 🔄 State Flow

```
Start
  ↓
Phone Input → Validate → Authorized?
  ↓                          ↓
OTP Input              Error (Unauthorized)
  ↓
Verify OTP → Valid?
  ↓              ↓
Home        Error (Invalid OTP)
            (Retry)
```

---

## 🚀 Key Implementation Points

1. **Phone Validation**
   - Exactly 10 digits
   - Numeric only
   - Real-time feedback

2. **OTP Verification**
   - Exactly 4 digits
   - Static: `1234`
   - Auto-focus input

3. **State Management**
   - Bloc pattern
   - Type-safe events & states
   - Equatable for comparison

4. **Error Handling**
   - Clear error messages
   - Non-destructive errors
   - Retry capability

5. **UI/UX**
   - Disabled buttons when invalid
   - Loading indicators
   - Success checkmarks
   - Masked phone display

---

## 💡 Tips

- Test credentials are visible in info cards on both screens
- Back button on OTP screen returns to phone input
- Phone validation is real-time
- OTP field auto-focuses on screen load
- Loading indicators show during validation

---

## 📖 For Full Details
See: `DRIVER_AUTH_IMPLEMENTATION_GUIDE.md`
