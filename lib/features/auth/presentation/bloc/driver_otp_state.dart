abstract class DriverOtpState {
  const DriverOtpState();
}

class DriverOtpInitial extends DriverOtpState {
  const DriverOtpInitial();
}

class DriverOtpReady extends DriverOtpState {
  final String phoneNumber;
  final int timerSeconds;

  const DriverOtpReady({
    required this.phoneNumber,
    this.timerSeconds = 50,
  });
}

class DriverOtpVerifying extends DriverOtpState {
  const DriverOtpVerifying();
}

class DriverOtpVerified extends DriverOtpState {
  final String phoneNumber;

  const DriverOtpVerified({required this.phoneNumber});
}

class DriverOtpFailed extends DriverOtpState {
  final String message;

  const DriverOtpFailed({required this.message});
}

class DriverOtpTimerUpdate extends DriverOtpState {
  final int remainingSeconds;

  const DriverOtpTimerUpdate({required this.remainingSeconds});
}

class DriverOtpExpired extends DriverOtpState {
  final String message;

  const DriverOtpExpired({
    this.message = 'OTP expired. Please request a new one.',
  });
}
