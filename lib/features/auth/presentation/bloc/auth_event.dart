abstract class AuthEvent {
  const AuthEvent();
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent({required this.phoneNumber});
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
  });
}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent({required this.refreshToken});
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthenticationEvent extends AuthEvent {
  const CheckAuthenticationEvent();
}

class TokenExpiredEvent extends AuthEvent {
  final String message;

  const TokenExpiredEvent({
    this.message = 'Session expired. Please login again.',
  });
}

class ClearErrorEvent extends AuthEvent {
  const ClearErrorEvent();
}

