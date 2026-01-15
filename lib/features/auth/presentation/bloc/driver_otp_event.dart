abstract class DriverOtpEvent {
  const DriverOtpEvent();
}

class VerifyDriverOtp extends DriverOtpEvent {
  final String otp;

  const VerifyDriverOtp({required this.otp});
}

class ResetDriverOtp extends DriverOtpEvent {
  const ResetDriverOtp();
}

