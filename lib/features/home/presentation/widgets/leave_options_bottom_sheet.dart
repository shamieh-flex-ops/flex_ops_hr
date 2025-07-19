import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomSheetHelper {
  static void showLeaveOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const LeaveOptionsBottomSheet();
      },
    );
  }
}

class LeaveOptionsBottomSheet extends StatelessWidget {
  final double bottomNavBarHeight;
  final double fabSize;
  final double fabOffset;

  const LeaveOptionsBottomSheet({
    super.key,
    this.bottomNavBarHeight = kBottomNavigationBarHeight,
    this.fabSize = 45.0,
    this.fabOffset = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double desiredWidth = screenWidth * 0.9 > 500 ? 500.w : screenWidth * 0.6;

    final double effectiveFabAndNavBarHeight = bottomNavBarHeight + (fabSize / 2);
    final double extraSpacing = 60.0;

    final double minBottomPadding = effectiveFabAndNavBarHeight + extraSpacing;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom > minBottomPadding
            ? MediaQuery.of(context).viewInsets.bottom + 10.h
            : minBottomPadding.h,
        left: (screenWidth - desiredWidth) / 2,
        right: (screenWidth - desiredWidth) / 2,
      ),
      child: Container(
        width: desiredWidth,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 25.w),
        decoration: BoxDecoration(
          color: AppColors.iconBgLightBlue.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // الخيار الأول: Leaves
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.push('/home/time_off/request_leave');
                },
                borderRadius: BorderRadius.circular(40.r),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.primaryBlue, size: 20.sp),
                      SizedBox(height: 8.h),
                      Text(
                        'Leaves',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textDark,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 75.h,
              child: VerticalDivider(
                color: AppColors.textDark.withOpacity(0.5),
                thickness: 1,
                indent: 8.h,
                endIndent: 8.h,
              ),
            ),

            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.push('/home/time_off/request_time_off');
                },
                borderRadius: BorderRadius.circular(15.r),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_off_outlined, color: AppColors.primaryBlue, size: 20.sp),
                      SizedBox(height: 8.h),
                      Text(
                        'Time Off',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textDark,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
