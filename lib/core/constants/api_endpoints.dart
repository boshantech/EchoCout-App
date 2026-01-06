class ApiEndpoints {
  static const String baseUrl = 'https://api.echocout.com/v1';

  // Auth endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile';

  // Waste endpoints
  static const String classifyWaste = '/waste/classify';
  static const String getWasteHistory = '/waste/history';

  // Pickup endpoints
  static const String schedulePickup = '/pickup/schedule';
  static const String getPickupHistory = '/pickup/history';
  static const String cancelPickup = '/pickup/{id}/cancel';

  // Rewards endpoints
  static const String getRewards = '/rewards';
  static const String redeemReward = '/rewards/{id}/redeem';
}
