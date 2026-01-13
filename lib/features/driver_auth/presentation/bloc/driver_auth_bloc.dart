import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/driver_auth_entity.dart';
import '../../domain/repositories/driver_auth_repository.dart';
import 'driver_auth_event.dart';
import 'driver_auth_state.dart';

class DriverAuthBloc extends Bloc<DriverAuthEvent, DriverAuthState> {
  final DriverAuthRepository repository;

  DriverAuthBloc({required this.repository})
      : super(const DriverAuthInitial()) {
    on<RequestOtpEvent>(_onRequestOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetAuthEvent>(_onReset);
    on<LogoutEvent>(_onLogout);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Handle phone number validation and OTP request
  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<DriverAuthState> emit,
  ) async {
    final phoneNumber = event.phoneNumber.trim();

    // Validate phone format
    if (phoneNumber.length != 10) {
      emit(PhoneNumberErrorState(
        error: 'Phone number must be exactly 10 digits',
        phoneNumber: phoneNumber,
      ));
      return;
    }

    // Check if phone is numeric
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      emit(PhoneNumberErrorState(
        error: 'Phone number must contain only digits',
        phoneNumber: phoneNumber,
      ));
      return;
    }

    // Start validation
    emit(PhoneNumberValidatingState(phoneNumber));

    try {
      // Validate phone number (check if authorized)
      final isAuthorized = await repository.validatePhoneNumber(phoneNumber);

      if (!isAuthorized) {
        emit(PhoneNumberErrorState(
          error: 'Unauthorized Driver. Please contact support.',
          phoneNumber: phoneNumber,
        ));
        return;
      }

      // Send OTP
      final otpSent = await repository.sendOtp(phoneNumber);

      if (otpSent) {
        final maskedPhone = DriverAuthEntity.maskPhoneNumber(phoneNumber);
        emit(OtpWaitingState(
          phoneNumber: phoneNumber,
          maskedPhoneNumber: maskedPhone,
        ));
      } else {
        emit(PhoneNumberErrorState(
          error: 'Failed to send OTP. Please try again.',
          phoneNumber: phoneNumber,
        ));
      }
    } catch (e) {
      emit(PhoneNumberErrorState(
        error: 'An error occurred. Please try again.',
        phoneNumber: phoneNumber,
      ));
    }
  }

  /// Handle OTP verification
  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<DriverAuthState> emit,
  ) async {
    final phoneNumber = event.phoneNumber.trim();
    final otp = event.otp.trim();
    final maskedPhone = DriverAuthEntity.maskPhoneNumber(phoneNumber);

    // Validate OTP format
    if (otp.length != 4) {
      emit(OtpErrorState(
        error: 'OTP must be exactly 4 digits',
        phoneNumber: phoneNumber,
        maskedPhoneNumber: maskedPhone,
      ));
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      emit(OtpErrorState(
        error: 'OTP must contain only digits',
        phoneNumber: phoneNumber,
        maskedPhoneNumber: maskedPhone,
      ));
      return;
    }

    // Start verification
    emit(OtpVerifyingState(
      phoneNumber: phoneNumber,
      maskedPhoneNumber: maskedPhone,
      otp: otp,
    ));

    try {
      // Verify OTP
      final isValid = await repository.verifyOtp(phoneNumber, otp);

      if (!isValid) {
        emit(OtpErrorState(
          error: 'Invalid OTP. Please try again.',
          phoneNumber: phoneNumber,
          maskedPhoneNumber: maskedPhone,
        ));
        return;
      }

      // Complete login
      final authToken = await repository.completeLogin(phoneNumber);

      if (authToken != null) {
        final driverAuth = DriverAuthEntity(
          phoneNumber: phoneNumber,
          maskedPhoneNumber: maskedPhone,
          isPhoneVerified: true,
          isOtpVerified: true,
          driverId: 'driver_$phoneNumber',
          authToken: authToken,
        );

        emit(DriverAuthenticatedState(driverAuth));
      } else {
        emit(OtpErrorState(
          error: 'Login failed. Please try again.',
          phoneNumber: phoneNumber,
          maskedPhoneNumber: maskedPhone,
        ));
      }
    } catch (e) {
      emit(OtpErrorState(
        error: 'An error occurred. Please try again.',
        phoneNumber: phoneNumber,
        maskedPhoneNumber: maskedPhone,
      ));
    }
  }

  /// Reset to initial state
  Future<void> _onReset(
    ResetAuthEvent event,
    Emitter<DriverAuthState> emit,
  ) async {
    emit(const DriverAuthInitial());
  }

  /// Handle logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<DriverAuthState> emit,
  ) async {
    await repository.logout();
    emit(const DriverUnauthenticatedState());
  }

  /// Clear error message
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<DriverAuthState> emit,
  ) async {
    if (state is PhoneNumberErrorState) {
      emit(const PhoneNumberWaitingState());
    } else if (state is OtpErrorState) {
      final otpErrorState = state as OtpErrorState;
      emit(OtpWaitingState(
        phoneNumber: otpErrorState.phoneNumber,
        maskedPhoneNumber: otpErrorState.maskedPhoneNumber,
      ));
    }
  }
}
