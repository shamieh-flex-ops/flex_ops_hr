// lib/core/services/services_locator.dart

import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_request_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// استيرادات لميزة Auth
import 'package:flex_ops_hr/features/auth_screens/data/datasource/auth_remote_data_source.dart';
import 'package:flex_ops_hr/features/auth_screens/data/repository/auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';

// استيرادات لميزة Profile
import 'package:flex_ops_hr/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:flex_ops_hr/features/profile/data/repository/profile_repository_impl.dart';
import 'package:flex_ops_hr/features/profile/domain/repository/base_profile_repository.dart';
import 'package:flex_ops_hr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:flex_ops_hr/features/profile/presentation/controller/profile_provider.dart';

// استيرادات لميزة Payslips
import 'package:flex_ops_hr/features/payslips/data/datasources/payslip_remote_data_source.dart';
import 'package:flex_ops_hr/features/payslips/data/repositories/payslip_repository_impl.dart';
import 'package:flex_ops_hr/features/payslips/domain/repositories/base_payslip_repository.dart';
import 'package:flex_ops_hr/features/payslips/domain/usecases/get_payslips_usecase.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';

// استيرادات لميزة Loans
import 'package:flex_ops_hr/features/loans/data/datasources/loan_remote_data_source.dart';
import 'package:flex_ops_hr/features/loans/data/repositories/loan_repository_impl.dart';
import 'package:flex_ops_hr/features/loans/domain/repositories/base_loan_repository.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/get_loan_groups_usecase.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';

// استيرادات لميزة Resignation
import 'package:flex_ops_hr/features/resignation/data/datasources/resignation_remote_data_source.dart';
import 'package:flex_ops_hr/features/resignation/data/repositories/resignation_repository_impl.dart';
import 'package:flex_ops_hr/features/resignation/domain/repositories/base_resignation_repository.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/get_resignation_groups_usecase.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';

// استيرادات لميزة LEAVES (دمج Leaves Request و Leaves Status تحت مظلة واحدة إذا كان الريبو نفسه)
import 'package:flex_ops_hr/features/leaves/data/datasource/base_leaves_request_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/leaves_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/leaves_request_remote_data_source_impl.dart';
import 'package:flex_ops_hr/features/leaves/data/repository/leaves_repository_impl.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leaves_request_repository.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leave_repository.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/get_leave_types_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/request_leave_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/request_time_off_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/get_leave_status_groups_usecase.dart';
import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_status_provider.dart';


final sl = GetIt.instance;

class ServicesLocator {
  // ✅ دالة init() الآن ليست ثابتة (non-static)
  Future<void> init() async {
    // ⚠️ تم إزالة sl.reset() لأنه يحتاج دالة ثابتة ليعمل بشكل آمن
    // هذا يعني أنك قد ترى أخطاء "already registered" عند Hot Restart في بيئة التطوير.
    // لحلها، ستحتاج إلى Full Restart (إعادة تشغيل كاملة للتطبيق) بدلاً من Hot Restart.

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
    sl.registerFactory(
            () => ResignationProvider(getResignationGroupsUseCase: sl()));

    // =================== LEAVES (ميزة الإجازات - دمج الطلبات والحالة) ===================

    // Data Sources
    sl.registerLazySingleton<BaseLeavesRequestRemoteDataSource>(
          () => LeavesRequestRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<LeavesRemoteDataSource>(
          () => LeavesRemoteDataSourceImpl(sl()),
    );

    // Repository
    // ✅ هذا هو التسجيل الوحيد لـ BaseLeavesRequestRepository
    sl.registerLazySingleton<BaseLeavesRequestRepository>(
          () => LeavesRequestRepositoryImpl(sl()),
    );
    // إذا كان BaseLeaveRepository مختلفًا عن BaseLeavesRequestRepository،
    // وتطبق LeavesRepositoryImpl كلاهما
    sl.registerLazySingleton<LeavesRepository>(
          () => LeavesRequestRepositoryImpl(sl()), // تأكد أن LeavesRepositoryImpl يطبق BaseLeaveRepository
    );


    // Use Cases for Leaves Request (الطلبات)
    sl.registerLazySingleton(() => GetLeaveTypesUseCase(sl()));
    sl.registerLazySingleton(() => RequestTimeOffUseCase(sl()));
    sl.registerLazySingleton(() => RequestLeaveUseCase(sl()));

    // Use Cases for Leaves Status (الحالة)
    sl.registerLazySingleton(() => GetLeaveStatusGroupsUseCase(sl()));

    // Providers
    sl.registerFactory(
          () => LeavesRequestProvider(
        getLeaveTypesUseCase: sl(),
        requestTimeOffUseCase: sl(),
        requestLeaveUseCase: sl(),
      ),
    );
    sl.registerFactory(() => LeaveStatusProvider(
      getLeaveStatusGroupsUseCase: sl(),
    ));
  }
}