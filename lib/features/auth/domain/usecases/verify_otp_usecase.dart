import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams {
  final String phoneNumber;
  final String otp;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
  });
}

class VerifyOtpUseCase extends UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  Future<UserEntity> call(VerifyOtpParams params) async {
    final result = await _repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      otpCode: params.otp,
    );

    return UserEntity(
      id: result['user']['id'],
      phoneNumber: result['user']['phoneNumber'],
      name: result['user']['name'],
      email: result['user']['email'],
      isOnboardingComplete: result['user']['isOnboardingComplete'] ?? false,
    );
  }
}
