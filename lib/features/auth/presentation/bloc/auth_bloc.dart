import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/get_auth_state_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;

  AuthBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required GetAuthStateUseCase getAuthStateUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _getAuthStateUseCase = getAuthStateUseCase,
        super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<ClearErrorEvent>(_onClearError);
    on<TokenExpiredEvent>(_onTokenExpired);
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading(message: 'Sending OTP...'));

      await _sendOtpUseCase.call(
        SendOtpParams(phoneNumber: event.phoneNumber),
      );

      emit(OtpSent(phoneNumber: event.phoneNumber));
    } catch (e) {
      emit(AuthError(
        message: _getErrorMessage(e),
        errorCode: _getErrorCode(e),
      ));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading(message: 'Verifying OTP...'));

      final userEntity = await _verifyOtpUseCase.call(
        VerifyOtpParams(
          phoneNumber: event.phoneNumber,
          otp: event.otp,
        ),
      );

      emit(Authenticated(
        userId: userEntity.id,
        phoneNumber: userEntity.phoneNumber,
        name: userEntity.name,
        email: userEntity.email,
        isOnboardingComplete: userEntity.isOnboardingComplete,
      ));
    } catch (e) {
      emit(AuthError(
        message: _getErrorMessage(e),
        errorCode: _getErrorCode(e),
      ));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading(message: 'Logging out...'));

      await _logoutUseCase.call(NoParams());

      emit(const LoggedOut());
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(
        message: _getErrorMessage(e),
        errorCode: _getErrorCode(e),
      ));
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const TokenRefreshing());

      await _refreshTokenUseCase.call(
        RefreshTokenParams(refreshToken: event.refreshToken),
      );

      emit(const TokenRefreshed());
      add(const CheckAuthenticationEvent());
    } catch (e) {
      emit(TokenExpired(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      final isAuthenticated = await _getAuthStateUseCase.call(NoParams());

      if (isAuthenticated) {
        emit(const Authenticated(
          userId: '',
          phoneNumber: '',
        ));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(
        message: 'Failed to check authentication status',
        errorCode: 'CHECK_AUTH_ERROR',
      ));
    }
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthError) {
      emit(const AuthInitial());
    }
  }

  Future<void> _onTokenExpired(
    TokenExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logoutUseCase.call(NoParams());
    } catch (_) {
      // Ignore error during logout
    }
    emit(TokenExpired(message: event.message));
    emit(const Unauthenticated());
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }

  String _getErrorCode(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('network')) {
      return 'NETWORK_ERROR';
    }
    if (errorStr.contains('unauthorized') || errorStr.contains('401')) {
      return 'UNAUTHORIZED';
    }
    if (errorStr.contains('server') || errorStr.contains('500')) {
      return 'SERVER_ERROR';
    }
    if (errorStr.contains('validation')) {
      return 'VALIDATION_ERROR';
    }
    return 'UNKNOWN_ERROR';
  }
}
