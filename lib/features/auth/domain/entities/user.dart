import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final int totalPoints;
  final double totalEarnings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImageUrl,
    this.totalPoints = 0,
    this.totalEarnings = 0.0,
    required this.createdAt,
    this.updatedAt,
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
    createdAt,
    updatedAt,
  ];
}
