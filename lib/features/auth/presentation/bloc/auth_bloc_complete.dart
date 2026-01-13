import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_role.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otpCode;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otpCode,
  });

  @override
  List<Object?> get props => [phoneNumber, otpCode];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

// Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class OtpSending extends AuthState {
  const OtpSending();
}

class OtpSent extends AuthState {
  final String phoneNumber;

  const OtpSent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpVerifying extends AuthState {
  const OtpVerifying();
}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String phoneNumber;
  final AppRole role;

  const AuthSuccess({
    required this.accessToken,
    required this.phoneNumber,
    this.role = AppRole.user,
  });

  @override
  List<Object?> get props => [accessToken, phoneNumber, role];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggingOut extends AuthState {
  const LoggingOut();
}

// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const OtpSending());
    try {
      // Call API to send OTP
      // For now, mock the call
      await Future.delayed(const Duration(seconds: 2));
      emit(OtpSent(event.phoneNumber));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(const OtpVerifying());
    try {
      // Call API to verify OTP
      // For now, mock the call
      await Future.delayed(const Duration(seconds: 2));
      
      // Determine role based on phone number
      // Driver phone: 8123456790
      final role = event.phoneNumber == '8123456790'
          ? AppRole.driver
          : AppRole.user;
      
      emit(AuthSuccess(
        accessToken: 'mock_token_123',
        phoneNumber: event.phoneNumber,
        role: role,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const LoggingOut());
    try {
      // Call API to logout
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
