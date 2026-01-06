class ApiEndpoints {
  // Auth endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  
  // User endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile';
  
  // Waste endpoints
  static const String scanWaste = '/waste/scan';
  static const String getWasteCategories = '/waste/categories';
  
  // Pickup endpoints
  static const String schedulePickup = '/pickup/schedule';
  static const String getPickupHistory = '/pickup/history';
  
  // Rewards endpoints
  static const String getRewardsBalance = '/rewards/balance';
  static const String redeemRewards = '/rewards/redeem';
}
