// lib/core/services/services_locator.dart

import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/iqama/data/datasources/iqama_remote_data_source.dart';
import 'package:flex_ops_hr/features/iqama/data/repository/iqama_repository_impl.dart';
import 'package:flex_ops_hr/features/iqama/domain/repository/base_iqama_repository.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/create_iqama_renewal_usecase.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/get_iqama_renewal_groups_usecase.dart';
import 'package:flex_ops_hr/features/iqama/presentation/controller/iqama_provider.dart';

import 'package:flex_ops_hr/features/loans/data/datasources/loan_remote_data_source.dart';
import 'package:flex_ops_hr/features/loans/data/repositories/loan_repository_impl.dart';
import 'package:flex_ops_hr/features/loans/domain/repositories/base_loan_repository.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/get_loan_groups_usecase.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flex_ops_hr/features/payslips/data/datasources/payslip_remote_data_source.dart';
import 'package:flex_ops_hr/features/payslips/data/repositories/payslip_repository_impl.dart';
import 'package:flex_ops_hr/features/payslips/domain/repositories/base_payslip_repository.dart';
import 'package:flex_ops_hr/features/payslips/domain/usecases/get_payslips_usecase.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';
import 'package:flex_ops_hr/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:flex_ops_hr/features/resignation/data/datasources/resignation_remote_data_source.dart';
import 'package:flex_ops_hr/features/resignation/data/repositories/resignation_repository_impl.dart';
import 'package:flex_ops_hr/features/resignation/domain/repositories/base_resignation_repository.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/get_resignation_groups_usecase.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flex_ops_hr/features/timeoff/data/datasource/base_time_off_remote_data_source.dart';
import 'package:flex_ops_hr/features/timeoff/data/datasource/time_off_remote_data_source_impl.dart';
import 'package:flex_ops_hr/features/timeoff/data/repositries/time_off_repository_impl.dart';
import 'package:flex_ops_hr/features/timeoff/domain/repositries/base_time_off_repository.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/create_time_off_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/get_available_leave_types_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/get_time_off_status_groups_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/create_time_off_request_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';

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

    // =================== AUTH ===================
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<BaseAuthRepository>(
      () => AuthRepository(sl()),
    );
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
    sl.registerFactory(() => LoginProvider(loginUseCase: sl()));
    sl.registerLazySingleton(
        () => ChangePasswordProvider(changePasswordUseCase: sl()));

    // =================== PROFILE ===================
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    );
    sl.registerLazySingleton(() => GetUserProfile(sl()));
    sl.registerFactory(() => ProfileProvider(getUserProfileUseCase: sl()));

    // =================== PAYSLIPS ===================
    sl.registerLazySingleton<PayslipRemoteDataSource>(
      () => PayslipRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<BasePayslipRepository>(
      () => PayslipRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton(() => GetPayslipsUseCase(sl()));
    sl.registerFactory(() => PayslipProvider(getPayslipsUseCase: sl()));

    // =================== LOANS ===================
    sl.registerLazySingleton<LoanRemoteDataSource>(
        () => LoanRemoteDataSourceImpl(sl()));
    sl.registerLazySingleton<BaseLoanRepository>(
        () => LoanRepositoryImpl(sl()));
    sl.registerLazySingleton(() => GetLoanGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateLoanUseCase(sl()));
    sl.registerFactory(() =>
        LoanProvider(getLoanGroupsUseCase: sl(), createLoanUseCase: sl()));

    // =================== RESIGNATION ===================
    sl.registerLazySingleton<ResignationRemoteDataSource>(
      () => ResignationRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<BaseResignationRepository>(
      () => ResignationRepositoryImpl(sl()),
    );
    sl.registerLazySingleton(() => GetResignationGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateResignationUseCase(sl()));
    sl.registerFactory(() => ResignationProvider(
        getResignationGroupsUseCase: sl(), createResignationUseCase: sl()));

    // =================== TIME_OFF ===================
    // Data Sources
    sl.registerLazySingleton<BaseTimeOffRemoteDataSource>(
      () => TimeOffRemoteDataSourceImpl(sl()),
    );

    // Repository
    sl.registerLazySingleton<BaseTimeOffRepository>(
      () => TimeOffRepositoryImpl(sl()),
    );

    // Use Cases for Time Off Request & Status
    sl.registerLazySingleton(() => GetTimeOffStatusGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateTimeOffUseCase(sl()));
    sl.registerLazySingleton(() => GetAvailableLeaveTypesUseCase(sl()));

    // Providers
    sl.registerFactory(
      () => CreateTimeOffRequestProvider(
        createTimeOffUseCase: sl(),
      ),
    );

    sl.registerFactory(() => TimeOffStatusProvider(
          getTimeOffStatusGroupsUseCase: sl(),
          getAvailableLeaveTypesUseCase: sl(),
        ));
    // =================== IQAMA ===================

    // Iqama - Data Source
    sl.registerLazySingleton<IqamaRemoteDataSource>(
      () => IqamaRemoteDataSourceImpl(dio: sl()),
    );

    // Iqama - Repository
    sl.registerLazySingleton<BaseIqamaRepository>(
      () => IqamaRepositoryImpl(sl()),
    );

    // Iqama - Use Case
    sl.registerLazySingleton(() => GetIqamaRenewalGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateIqamaRenewalUseCase(sl()));

    // Iqama - Provider
    sl.registerFactory(() => IqamaProvider(
          getIqamaRenewalGroupsUseCase: sl(),
          createIqamaRenewalUseCase: sl(),
        ));
  }
}
