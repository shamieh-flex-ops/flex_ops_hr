import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomNavBarWithFab extends StatelessWidget {
  const BottomNavBarWithFab({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return BottomAppBar(
      color: AppColors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.r,
      child: SizedBox(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(0, context),
                customBorder: const CircleBorder(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 24.sp,
                      color: selectedIndex == 0 ? AppColors.primaryBlue : AppColors.textMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Home',
                      style: AppTextStyles.bottomNavItemText.copyWith(
                        fontSize: 12.sp,
                        color: selectedIndex == 0 ? AppColors.primaryBlue : AppColors.textMedium,
                        fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(1, context),
                customBorder: const CircleBorder(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 24.sp,
                      color: selectedIndex == 1 ? AppColors.primaryBlue : AppColors.textMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Profile',
                      style: AppTextStyles.bottomNavItemText.copyWith(
                        fontSize: 12.sp,
                        color: selectedIndex == 1 ? AppColors.primaryBlue : AppColors.textMedium,
                        fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
