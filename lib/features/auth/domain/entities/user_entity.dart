class UserEntity {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final bool isOnboardingComplete;

  UserEntity({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.isOnboardingComplete,
  });
}
