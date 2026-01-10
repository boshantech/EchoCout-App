import 'dart:convert';
import 'dart:async';
import 'token_manager.dart';

class TokenValidation {
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = _decodeBase64(parts[1]);
      final decodedBytes = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decodedBytes) as Map<String, dynamic>;

      final exp = json['exp'] as int?;
      if (exp == null) return true;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // Consider expired if less than 1 minute remaining
      return expirationDate.isBefore(now.add(const Duration(minutes: 1)));
    } catch (e) {
      return true;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }
    return output;
  }

  static Map<String, dynamic> decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token');

      final payload = _decodeBase64(parts[1]);
      final decodedBytes = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decodedBytes) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}

class TokenRefreshService {
  final TokenManager _tokenManager;
  Timer? _refreshTimer;

  TokenRefreshService({required TokenManager tokenManager})
      : _tokenManager = tokenManager;

  /// Start auto-refresh timer (refreshes token 5 minutes before expiration)
  void startAutoRefresh(Function onRefreshNeeded) {
    _refreshTimer?.cancel();

    _scheduleNextRefresh(onRefreshNeeded);
  }

  void _scheduleNextRefresh(Function onRefreshNeeded) async {
    final accessToken = await _tokenManager.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    try {
      final decoded = TokenValidation.decodeToken(accessToken);
      final exp = decoded['exp'] as int?;

      if (exp == null) return;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final timeUntilExpiry = expirationDate.difference(now);

      // Refresh 5 minutes before expiration
      final refreshTime = timeUntilExpiry - const Duration(minutes: 5);

      if (refreshTime.isNegative) {
        // Token expires soon, refresh immediately
        onRefreshNeeded();
      } else {
        _refreshTimer = Timer(refreshTime, () {
          onRefreshNeeded();
          _scheduleNextRefresh(onRefreshNeeded);
        });
      }
    } catch (e) {
      // If we can't decode, don't schedule refresh
    }
  }

  void stop() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> dispose() async {
    stop();
  }
}
