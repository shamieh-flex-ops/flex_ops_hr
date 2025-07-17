import 'package:flex_ops_hr/features/auth_screens/presentation/screens/login_screen.dart';
import 'package:flex_ops_hr/features/home/presentation/screens/home_screen.dart';
import 'package:flex_ops_hr/features/loans/presentation/screens/create_loan_screen.dart';
import 'package:flex_ops_hr/features/loans/presentation/screens/loans_screen.dart';
import 'package:flex_ops_hr/features/payslips/presentation/screens/payslips_screen.dart';
import 'package:flex_ops_hr/features/resignation/presentation/screens/resignation_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/leaves/domain/entities/leave_status_group.dart';
import '../../features/leaves/presentation/screens/leaves_status_details_page.dart';
import '../../features/leaves/presentation/screens/leaves_status_page.dart';
import '../../features/profile/presentation/pages/profile_details_page.dart';

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
            path: 'leaves',
            builder: (context, state) => const LeavesStatusPage(),
            routes: [
              GoRoute(
                path: 'status_details',
                builder: (context, state) {
                  final group = state.extra as LeaveStatusGroup;
                  return LeaveStatusDetailsPage(group: group);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/loans',
            builder: (context, state) => const LoansScreen(),
          ),
          GoRoute(
            path: 'loans/create',
            builder: (context, state) => const CreateLoanScreen(),
          ),
          GoRoute(
            path: 'resignations',
            builder: (context, state) => const ResignationScreen(),
          ),
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
