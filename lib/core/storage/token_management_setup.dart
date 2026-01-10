import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';
import '../storage/token_manager.dart';
import '../storage/token_refresh_manager.dart';
import '../storage/auth_token_refresh_service.dart';

/// Service locator setup for dependency injection
/// Contains all token management and authentication dependencies
class TokenManagementSetup {
  /// Initialize all token management and authentication services
  /// Call this during app bootstrap before any API calls
  static Future<void> setupTokenManagement() async {
    // 1. Initialize secure storage
    // For production: replace with flutter_secure_storage
    final secureStorage = InMemorySecureStorageService();

    // 2. Initialize token manager
    final tokenManager = TokenManager(
      secureStorage: secureStorage,
      accessTokenExpiration: const Duration(hours: 1),
    );

    // Load persisted tokens from storage
    await tokenManager.loadTokens();

    // 3. Initialize API client with token management
    // Note: onTokenRefresh will be set after refreshManager is created
    final apiClient = ApiClient(
      baseUrl: 'https://your-api.com/api', // Update with your API URL
      tokenManager: tokenManager,
      timeout: const Duration(seconds: 30),
    );

    // 4. Initialize token refresh service
    final refreshService = AuthTokenRefreshService(apiClient: apiClient);

    // 5. Initialize token refresh manager
    TokenRefreshManager(
      refreshService: refreshService,
      tokenManager: tokenManager,
    );

    // 6. Setup API client token refresh callback
    // Note: onTokenRefresh is final and set via constructor
    // apiClient.onTokenRefresh = refreshManager.tryRefreshToken;

    // 7. Register services in service locator (example using GetIt pattern)
    // sl.registerSingleton<SecureStorageService>(secureStorage);
    // sl.registerSingleton<TokenManager>(tokenManager);
    // sl.registerSingleton<ApiClient>(apiClient);
    // sl.registerSingleton<TokenRefreshManager>(refreshManager);

    // For this example, we're just storing references
    // In production, use GetIt or your preferred service locator
  }

  /// Example of setting up authentication repositories and usecases
  /// Call this after setupTokenManagement()
  /// Note: This is a setup example. In production, use GetIt or your preferred service locator.
  static void setupAuthenticationDependencies() {
    // Example setup code - requires actual ApiClient and TokenManager instances
    // 
    // final apiClient = sl<ApiClient>();
    // final tokenManager = sl<TokenManager>();
    //
    // // Initialize API service
    // final authApiService = AuthApiService(apiClient: apiClient);
    //
    // // Initialize repository
    // final authRepository = AuthRepositoryImpl(
    //   authApiService: authApiService,
    //   tokenManager: tokenManager,
    // );
    //
    // // Initialize usecases
    // final sendOtpUseCase = SendOtpUseCase(repository: authRepository);
    // final verifyOtpUseCase = VerifyOtpUseCase(repository: authRepository);
    // final logoutUseCase = LogoutUseCase(repository: authRepository);
    // final refreshTokenUseCase = RefreshTokenUseCase(repository: authRepository);
    // final getAuthStateUseCase = GetAuthStateUseCase(repository: authRepository);
    //
    // // Initialize BLoC
    // final authBloc = AuthBloc(
    //   sendOtpUseCase: sendOtpUseCase,
    //   verifyOtpUseCase: verifyOtpUseCase,
    //   logoutUseCase: logoutUseCase,
    //   refreshTokenUseCase: refreshTokenUseCase,
    //   getAuthStateUseCase: getAuthStateUseCase,
    // );
    //
    // // Register in service locator
    // sl.registerSingleton<AuthApiService>(authApiService);
    // sl.registerSingleton<AuthRepository>(authRepository);
    // sl.registerSingleton<SendOtpUseCase>(sendOtpUseCase);
    // sl.registerSingleton<VerifyOtpUseCase>(verifyOtpUseCase);
    // sl.registerSingleton<LogoutUseCase>(logoutUseCase);
    // sl.registerSingleton<RefreshTokenUseCase>(refreshTokenUseCase);
    // sl.registerSingleton<GetAuthStateUseCase>(getAuthStateUseCase);
    // sl.registerSingleton<AuthBloc>(authBloc);
  }
}

/// Practical usage example
/// Usage in bootstrap.dart:
/// 
/// ```dart
/// Future<void> bootstrap() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Setup token management first
///   await TokenManagementSetup.setupTokenManagement();
///   
///   // Then setup auth dependencies
///   TokenManagementSetup.setupAuthenticationDependencies();
///   
///   runApp(const EchoApp());
/// }
/// ```
/// 
/// Practical API call example:
/// 
/// ```dart
/// // In a usecase or service:
/// class GetUserProfileUseCase {
///   final ApiClient _apiClient;
///   
///   GetUserProfileUseCase(this._apiClient);
///   
///   Future<UserProfile> execute() async {
///     try {
///       // ApiClient automatically handles:
///       // 1. Injects Authorization header with access token
///       // 2. If 401: refreshes token
///       // 3. Retries request with new token
///       final response = await _apiClient.get(
///         '/user/profile',
///         requiresAuth: true,
///       );
///       
///       return UserProfile.fromJson(response);
///     } on UnauthorizedException {
///       // Token refresh failed, need to re-login
///       rethrow;
///     }
///   }
/// }
/// ```
