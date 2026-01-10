import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final int rank;
  final String userId;
  final String userName;
  final String? profileImageUrl;
  final int points;
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.rank,
    required this.userId,
    required this.userName,
    this.profileImageUrl,
    required this.points,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props =>
      [rank, userId, userName, profileImageUrl, points, isCurrentUser];
}

class UserRankInfo extends Equatable {
  final int currentRank;
  final int totalUsers;
  final int points;
  final int pointsToNextRank;

  const UserRankInfo({
    required this.currentRank,
    required this.totalUsers,
    required this.points,
    required this.pointsToNextRank,
  });

  @override
  List<Object?> get props =>
      [currentRank, totalUsers, points, pointsToNextRank];
}
