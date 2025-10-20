import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/secure_storage.dart';
import 'core/storage/local_storage.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/company_setup_repository.dart';
import 'data/repositories/application_repository.dart';
import 'data/repositories/document_repository.dart';
import 'presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      dioClient: sl(),
      secureStorage: sl(),
      localAuth: sl(),
    ),
  );
  
  sl.registerLazySingleton<CompanySetupRepository>(
    () => CompanySetupRepository(dioClient: sl()),
  );
  
  sl.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepository(dioClient: sl()),
  );
  
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepository(dioClient: sl()),
  );

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => LocalAuthentication());
  sl.registerLazySingleton(() => Connectivity());
}