import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/iqama/data/datasources/iqama_remote_data_source.dart';
import 'package:flex_ops_hr/features/iqama/data/repository/iqama_repository_impl.dart';
import 'package:flex_ops_hr/features/iqama/domain/repository/base_iqama_repository.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/create_iqama_renewal_usecase.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/get_iqama_renewal_groups_usecase.dart';
import 'package:flex_ops_hr/features/iqama/presentation/controller/iqama_provider.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/leaves_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/data/repository/leaves_repository_impl.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leave_repository.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/get_leave_status_groups_usecase.dart';
import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_status_provider.dart';
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

    // =================== PROFILE ===================
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

    // =================== PAYSLIPS ===================
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

    // =================== LOANS ===================
    // LOANS - Data Source
    sl.registerLazySingleton<LoanRemoteDataSource>(
        () => LoanRemoteDataSourceImpl(sl()));
    // LOANS - Repository
    sl.registerLazySingleton<BaseLoanRepository>(
        () => LoanRepositoryImpl(sl()));
    // LOANS - Use Case
    sl.registerLazySingleton(() => GetLoanGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateLoanUseCase(sl()));

    // LOANS - Provider
    sl.registerFactory(() => LoanProvider(getLoanGroupsUseCase: sl(), createLoanUseCase: sl()));
        // =================== Resignation ===================

// Resignation - Data Source
sl.registerLazySingleton<ResignationRemoteDataSource>(
  () => ResignationRemoteDataSourceImpl(dio: sl()),
);

// Resignation - Repository
sl.registerLazySingleton<BaseResignationRepository>(
  () => ResignationRepositoryImpl(sl()),
);

// Resignation - Use Case
sl.registerLazySingleton(() => GetResignationGroupsUseCase(sl()));
    sl.registerLazySingleton(() => CreateResignationUseCase(sl()));


// Resignation - Provider
sl.registerFactory(() => ResignationProvider(getResignationGroupsUseCase: sl(), createResignationUseCase: sl()));



    /// Time-Off - Data Source
    sl.registerLazySingleton<LeavesRemoteDataSource>(
          () => LeavesRemoteDataSourceImpl(sl()),
    );

// Time-Off - Repository
    sl.registerLazySingleton<LeavesRepository>(
          () => LeavesRepositoryImpl(sl()),
    );

// Time-Off - Use Case
    sl.registerLazySingleton(() => GetLeaveStatusGroupsUseCase(sl()));

// Time-Off - Provider (بعد التعديل على نفس مبدأ PayslipProvider)
    sl.registerFactory(() => LeaveStatusProvider(
      getLeaveStatusGroupsUseCase: sl(),
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
