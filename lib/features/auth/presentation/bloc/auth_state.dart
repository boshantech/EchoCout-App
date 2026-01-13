import '../../../../core/enums/app_role.dart';

abstract class AuthState {
  const AuthState();
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading state
class AuthLoading extends AuthState {
  final String message;

  const AuthLoading({this.message = 'Processing...'});
}

// OTP sent state
class OtpSent extends AuthState {
  final String phoneNumber;
  final int expiresIn;

  const OtpSent({
    required this.phoneNumber,
    this.expiresIn = 600,
  });
}

// OTP verified state
class OtpVerified extends AuthState {
  final String phoneNumber;

  const OtpVerified({required this.phoneNumber});
}

// Authenticated state
class Authenticated extends AuthState {
  final String userId;
  final String phoneNumber;
  final String? name;
  final String? email;
  final bool isOnboardingComplete;
  final AppRole role;

  const Authenticated({
    required this.userId,
    required this.phoneNumber,
    this.name,
    this.email,
    this.isOnboardingComplete = false,
    this.role = AppRole.user,
  });
}

// Unauthenticated state
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// Error state
class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });
}

// Token expired state
class TokenExpired extends AuthState {
  final String message;

  const TokenExpired({
    this.message = 'Session expired. Please login again.',
  });
}

// Logged out state
class LoggedOut extends AuthState {
  const LoggedOut();
}

// Token refreshing state
class TokenRefreshing extends AuthState {
  const TokenRefreshing();
}

// Token refreshed state
class TokenRefreshed extends AuthState {
  const TokenRefreshed();
}
