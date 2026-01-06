abstract class AuthRepository {
  Future<void> sendOtp({required String phoneNumber});

  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  });

  Future<void> refreshAccessToken({required String refreshToken});

  Future<void> logout();

  Future<bool> isAuthenticated();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();
}
