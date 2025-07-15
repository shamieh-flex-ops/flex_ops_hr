import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/payslips/data/datasources/payslip_remote_data_source.dart';
import 'package:flex_ops_hr/features/payslips/data/repositories/payslip_repository_impl.dart';
import 'package:flex_ops_hr/features/payslips/domain/repositories/base_payslip_repository.dart';
import 'package:flex_ops_hr/features/payslips/domain/usecases/get_payslips_usecase.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';
import 'package:flex_ops_hr/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:flex_ops_hr/features/auth_screens/data/datasource/auth_remote_data_source.dart';
import 'package:flex_ops_hr/features/auth_screens/data/repository/auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';
import 'package:flex_ops_hr/features/profile/data/repository/profile_repository_impl.dart';
import 'package:flex_ops_hr/features/profile/domain/repository/base_profile_repository.dart';
import 'package:flex_ops_hr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:flex_ops_hr/features/profile/presentation/controller/profile_provider.dart';

final sl = GetIt.instance;

class ServicesLocator {
  Future<void> init() async {
    // Dio
    sl.registerLazySingleton<Dio>(() => Dio());

    // Auth - Data Source
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    );

    // Auth - Repository
    sl.registerLazySingleton<BaseAuthRepository>(
      () => AuthRepository(sl()),
    );

    // Auth - Use Cases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

    // Auth - Providers
    sl.registerFactory(() => LoginProvider(loginUseCase: sl()));
    sl.registerLazySingleton(
        () => ChangePasswordProvider(changePasswordUseCase: sl()));

    // Profile - Data Source
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    );

    // Profile - Repository
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    );

    // Profile - Use Case
    sl.registerLazySingleton(() => GetUserProfile(sl()));

    // Profile - Provider
    sl.registerFactory(() => ProfileProvider(getUserProfileUseCase: sl()));


    // Payslips - Data Source
sl.registerLazySingleton<PayslipRemoteDataSource>(
  () => PayslipRemoteDataSourceImpl(dio: sl()),
);

// Payslips - Repository
sl.registerLazySingleton<BasePayslipRepository>(
  () => PayslipRepositoryImpl(remoteDataSource: sl()),
);

// Payslips - Use Case
sl.registerLazySingleton(() => GetPayslipsUseCase(sl()));

// Payslips - Provider
sl.registerFactory(() => PayslipProvider(getPayslipsUseCase: sl()));

  }
}
