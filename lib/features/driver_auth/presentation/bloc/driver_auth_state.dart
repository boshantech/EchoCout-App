import 'package:equatable/equatable.dart';
import '../../domain/entities/driver_auth_entity.dart';

abstract class DriverAuthState extends Equatable {
  const DriverAuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DriverAuthInitial extends DriverAuthState {
  const DriverAuthInitial();
}

/// Waiting for phone number input
class PhoneNumberWaitingState extends DriverAuthState {
  const PhoneNumberWaitingState();
}

/// Validating phone number
class PhoneNumberValidatingState extends DriverAuthState {
  final String phoneNumber;

  const PhoneNumberValidatingState(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Phone number is invalid or unauthorized
class PhoneNumberErrorState extends DriverAuthState {
  final String error;
  final String? phoneNumber;

  const PhoneNumberErrorState({
    required this.error,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [error, phoneNumber];
}

/// OTP has been sent and waiting for user input
class OtpWaitingState extends DriverAuthState {
  final String phoneNumber;
  final String maskedPhoneNumber;

  const OtpWaitingState({
    required this.phoneNumber,
    required this.maskedPhoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber, maskedPhoneNumber];
}

/// Verifying OTP
class OtpVerifyingState extends DriverAuthState {
  final String phoneNumber;
  final String maskedPhoneNumber;
  final String otp;

  const OtpVerifyingState({
    required this.phoneNumber,
    required this.maskedPhoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, maskedPhoneNumber, otp];
}

/// OTP is invalid
class OtpErrorState extends DriverAuthState {
  final String error;
  final String phoneNumber;
  final String maskedPhoneNumber;

  const OtpErrorState({
    required this.error,
    required this.phoneNumber,
    required this.maskedPhoneNumber,
  });

  @override
  List<Object?> get props => [error, phoneNumber, maskedPhoneNumber];
}

/// Authentication successful
class DriverAuthenticatedState extends DriverAuthState {
  final DriverAuthEntity driverAuth;

  const DriverAuthenticatedState(this.driverAuth);

  @override
  List<Object?> get props => [driverAuth];
}

/// User has logged out
class DriverUnauthenticatedState extends DriverAuthState {
  const DriverUnauthenticatedState();
}
