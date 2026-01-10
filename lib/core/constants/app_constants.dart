class AppConstants {
  // App Config
  static const String appName = 'EchoCout';
  static const String appVersion = '1.0.0';

  // Network Timeouts
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // Storage Keys
  static const String accessTokenKey = 'echo_access_token';
  static const String refreshTokenKey = 'echo_refresh_token';
  static const String userIdKey = 'echo_user_id';
  static const String phoneNumberKey = 'echo_phone_number';
  static const String userDataKey = 'echo_user_data';
  static const String isLoggedInKey = 'echo_is_logged_in';

  // API Config
  static const String apiBaseUrl = 'https://api.example.com/api/v1';
  static const String bearerPrefix = 'Bearer ';

  // OTP Config
  static const int otpLength = 6;
  static const int otpExpirySeconds = 600; // 10 minutes

  // Waste Categories
  static const List<String> wasteCategories = [
    'All',
    'Plastic',
    'Glass',
    'Electronics',
    'Metal',
    'Paper',
    'Paul'
  ];

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 0;

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 30);

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
}
