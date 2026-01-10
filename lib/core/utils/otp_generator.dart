import 'dart:math';

/// Utility class for OTP generation
class OtpGenerator {
  static final Random _random = Random.secure();

  /// Generate a random numeric OTP
  /// 
  /// [length] - OTP digit length (default: 4, range: 4-6)
  /// 
  /// Returns a numeric string OTP
  static String generateOtp({int length = 4}) {
    if (length < 4 || length > 6) {
      throw ArgumentError('OTP length must be between 4 and 6 digits');
    }

    final minValue = pow(10, length - 1).toInt();
    final maxValue = pow(10, length).toInt() - 1;

    final otp = minValue + _random.nextInt(maxValue - minValue + 1);
    return otp.toString().padLeft(length, '0');
  }

  /// Generate a 4-digit OTP (most common)
  static String generate4DigitOtp() => generateOtp(length: 4);

  /// Generate a 6-digit OTP (more secure)
  static String generate6DigitOtp() => generateOtp(length: 6);

  /// Verify if OTP matches
  static bool verifyOtp(String? generatedOtp, String? inputOtp) {
    if (generatedOtp == null || inputOtp == null) return false;
    return generatedOtp == inputOtp.trim();
  }

  /// Check if string is a valid numeric OTP
  static bool isValidOtp(String value, {int expectedLength = 4}) {
    if (value.isEmpty) return false;
    if (!RegExp(r'^\d+$').hasMatch(value)) return false;
    if (value.length != expectedLength) return false;
    return true;
  }
}
