import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Echo Repository
abstract class EchoRepository {
  Future<Map<String, dynamic>> getEchoSummary();
  Future<List<Map<String, dynamic>>> getPendingPickups();
  Future<bool> schedulePickup(List<String> itemIds);
}

class FakeEchoRepository implements EchoRepository {
  @override
  Future<Map<String, dynamic>> getEchoSummary() async {
    await Future.delayed(MockDelays.dataFetchDelay);
    return MockData.echoSummary;
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingPickups() async {
    await Future.delayed(MockDelays.dataFetchDelay);
    return MockData.pickups.where((p) => p['status'] == 'pending').toList();
  }

  @override
  Future<bool> schedulePickup(List<String> itemIds) async {
    await Future.delayed(MockDelays.uploadDelay);
    if (MockDelays.shouldFail()) {
      throw Exception('Failed to schedule pickup. Please try again.');
    }
    return true;
  }
}
