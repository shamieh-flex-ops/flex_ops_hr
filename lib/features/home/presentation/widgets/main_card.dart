import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  const MainCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor = AppColors.iconColorDarkBlue,
    this.iconBackgroundColor = AppColors.iconBgLightBlue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 30.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
