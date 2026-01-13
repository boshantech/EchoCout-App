abstract class DriverAuthRepository {
  /// Validate phone number and check if driver is authorized
  /// Returns true if phone is valid and authorized
  Future<bool> validatePhoneNumber(String phoneNumber);

  /// Send OTP to the phone number (mock - no actual sending)
  /// Returns true if successful
  Future<bool> sendOtp(String phoneNumber);

  /// Verify OTP
  /// Returns true if OTP is correct
  Future<bool> verifyOtp(String phoneNumber, String otp);

  /// Complete login and get auth token
  Future<String?> completeLogin(String phoneNumber);

  /// Logout
  Future<void> logout();
}
