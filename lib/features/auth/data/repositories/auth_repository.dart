import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Auth Repository for testing without backend
abstract class AuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp);
  Future<void> logout();
  Future<Map<String, dynamic>?> getStoredSession();
  Future<bool> isAuthenticated();
}

class FakeAuthRepository implements AuthRepository {
  final SharedPreferences _prefs;
  
  FakeAuthRepository(this._prefs);

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    await Future.delayed(MockDelays.authDelay);
    if (MockDelays.shouldFail()) {
      throw Exception('Failed to send OTP. Please try again.');
    }
    return true;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(MockDelays.authDelay);
    
    // Mock: accept OTP 1234 for testing
    if (otp != '1234') {
      throw Exception('Invalid OTP. Use 1234 for testing.');
    }

    final session = {
      'accessToken': MockData.mockAccessToken,
      'refreshToken': MockData.mockRefreshToken,
      'phoneNumber': phoneNumber,
      'user': {...MockData.mockUser},
      'loginTime': DateTime.now().toIso8601String(),
    };

    // Save to shared preferences
    await _prefs.setString('auth_session', _mapToJson(session));
    await _prefs.setBool('is_authenticated', true);

    return session;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(MockDelays.authDelay);
    await _prefs.remove('auth_session');
    await _prefs.setBool('is_authenticated', false);
  }

  @override
  Future<Map<String, dynamic>?> getStoredSession() async {
    final sessionJson = _prefs.getString('auth_session');
    if (sessionJson == null) return null;
    return _jsonToMap(sessionJson);
  }

  @override
  Future<bool> isAuthenticated() async {
    return _prefs.getBool('is_authenticated') ?? false;
  }

  String _mapToJson(Map<String, dynamic> map) {
    // Simple JSON encoding for mock data
    return map.toString();
  }

  Map<String, dynamic> _jsonToMap(String json) {
    // Simple JSON decoding for mock data
    return {...MockData.mockUser};
  }
}
