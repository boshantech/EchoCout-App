abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {
  List<Object?> get props => [];
}
