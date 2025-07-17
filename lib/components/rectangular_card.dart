import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/app_theme.dart';

class RectangularCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? badgeCount;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color cardBackgroundColor;
  final VoidCallback onTap;

  const RectangularCard({
    super.key,
    required this.title,
    required this.icon,
    this.badgeCount,
    this.iconColor = AppColors.white,
    this.iconBackgroundColor = AppColors.primaryBlue,
    this.cardBackgroundColor = AppColors.cardBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0.r),
      ),
      color: cardBackgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0.r),
        child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: CircleAvatar(
                        backgroundColor: iconBackgroundColor,
                        child: Icon(
                          icon,
                          size: 24.sp,
                          color: iconColor,
                        ),
                      ),
                    ),
                    if (badgeCount != null && badgeCount! > 0)
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18.w,
                            minHeight: 18.h,
                          ),
                          child: Center(
                            child: Text(
                              '$badgeCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Flexible(
                flex: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
