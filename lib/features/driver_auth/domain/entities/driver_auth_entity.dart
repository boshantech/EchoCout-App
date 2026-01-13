import 'package:equatable/equatable.dart';

class DriverAuthEntity extends Equatable {
  final String phoneNumber;
  final String maskedPhoneNumber;
  final bool isPhoneVerified;
  final bool isOtpVerified;
  final String? driverId;
  final String? authToken;

  const DriverAuthEntity({
    required this.phoneNumber,
    required this.maskedPhoneNumber,
    this.isPhoneVerified = false,
    this.isOtpVerified = false,
    this.driverId,
    this.authToken,
  });

  /// Mask phone number for display (e.g., 8123456790 -> 8123****90)
  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) return phoneNumber;
    return phoneNumber.substring(0, 4) + '****' + phoneNumber.substring(8);
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        maskedPhoneNumber,
        isPhoneVerified,
        isOtpVerified,
        driverId,
        authToken,
      ];
}
