import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Profile Repository
abstract class ProfileRepository {
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<bool> updateUserProfile(Map<String, dynamic> profile);
  Future<void> logout();
}

class FakeProfileRepository implements ProfileRepository {
  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    await Future.delayed(MockDelays.dataFetchDelay);
    return MockData.mockUser;
  }

  @override
  Future<bool> updateUserProfile(Map<String, dynamic> profile) async {
    await Future.delayed(MockDelays.dataFetchDelay);
    if (MockDelays.shouldFail()) {
      throw Exception('Failed to update profile. Please try again.');
    }
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(MockDelays.authDelay);
  }
}
