import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'driver_otp_event.dart';
import 'driver_otp_state.dart';

class DriverOtpBloc extends Bloc<DriverOtpEvent, DriverOtpState> {
  Timer? _timer;
  int _timerSeconds = 50;
  late String _phoneNumber;

  DriverOtpBloc() : super(const DriverOtpInitial()) {
    on<InitializeDriverOtp>(_onInitializeDriverOtp);
    on<VerifyDriverOtp>(_onVerifyDriverOtp);
    on<ResendDriverOtp>(_onResendDriverOtp);
    on<ResetDriverOtp>(_onResetDriverOtp);
  }

  // Mask phone number: +91 8123 •••• 90
  String _maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(0, 4);
    final last = phone.substring(phone.length - 2);
    return '+91 $visible •••• $last';
  }

  Future<void> _onInitializeDriverOtp(
    InitializeDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    _phoneNumber = event.phoneNumber;
    _timerSeconds = 50;
    emit(DriverOtpReady(
      phoneNumber: _maskPhoneNumber(event.phoneNumber),
      timerSeconds: _timerSeconds,
    ));
    _startTimer(emit);
  }

  Future<void> _onVerifyDriverOtp(
    VerifyDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    emit(const DriverOtpVerifying());
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock verification: accept OTP 1234
    if (event.otp == '1234') {
      _timer?.cancel();
      emit(DriverOtpVerified(phoneNumber: _phoneNumber));
    } else {
      emit(const DriverOtpFailed(message: 'Invalid OTP. Please try again.'));
      // Reset to ready state after error
      await Future.delayed(const Duration(milliseconds: 800));
      if (!isClosed) {
        emit(DriverOtpReady(
          phoneNumber: _maskPhoneNumber(_phoneNumber),
          timerSeconds: _timerSeconds,
        ));
      }
    }
  }

  Future<void> _onResendDriverOtp(
    ResendDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    _timerSeconds = 50;
    emit(DriverOtpReady(
      phoneNumber: _maskPhoneNumber(_phoneNumber),
      timerSeconds: _timerSeconds,
    ));
    _startTimer(emit);
  }

  Future<void> _onResetDriverOtp(
    ResetDriverOtp event,
    Emitter<DriverOtpState> emit,
  ) async {
    _timer?.cancel();
    emit(const DriverOtpInitial());
  }

  void _startTimer(Emitter<DriverOtpState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerSeconds--;
      
      if (_timerSeconds <= 0) {
        _timer?.cancel();
        if (!isClosed) {
          emit(DriverOtpExpired());
        }
      } else {
        if (!isClosed) {
          emit(DriverOtpTimerUpdate(remainingSeconds: _timerSeconds));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
