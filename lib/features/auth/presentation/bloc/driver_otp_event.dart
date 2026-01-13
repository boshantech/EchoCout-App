abstract class DriverOtpEvent {
  const DriverOtpEvent();
}

class InitializeDriverOtp extends DriverOtpEvent {
  final String phoneNumber;

  const InitializeDriverOtp({required this.phoneNumber});
}

class VerifyDriverOtp extends DriverOtpEvent {
  final String otp;

  const VerifyDriverOtp({required this.otp});
}

class ResendDriverOtp extends DriverOtpEvent {
  const ResendDriverOtp();
}

class ResetDriverOtp extends DriverOtpEvent {
  const ResetDriverOtp();
}
