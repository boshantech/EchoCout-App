import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtpParams {
  final String phoneNumber;

  SendOtpParams({required this.phoneNumber});
}

class SendOtpUseCase extends UseCase<void, SendOtpParams> {
  final AuthRepository _repository;

  SendOtpUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  Future<void> call(SendOtpParams params) async {
    return await _repository.sendOtp(phoneNumber: params.phoneNumber);
  }
}
