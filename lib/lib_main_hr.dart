// lib/main_hr/app_providers.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:flex_ops_hr/core/services/services_locator.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ChangePasswordProvider>()),
      ],
      child: child,
    );
  }
}
