class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String accessToken;
  final String refreshToken;
  final bool isOnboardingComplete;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.isOnboardingComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      isOnboardingComplete: json['isOnboardingComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'isOnboardingComplete': isOnboardingComplete,
    };
  }
}
