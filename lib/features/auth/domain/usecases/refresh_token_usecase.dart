import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenParams {
  final String refreshToken;

  RefreshTokenParams({required this.refreshToken});
}

class RefreshTokenUseCase extends UseCase<void, RefreshTokenParams> {
  final AuthRepository _repository;

  RefreshTokenUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  Future<void> call(RefreshTokenParams params) async {
    return await _repository.refreshAccessToken(refreshToken: params.refreshToken);
  }
}
