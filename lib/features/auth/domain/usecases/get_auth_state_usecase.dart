import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetAuthStateUseCase extends UseCase<bool, NoParams> {
  final AuthRepository _repository;

  GetAuthStateUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  Future<bool> call(NoParams params) async {
    return await _repository.isAuthenticated();
  }
}
