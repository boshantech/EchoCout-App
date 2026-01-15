abstract class DriverOtpState {
  const DriverOtpState();
}

class DriverOtpInitial extends DriverOtpState {
  const DriverOtpInitial();
}

class DriverOtpLoading extends DriverOtpState {
  const DriverOtpLoading();
}

class DriverOtpSuccess extends DriverOtpState {
  final String phoneNumber;

  const DriverOtpSuccess({required this.phoneNumber});
}

class DriverOtpError extends DriverOtpState {
  final String message;

  const DriverOtpError({required this.message});
}
