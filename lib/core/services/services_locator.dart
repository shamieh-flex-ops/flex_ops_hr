import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:flex_ops_hr/features/auth_screens/data/datasource/auth_remote_data_source.dart';
import 'package:flex_ops_hr/features/auth_screens/data/repository/auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';

final sl = GetIt.instance;

class ServicesLocator {
  Future<void> init() async {
    // Dio
    sl.registerLazySingleton<Dio>(() => Dio());

    // Data Source
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    );

    // Repository
    sl.registerLazySingleton<BaseAuthRepository>(
      () => AuthRepository(sl()),
    );

    // Use Case
    sl.registerLazySingleton(() => LoginUseCase(sl()));
        sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));


    // Provider
    sl.registerFactory(() => LoginProvider(loginUseCase: sl()));
    sl.registerLazySingleton(() => ChangePasswordProvider(changePasswordUseCase: sl()));

  }
}
