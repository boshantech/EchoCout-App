import '../datasources/driver_auth_local_datasource.dart';
import '../../domain/repositories/driver_auth_repository.dart';

class DriverAuthRepositoryImpl implements DriverAuthRepository {
  final DriverAuthLocalDataSource localDataSource;

  DriverAuthRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> validatePhoneNumber(String phoneNumber) {
    return localDataSource.validatePhoneNumber(phoneNumber);
  }

  @override
  Future<bool> sendOtp(String phoneNumber) {
    return localDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) {
    return localDataSource.verifyOtp(phoneNumber, otp);
  }

  @override
  Future<String?> completeLogin(String phoneNumber) {
    return localDataSource.completeLogin(phoneNumber);
  }

  @override
  Future<void> logout() async {
    // Clear any stored auth data if needed
  }
}
