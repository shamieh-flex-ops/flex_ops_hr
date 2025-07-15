// lib/main.dart

import 'package:flex_ops_hr/core/services/services_locator.dart';
import 'package:flex_ops_hr/core/utils/app_router.dart';
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
          return MaterialApp.router(
            title: 'Flex Ops HR',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo),
            routerConfig: appRouter(shouldLogin),
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
