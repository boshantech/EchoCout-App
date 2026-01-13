import 'package:equatable/equatable.dart';

abstract class DriverAuthEvent extends Equatable {
  const DriverAuthEvent();

  @override
  List<Object?> get props => [];
}

/// User enters phone number and requests OTP
class RequestOtpEvent extends DriverAuthEvent {
  final String phoneNumber;

  const RequestOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// User enters OTP
class VerifyOtpEvent extends DriverAuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp];
}

/// Reset auth state
class ResetAuthEvent extends DriverAuthEvent {
  const ResetAuthEvent();
}

/// Logout
class LogoutEvent extends DriverAuthEvent {
  const LogoutEvent();
}

/// Clear error messages
class ClearErrorEvent extends DriverAuthEvent {
  const ClearErrorEvent();
}
