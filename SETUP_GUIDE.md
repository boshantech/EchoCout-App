# EchoCout - Complete Setup Guide

## Quick Start

### 1. Prerequisites Installation

```bash
# Flutter
flutter --version

# Dart
dart --version

# Update Flutter
flutter upgrade
```

### 2. Install Dependencies

```bash
cd EchoCout-App
flutter pub get
```

### 3. Configure Backend URL

**File:** `lib/core/network/api_endpoints.dart`

```dart
static const String baseUrl = 'https://your-backend.com/api/v1';
```

### 4. Run the App

```bash
# Development
flutter run

# Release
flutter build apk --release
flutter build ios --release
```

---

## Project Architecture Overview

### Clean Architecture Implementation

```
DATA LAYER
├── Models (JSON serialization)
├── Data Sources (Remote/Local)
└── Repository Implementation

DOMAIN LAYER
├── Entities (Core business objects)
├── Repositories (Abstract interfaces)
└── Use Cases (Business logic)

PRESENTATION LAYER
├── BLoCs (State management)
├── Pages (Screens)
└── Widgets (UI components)
```

### Feature Structure

Each feature follows the same pattern:

```
features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── models/
│   │   └── auth_models.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── send_otp_usecase.dart
│       ├── verify_otp_usecase.dart
│       └── logout_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── pages/
    │   ├── phone_input_page.dart
    │   └── otp_verification_page.dart
    └── widgets/
        └── auth_form_widget.dart
```

---

## Core Components

### 1. DioClient (Network Layer)

**Location:** `lib/core/network/dio_client.dart`

**Features:**
- Centralized HTTP client
- Automatic token injection
- 401 error handling with token refresh
- Request/Response logging

**Usage:**
```dart
final dioClient = DioClient();
final response = await dioClient.get('/endpoint');
final response = await dioClient.post('/endpoint', data: {...});
```

### 2. TokenManager (Token Storage)

**Location:** `lib/core/network/token_manager.dart`

**Features:**
- Access token in memory (fast)
- Refresh token in secure storage (encrypted)
- Auto-refresh mechanism
- Token lifecycle management

**Usage:**
```dart
final tokenManager = TokenManager();
await tokenManager.saveTokens(
  accessToken: 'access_token_xyz',
  refreshToken: 'refresh_token_xyz',
);
final accessToken = await tokenManager.getAccessToken();
```

### 3. API Endpoints

**Location:** `lib/core/network/api_endpoints.dart`

All API endpoints centralized for easy management:

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com/api/v1';
  
  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  
  // Home
  static const String wasteList = '/waste/list';
  static const String wasteCategories = '/waste/categories';
  
  // ... more endpoints
}
```

### 4. BLoC State Management

**Hierarchy:**
- **AuthBloc** → Controls authentication flow
- **HomeBloc** → Manages waste list & categories
- **EchoBloc** → Handles summary & pickups
- **ScannerBloc** → Manages scanning operations
- **RankBloc** → Leaderboard data
- **ProfileBloc** → User profile management

---

## Authentication Flow

### Step 1: Phone Input

```dart
// Emit SendOtpEvent
context.read<AuthBloc>().add(SendOtpEvent(phoneNumber));

// Listen to OtpSent state
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is OtpSent) {
      // Navigate to OTP screen
    }
  },
)
```

### Step 2: OTP Verification

```dart
// Emit VerifyOtpEvent
context.read<AuthBloc>().add(
  VerifyOtpEvent(
    phoneNumber: '+91XXXXXXXXXX',
    otpCode: '123456',
  ),
);

// Listen to AuthSuccess
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // Tokens auto-saved by BLoC
      // Navigate to MainPage
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePaths.main,
        (route) => false,
      );
    }
  },
)
```

### Step 3: Auto Token Refresh

Handled automatically by DioClient interceptor:

```
Request (API) → 401 Unauthorized
         ↓
Interceptor catches error
         ↓
Call refresh-token endpoint
         ↓
Save new tokens
         ↓
Retry original request
         ↓
Return successful response
```

---

## Implementing New Features

### 1. Create Domain Layer

**Entity:** `features/myfeature/domain/entities/my_entity.dart`

```dart
class MyEntity extends Equatable {
  final String id;
  final String name;
  
  const MyEntity({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}
```

**Repository Interface:** `features/myfeature/domain/repositories/my_repository.dart`

```dart
abstract class MyRepository {
  Future<List<MyEntity>> getItems();
  Future<MyEntity> getItem(String id);
}
```

**Use Case:** `features/myfeature/domain/usecases/get_items_usecase.dart`

```dart
class GetItemsUseCase {
  final MyRepository repository;
  
  GetItemsUseCase({required this.repository});
  
  Future<List<MyEntity>> call() {
    return repository.getItems();
  }
}
```

### 2. Create Data Layer

**Model:** `features/myfeature/data/models/my_model.dart`

```dart
class MyModel extends MyEntity {
  const MyModel({required super.id, required super.name});
  
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

**Data Source:** `features/myfeature/data/datasources/my_datasource.dart`

```dart
class MyRemoteDataSource {
  final DioClient dioClient;
  
  MyRemoteDataSource({required this.dioClient});
  
  Future<List<MyModel>> getItems() async {
    final response = await dioClient.get('/my-items');
    return List<MyModel>.from(
      (response.data as List).map((x) => MyModel.fromJson(x))
    );
  }
}
```

**Repository:** `features/myfeature/data/repositories/my_repository_impl.dart`

```dart
class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource remoteDataSource;
  
  MyRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<MyEntity>> getItems() async {
    return await remoteDataSource.getItems();
  }
}
```

### 3. Create Presentation Layer

**BLoC:**

```dart
abstract class MyEvent extends Equatable {}
class GetItemsEvent extends MyEvent {}

abstract class MyState extends Equatable {}
class MyLoading extends MyState {}
class MyLoaded extends MyState {
  final List<MyEntity> items;
  const MyLoaded(this.items);
}
class MyError extends MyState {
  final String message;
  const MyError(this.message);
}

class MyBloc extends Bloc<MyEvent, MyState> {
  final GetItemsUseCase getItemsUseCase;
  
  MyBloc({required this.getItemsUseCase}) : super(MyLoading()) {
    on<GetItemsEvent>(_onGetItems);
  }
  
  Future<void> _onGetItems(GetItemsEvent event, Emitter<MyState> emit) async {
    try {
      final items = await getItemsUseCase();
      emit(MyLoaded(items));
    } catch (e) {
      emit(MyError(e.toString()));
    }
  }
}
```

**Page:**

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          if (state is MyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(title: Text(item.name));
              },
            );
          }
          if (state is MyError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
```

### 4. Register in Service Locator

`lib/config/injector/service_locator.dart`:

```dart
void _setupMyFeature() {
  // Data Sources
  getIt.registerSingleton<MyRemoteDataSource>(
    MyRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  
  // Repositories
  getIt.registerSingleton<MyRepository>(
    MyRepositoryImpl(remoteDataSource: getIt<MyRemoteDataSource>()),
  );
  
  // Use Cases
  getIt.registerSingleton<GetItemsUseCase>(
    GetItemsUseCase(repository: getIt<MyRepository>()),
  );
  
  // BLoCs
  getIt.registerSingleton<MyBloc>(
    MyBloc(getItemsUseCase: getIt<GetItemsUseCase>()),
  );
}
```

---

## Error Handling

### Custom Exception Classes

```dart
// Network error
throw NetworkException('Unable to reach server');

// Server error
throw ServerException('Server error', statusCode: 500);

// Auth error
throw AuthenticationException('Invalid credentials');

// Unauthorized
throw UnauthorizedException('Token expired');
```

### Global Error Handling

In screens:

```dart
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    if (state is MyError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
)
```

---

## Testing

### Unit Test Example

```dart
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockSendOtpUseCase mockSendOtpUseCase;
    
    setUp(() {
      mockSendOtpUseCase = MockSendOtpUseCase();
      authBloc = AuthBloc(sendOtpUseCase: mockSendOtpUseCase);
    });
    
    tearDown(() => authBloc.close());
    
    test('emit OtpSent when OTP sent successfully', () async {
      when(mockSendOtpUseCase(any))
        .thenAnswer((_) async => Right(unit));
      
      authBloc.add(SendOtpEvent('+919876543210'));
      
      expect(authBloc.stream, emits(OtpSent('+919876543210')));
    });
  });
}
```

---

## Performance Tips

### 1. Image Optimization
```dart
// Use cached network image
CachedNetworkImage(
  imageUrl: 'url',
  memCacheHeight: 300,
  memCacheWidth: 300,
)
```

### 2. List Optimization
```dart
ListView.builder(
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)
```

### 3. State Management
```dart
// Use BlocSelector for partial rebuilds
BlocSelector<HomeBloc, HomeState, List<Waste>>(
  selector: (state) => state.wasteItems,
  builder: (context, items) => ListView(...),
)
```

---

## Debugging

### Enable Logging

```dart
// In DioClient._initializeDio()
_dio.interceptors.add(LoggingInterceptor());
```

### Flutter DevTools

```bash
flutter pub global activate devtools
devtools
```

### Check Token

```dart
final tokenManager = TokenManager();
final token = await tokenManager.getAccessToken();
print('Token: $token');
```

---

## Deployment Checklist

- [ ] Backend URL configured
- [ ] All secrets stored in env
- [ ] No debug prints in production code
- [ ] All BLoCs properly closed
- [ ] Error handling implemented
- [ ] Tests passing
- [ ] App icons configured
- [ ] Permissions configured (Android/iOS)
- [ ] Privacy policy updated
- [ ] Terms of service added

---

## Common Issues & Solutions

### Issue: 401 Unauthorized loop
**Solution:** Check if refresh token is valid in secure storage

### Issue: State not updating
**Solution:** Ensure BLoC emits new state instances, not modifications

### Issue: Camera permission denied
**Solution:** Add permissions to AndroidManifest.xml and Info.plist

### Issue: Network timeout
**Solution:** Increase timeout in DioClient connectionTimeout

---

## Support

For more help:
- Check API_INTEGRATION_GUIDE.md
- Review BLoC documentation
- Check Flutter docs: https://flutter.dev

---

**Last Updated:** January 2026
**Version:** 1.0.0
