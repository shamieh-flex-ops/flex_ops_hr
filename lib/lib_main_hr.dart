// lib/main_hr/app_providers.dart

import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_request_provider.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';
import 'package:flex_ops_hr/features/profile/presentation/controller/profile_provider.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:flex_ops_hr/core/services/services_locator.dart';

import 'features/leaves/presentation/controller/leave_status_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ChangePasswordProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => sl<PayslipProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LoanProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ResignationProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LeaveStatusProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LeavesRequestProvider>())



      ],
      child: child,
    );
  }
}
