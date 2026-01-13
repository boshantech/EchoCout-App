/// Mock datasource for driver authentication
/// No backend - all data is static/mock
class DriverAuthLocalDataSource {
  // Static authorized driver
  static const String allowedDriverPhone = '8123456790';
  static const String staticOtp = '1234';
  static const String mockAuthToken = 'mock_token_' + allowedDriverPhone;

  /// Validate if phone number is authorized
  Future<bool> validatePhoneNumber(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return phoneNumber == allowedDriverPhone;
  }

  /// Send OTP (mock - no actual sending)
  Future<bool> sendOtp(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Only send OTP if phone is authorized
    return phoneNumber == allowedDriverPhone;
  }

  /// Verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Only verify if phone is authorized and OTP is correct
    return phoneNumber == allowedDriverPhone && otp == staticOtp;
  }

  /// Complete login and return auth token
  Future<String?> completeLogin(String phoneNumber) async {
    if (phoneNumber == allowedDriverPhone) {
      return mockAuthToken;
    }
    return null;
  }
}
