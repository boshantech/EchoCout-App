import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Rank Repository
abstract class RankRepository {
  Future<List<Map<String, dynamic>>> getLeaderboard();
  Future<Map<String, dynamic>> getUserRank(String userId);
}

class FakeRankRepository implements RankRepository {
  @override
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    await Future.delayed(MockDelays.dataFetchDelay);
    return MockData.leaderboard;
  }

  @override
  Future<Map<String, dynamic>> getUserRank(String userId) async {
    await Future.delayed(MockDelays.dataFetchDelay);
    
    final user = MockData.leaderboard.firstWhere(
      (u) => u['userId'] == userId,
      orElse: () => MockData.leaderboard.first,
    );
    
    return user;
  }
}
