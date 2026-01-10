import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Rank Events
abstract class RankEvent extends Equatable {
  const RankEvent();

  @override
  List<Object?> get props => [];
}

class GetLeaderboardEvent extends RankEvent {
  final int page;

  const GetLeaderboardEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetUserRankEvent extends RankEvent {
  const GetUserRankEvent();
}

class RefreshLeaderboardEvent extends RankEvent {
  const RefreshLeaderboardEvent();
}

// Rank States
abstract class RankState extends Equatable {
  const RankState();

  @override
  List<Object?> get props => [];
}

class RankInitial extends RankState {
  const RankInitial();
}

class RankLoading extends RankState {
  const RankLoading();
}

class LeaderboardLoaded extends RankState {
  final List<Map<String, dynamic>> users;
  final int currentUserRank;
  final int currentUserPoints;

  const LeaderboardLoaded({
    required this.users,
    required this.currentUserRank,
    required this.currentUserPoints,
  });

  @override
  List<Object?> get props => [users, currentUserRank, currentUserPoints];
}

class RankError extends RankState {
  final String message;

  const RankError(this.message);

  @override
  List<Object?> get props => [message];
}

// Rank BLoC
class RankBloc extends Bloc<RankEvent, RankState> {
  RankBloc() : super(const RankInitial()) {
    on<GetLeaderboardEvent>(_onGetLeaderboard);
    on<GetUserRankEvent>(_onGetUserRank);
    on<RefreshLeaderboardEvent>(_onRefresh);
  }

  Future<void> _onGetLeaderboard(
      GetLeaderboardEvent event, Emitter<RankState> emit) async {
    emit(const RankLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final mockUsers = List.generate(
        10,
        (index) => {
          'rank': index + 1,
          'name': 'User ${index + 1}',
          'points': 5000 - (index * 200),
          'isCurrent': index == 2,
        },
      );

      emit(LeaderboardLoaded(
        users: mockUsers,
        currentUserRank: 3,
        currentUserPoints: 4600,
      ));
    } catch (e) {
      emit(RankError(e.toString()));
    }
  }

  Future<void> _onGetUserRank(
      GetUserRankEvent event, Emitter<RankState> emit) async {
    if (state is LeaderboardLoaded) {
      // Already have data
      return;
    }
    await _onGetLeaderboard(const GetLeaderboardEvent(), emit);
  }

  Future<void> _onRefresh(
      RefreshLeaderboardEvent event, Emitter<RankState> emit) async {
    await _onGetLeaderboard(const GetLeaderboardEvent(), emit);
  }
}
