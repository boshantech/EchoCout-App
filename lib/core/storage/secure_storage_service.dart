/// Interface for secure storage operations
/// Abstracts platform-specific secure storage implementations
abstract class SecureStorageService {
  /// Read a value from secure storage
  Future<String?> read(String key);

  /// Write a value to secure storage
  Future<void> write(String key, String value);

  /// Delete a value from secure storage
  Future<void> delete(String key);

  /// Clear all values from secure storage
  Future<void> clear();
}

/// Implementation using in-memory storage (for testing/development)
/// In production, use flutter_secure_storage
class InMemorySecureStorageService implements SecureStorageService {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}
