import 'package:flutter_bloc/flutter_bloc.dart';
import 'driver_otp_event.dart';
import 'driver_otp_state.dart';

class DriverOtpBloc extends Bloc<DriverOtpEvent, DriverOtpState> {
  DriverOtpBloc() : super(const DriverOtpInitial()) {
    on<VerifyDriverOtp>(_onVerifyDriverOtp);
    on<ResetDriverOtp>(_onResetDriverOtp);
  }

  Future<void> _onVerifyDriverOtp(
    VerifyDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    emit(const DriverOtpLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock verification: accept OTP 1234
    if (event.otp == '1234') {
      emit(DriverOtpSuccess(phoneNumber: event.otp));
    } else {
      emit(const DriverOtpError(
        message: 'Invalid OTP. Please try again.',
      ));
    }
  }

  Future<void> _onResetDriverOtp(
    ResetDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    emit(const DriverOtpInitial());
  }
}

