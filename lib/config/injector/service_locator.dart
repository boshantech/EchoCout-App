import 'package:get_it/get_it.dart';

// Core
import '../../core/network/dio_client.dart';
import '../../core/network/token_manager.dart';

// Driver Auth Feature
import '../../features/driver_auth/data/datasources/driver_auth_local_datasource.dart';
import '../../features/driver_auth/data/repositories/driver_auth_repository_impl.dart';
import '../../features/driver_auth/domain/repositories/driver_auth_repository.dart';
import '../../features/driver_auth/presentation/bloc/driver_auth_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core Services
  _setupCore();
  
  // Driver Auth Feature
  _setupDriverAuth();
  
  // Auth Feature
  _setupAuth();
  
  // Home Feature
  _setupHome();
  
  // Echo Feature
  _setupEcho();
  
  // Scanner Feature
  _setupScanner();
  
  // Rank Feature
  _setupRank();
  
  // Profile Feature
  _setupProfile();
}

void _setupCore() {
  // Network
  getIt.registerSingleton<DioClient>(DioClient());
  getIt.registerSingleton<TokenManager>(TokenManager());
}

void _setupDriverAuth() {
  // Data source
  getIt.registerSingleton<DriverAuthLocalDataSource>(
    DriverAuthLocalDataSource(),
  );
  
  // Repository
  getIt.registerSingleton<DriverAuthRepository>(
    DriverAuthRepositoryImpl(
      localDataSource: getIt<DriverAuthLocalDataSource>(),
    ),
  );
  
  // Bloc
  getIt.registerSingleton<DriverAuthBloc>(
    DriverAuthBloc(
      repository: getIt<DriverAuthRepository>(),
    ),
  );
}

void _setupAuth() {
  // TODO: Register Auth Feature dependencies
}

void _setupHome() {
  // TODO: Register Home Feature dependencies
}

void _setupEcho() {
  // TODO: Register Echo Feature dependencies
}

void _setupScanner() {
  // TODO: Register Scanner Feature dependencies
}

void _setupRank() {
  // TODO: Register Rank Feature dependencies
}

void _setupProfile() {
  // TODO: Register Profile Feature dependencies
}
