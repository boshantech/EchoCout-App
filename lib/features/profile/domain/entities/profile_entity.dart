import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final int totalPoints;
  final double totalEarnings;
  final int totalItemsSold;
  final DateTime memberSince;

  const UserProfile({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImageUrl,
    required this.totalPoints,
    required this.totalEarnings,
    required this.totalItemsSold,
    required this.memberSince,
  });

  @override
  List<Object?> get props => [
    id,
    phoneNumber,
    name,
    email,
    profileImageUrl,
    totalPoints,
    totalEarnings,
    totalItemsSold,
    memberSince,
  ];
}
