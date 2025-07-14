// lib/main.dart

import 'package:flex_ops_hr/core/services/services_locator.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/screens/login_screen.dart';
import 'package:flex_ops_hr/lib_main_hr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServicesLocator().init();
  final shouldLogin = await shouldAutoLogin();

  runApp(FlexOpsApp(shouldLogin: shouldLogin));
}

class FlexOpsApp extends StatelessWidget {
  final bool shouldLogin;

  const FlexOpsApp({super.key, required this.shouldLogin});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: ScreenUtilInit(
        designSize: const Size(412, 917),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flex Ops HR',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo),
            home:
            // shouldLogin ? const PlaceholderHomeScreen() :
            
             const LoginScreen(),
          );
        },
      ),
    );
  }
}

Future<bool> shouldAutoLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final remember = prefs.getBool('remember_me') ?? false;
  final token = prefs.getString('token');
  return remember && token != null && token.isNotEmpty;
}

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Logged in ✅')),
    );
  }
}
