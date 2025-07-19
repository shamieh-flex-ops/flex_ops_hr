// lib/config/router/app_router.dart

import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/presentation/screens/create_resignation_screen.dart';
import 'package:flex_ops_hr/features/resignation/presentation/screens/resignation_status_details_page.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/screens/request_leave_page.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/screens/request_time_off_page.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/screens/time_off_status_details_page.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/screens/time_off_status_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// استيرادات الشاشات والكيانات الأساسية
import 'package:flex_ops_hr/features/auth_screens/presentation/screens/login_screen.dart';
import 'package:flex_ops_hr/features/home/presentation/screens/home_screen.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';
import 'package:flex_ops_hr/features/loans/presentation/screens/create_loan_screen.dart';
import 'package:flex_ops_hr/features/loans/presentation/screens/loan_status_details_page.dart';
import 'package:flex_ops_hr/features/loans/presentation/screens/loans_screen.dart';
import 'package:flex_ops_hr/features/payslips/presentation/screens/payslips_screen.dart';
import 'package:flex_ops_hr/features/resignation/presentation/screens/resignation_screen.dart';
import 'package:flex_ops_hr/features/profile/presentation/pages/profile_details_page.dart';

// <--- استيراد صفحة MyLeavesInfoPage
import 'package:flex_ops_hr/features/timeoff/presentation/screens/my_leaves_info_page.dart';

GoRouter appRouter(bool shouldLogin) {
  return GoRouter(
    initialLocation: shouldLogin ? '/home' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'payslips',
            builder: (context, state) => const PayslipsPage(),
          ),
          GoRoute(
            path: 'time_off',
            // المسار الرئيسي لميزة الوقت البديل: /home/time_off
            builder: (context, state) => const TimeOffStatusPage(),
            routes: [
              GoRoute(
                path: 'status_details',
                builder: (context, state) {
                  final group = state.extra as TimeOffStatusGroupEntity;
                  return TimeOffStatusDetailsPage(group: group);
                },
              ),
              GoRoute(
                path: 'request_leave', // : /home/time_off/request_leave
                builder: (context, state) => const RequestLeavePage(),
              ),
              GoRoute(
                path: 'create_general_time_off',
                // مثال: /home/time_off/create_general_time_off
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                        title: const Text('General Time Off Request (WIP)')),
                    body: const Center(
                        child: Text(
                            'This screen will handle general time off requests.')),
                  );
                },
              ),
              GoRoute(
                path: 'request_time_off', // /home/time_off/request_time_off
                builder: (context, state) => const RequestTimeOffPage(),
              ),
              GoRoute(
                path: 'my_leaves_info', //  /home/time_off/my_leaves_info
                builder: (context, state) => const MyLeavesInfoPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'loans',
            builder: (context, state) => const LoansScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateLoanScreen(),
              ),
              GoRoute(
                path: 'loan_details',
                builder: (context, state) {
                  final group = state.extra as LoanGroup;
                  return LoanStatusDetailsPage(group: group);
                },
              ),
            ],
          ),
          GoRoute(
              path: 'resignations', // /home/resignations/create
              builder: (context, state) => const ResignationScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (context, state) => const CreateResignationScreen(),
                ),
                GoRoute(
                  path: 'resignation_details',
                  // /home/resignations/resignation_details
                  builder: (context, state) {
                    final group = state.extra
                        as ResignationGroup; // Corrected type casting
                    return ResignationStatusDetailsPage(group: group);
                  },
                ),
              ]),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileDetailsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
