class ApiEndpoints {
  // Base URL - replace with your actual backend URL
  static const String baseUrl = 'https://api.example.com/api/v1';

  // Auth Endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // Home Endpoints
  static const String wasteList = '/waste/list';
  static const String wasteCategories = '/waste/categories';
  static const String estimatePrice = '/waste/estimate-price';

  // Echo Endpoints
  static const String echoSummary = '/echo/summary';
  static const String echoPendingPickups = '/echo/pending-pickups';
  static const String sellWaste = '/echo/sell';

  // Scanner Endpoints
  static const String scanEstimate = '/scan/estimate';
  static const String uploadWastePhoto = '/scan/upload';

  // Rank Endpoints
  static const String leaderboard = '/rank/leaderboard';
  static const String userRank = '/rank/user-rank';

  // Profile Endpoints
  static const String userProfile = '/profile/me';
  static const String updateProfile = '/profile/update';
  static const String userStats = '/profile/stats';
}
