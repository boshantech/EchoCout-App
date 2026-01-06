# Token Handling Test Examples

This file contains example tests for JWT token handling. To use these tests, you'll need to:

1. Add `mockito` to your `dev_dependencies` in `pubspec.yaml`:
```yaml
dev_dependencies:
  mockito: ^6.0.0
  build_runner: ^2.0.0
```

2. Run `flutter pub get`

3. Create a test file in your `test/` directory and copy the test code below

## Example Test File

```dart
// test/token_handling_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:echo_app/core/storage/token_manager.dart';
import 'package:echo_app/core/storage/secure_storage_service.dart';
import 'package:echo_app/core/storage/token_refresh_manager.dart';
import 'package:echo_app/core/storage/token_refresh_service.dart';
import 'package:echo_app/core/network/api_client.dart';
import 'package:echo_app/core/network/exceptions.dart';

// Mock classes
class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockTokenRefreshService extends Mock implements TokenRefreshService {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('TokenManager Tests', () {
    late TokenManager tokenManager;
    late MockSecureStorageService mockStorage;

    setUp(() {
      mockStorage = MockSecureStorageService();
      // Initialize tokenManager with mock storage
    });

    test('should set tokens correctly', () async {
      const accessToken = 'test_access_token';
      const refreshToken = 'test_refresh_token';

      // Test your token manager implementation
    });
  });
}
```

## Key Testing Areas

1. **Token Storage**: Verify tokens are stored securely
2. **Token Expiration**: Test token expiration detection
3. **Token Refresh**: Verify refresh mechanism works correctly
4. **Auth Headers**: Ensure tokens are included in requests
5. **Error Handling**: Test error scenarios (expired tokens, network errors, etc.)

## Integration with DioClient

The `DioClient` class handles automatic token refresh through interceptors. Test this by:

1. Creating a mock Dio instance
2. Triggering a 401 response
3. Verifying the token refresh is called
4. Verifying the original request is retried
